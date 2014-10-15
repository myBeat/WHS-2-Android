package uniontool.co.jp.whs_2_android_with_wear;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

import com.google.android.gms.common.data.FreezableUtils;
import com.google.android.gms.wearable.DataApi;
import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataEventBuffer;

import java.util.List;

/**
 * Whs-2-Androidアプリから受信したデータを表示するためのクラス.
 */
public class Whs2WearActivity extends Activity implements DataApi.DataListener {
    /** 心拍数表示用テキストビューインスタンス. */
    private TextView mHeartRateTextView;
    /** 体動表示用テキストビューインスタンス. */
    private TextView mMovingTextView;
    /** 体表温表示用テキストビューインスタンス. */
    private TextView mTemperatureTextView;
    /** GoogleApiClientControllerインスタンス. */
    private GoogleApiClientController mGoogleApiClientController;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_whs2_wear_linear);
        mGoogleApiClientController = new GoogleApiClientController(this, this);
        mHeartRateTextView = (TextView) findViewById(R.id.heart_rate);
        mMovingTextView = (TextView) findViewById(R.id.moving);
        mTemperatureTextView = (TextView) findViewById(R.id.temperature);
    }

    @Override
    protected  void onStart() {
        super.onStart();
        mGoogleApiClientController.connectWearDevice();
    }

    @Override
    protected  void onStop() {
        super.onStop();
        mGoogleApiClientController.disconnectWearDevice();
    }

    @Override
    public void onDataChanged(DataEventBuffer dataEvents) {
        final List<DataEvent> events = FreezableUtils.freezeIterable(dataEvents);
        dataEvents.close();

        for (final DataEvent event : events) {
            if (isDataChanged(event)) {
                changeTextViewContent(event);
            }
        }
    }

    /**
     * WHS-2のアプリからのデータが更新されたかどうか判定する.
     * @param event Handheld側から受信したデータイベント
     * @return データが更新されたかどうかの判定結果
     */
    private boolean isDataChanged(DataEvent event) {
        return event.getType() == DataEvent.TYPE_CHANGED
                && Constants.PATH_NOTIFICATION.equals(event.getDataItem().getUri().getPath());
    }

    /**
     * DataApiから更新を受け取った際に対応するテキストビューの内容を変更する.
     * @param event 更新時のDataEvent
     */
    private void changeTextViewContent(final DataEvent event) {
        if (isDataChanged(event)) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mHeartRateTextView.setText(
                            ReceivedData.getHeartRate(event) + getString(R.string.hr_unit));
                    mMovingTextView.setText(
                            ReceivedData.getMoving(event) + getString(R.string.mv_unit));
                    mTemperatureTextView.setText(
                            ReceivedData.getTemperature(event) + getString(R.string.temp_unit));
                }
            });
        }
    }

}
