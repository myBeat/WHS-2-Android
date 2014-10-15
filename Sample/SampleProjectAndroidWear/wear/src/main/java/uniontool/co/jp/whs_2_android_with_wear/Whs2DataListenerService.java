package uniontool.co.jp.whs_2_android_with_wear;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;

import com.google.android.gms.common.data.FreezableUtils;
import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataEventBuffer;
import com.google.android.gms.wearable.WearableListenerService;

import java.util.List;

/**
 * Wear上でHandheld側からのデータを受信し、メイン画面に通知するサービスクラス.
 * このサービス上ではHandheld側から受信した心拍数を通知する.
 */
public class Whs2DataListenerService extends WearableListenerService {
    /** 端末上に通知する際に設定する通知ID. */
    private static final int NOTIFICATION_ID = 0;
    /** PendingIntent生成時に必要とするユニーク(リクエスト)コード */
    private static final int REQUEST_CODE = 0;
    /** GoogleApiClientControllerのインスタンス. */
    private GoogleApiClientController mGoogleApiClientController;

    @Override
    public void onCreate() {
        super.onCreate();
        mGoogleApiClientController = new GoogleApiClientController(this, null);
        mGoogleApiClientController.connectWearDevice();
    }

    @Override
    public void onDataChanged(DataEventBuffer dataEvents) {
        final List<DataEvent> eventList = FreezableUtils.freezeIterable(dataEvents);
        dataEvents.close();

        if (!isSuccessConnection()) {
            return;
        }

        for (final DataEvent event : eventList) {
            if (isDataChanged(event)) {
                NotificationCompat.Builder builder =
                        createMainNotificationCompatBuilder(createNotificationIntent(event), event);
                ((NotificationManager) getSystemService(NOTIFICATION_SERVICE))
                        .notify(NOTIFICATION_ID, builder.build());
            }
        }

    }

    /**
     * GoogleApiClientに接続済み、もしくは接続に成功したかどうか判定する.
     *
     * @return 接続済みor接続成功:true, 接続失敗:false
     */
    private boolean isSuccessConnection() {
        if (mGoogleApiClientController.isConnected())  return true;
         return mGoogleApiClientController.getConnectionResult().isSuccess();
    }

    /**
     * イベントタイプが変更、かつデータアイテムのパスがHandheld側と同じかどうかを判定する.
     *
     * @param event データイベント
     * @return イベントタイプが変更、かつデータアイテムのパスがHandheld側と同じ:true, それ以外:false
     */
    private boolean isDataChanged(DataEvent event) {
        return event.getType() == DataEvent.TYPE_CHANGED &&
                Constants.PATH_NOTIFICATION.equals(event.getDataItem().getUri().getPath());
    }

    /**
     * 通知するためのPendingIntentを生成する.
     * @param event 受信したデータイベント
     * @return 通知するためのインテント
     */
    private PendingIntent createNotificationIntent(DataEvent event) {
        Intent intent = new Intent(this, Whs2WearActivity.class);
        return PendingIntent.getActivity(this, REQUEST_CODE, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    /**
     * メイン通知を生成するためのNotificationCompatBuilderを生成する.
     * @param intent PendingIntent
     * @param event 受信したデータイベント
     * @return メイン通知を生成するためのNotificationCompatBuilder
     */
    private NotificationCompat.Builder createMainNotificationCompatBuilder(PendingIntent intent, DataEvent event) {
        NotificationCompat.WearableExtender wearableExtender =
                new NotificationCompat.WearableExtender()
                        .setHintHideIcon(true)
                        .setContentIcon(R.drawable.ic_launcher);
        return new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.hr_image)
                .setContentTitle(getString(R.string.whs2_notification))
                .setContentText(ReceivedData.getHeartRate(event) + getString(R.string.hr_unit))
                .setContentIntent(intent)
                .extend(wearableExtender);
    }
}
