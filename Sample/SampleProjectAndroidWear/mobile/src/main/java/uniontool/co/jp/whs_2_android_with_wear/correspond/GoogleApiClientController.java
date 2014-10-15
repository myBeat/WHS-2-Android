package uniontool.co.jp.whs_2_android_with_wear.correspond;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.wearable.DataApi;
import com.google.android.gms.wearable.MessageApi;
import com.google.android.gms.wearable.Node;
import com.google.android.gms.wearable.NodeApi;
import com.google.android.gms.wearable.Wearable;

import uniontool.co.jp.whs_2_android_with_wear.Constants;
import uniontool.co.jp.whs_2_android_with_wear.R;
import uniontool.co.jp.whs_2_android_with_wear.receiveddata.SerializableReceivedData;

/**
 * Handheld側でGoogleApiClientを操作するクラス.
 * GoogleApiClientの初期設定、接続、切断の操作が可能.
 */
public class GoogleApiClientController implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    /** タグ. */
    private static final String TAG = GoogleApiClientController.class.getSimpleName();
    /** GoogleApiClientのインスタンス. */
    private GoogleApiClient mGoogleApiClient;
    /** コンテクスト. */
    private Context mContext;

    /**
     * コンストラクタ.
     * 生成時にGoogleApiClientの初期設定を行う.
     * @param context コンテキスト
     */
    public GoogleApiClientController(final Context context) {
        mContext = context;
        setGoogleApiClient(mContext);
    }

    /**
     * Wear側と接続する.
     * mGoogleApiClientの設定ができていない場合は何もしない.
     */
    public void connectWearDevice() {
        if (mGoogleApiClient == null) {
            return;
        }

        if (!mGoogleApiClient.isConnected()) {
            mGoogleApiClient.connect();
        }
    }

    /**
     * Wear側との接続を切断する.
     * mGoogleApiClientの設定ができていない場合は何もしない.
     */
    public void disconnectWearDevice() {
        if (mGoogleApiClient == null) {
            return;
        }

        if (mGoogleApiClient.isConnected()) {
            mGoogleApiClient.disconnect();
        }
    }

    /**
     * Wear側にデータを送信する.
     * エラー処理：
     * IllegalExceptionが発生した場合、ログに残し、データを送信しない.
     * @param receivedData WHS-2から受信したデータ.
     */
    public void sendData(final SerializableReceivedData receivedData) {
        CorrespondData data = new CorrespondData(receivedData);
        try{
            Wearable.DataApi.putDataItem(mGoogleApiClient, data.createDataRequest())
                    .setResultCallback(new ResultCallback<DataApi.DataItemResult>() {
                        @Override
                        public void onResult(DataApi.DataItemResult dataItemResult) {
                            Log.d(TAG, mContext.getString(R.string.result_put_data)
                                    + dataItemResult.getStatus().toString());
                        }
                    });
        } catch (IllegalArgumentException e) {
            Log.e(TAG, e.getStackTrace().toString());
        }

    }

    /**
     * Wear上のNotificationを削除する.
     * このメソッドはWHS-2との接続を切断する際にのみ使用する.
     */
    public void dismissNotification() {
        if (mGoogleApiClient.isConnected()) {
            new AsyncTask<Void, Void, Void>() {
                @Override
                protected  Void doInBackground(Void... params) {
                    NodeApi.GetConnectedNodesResult nodeList =
                            Wearable.NodeApi.getConnectedNodes(mGoogleApiClient).await();
                    for (Node node: nodeList.getNodes()) {
                        MessageApi.SendMessageResult messageResult = Wearable.MessageApi.sendMessage(
                                mGoogleApiClient, node.getId(), Constants.PATH_DISMISS, null
                        ).await();
                        if (!messageResult.getStatus().isSuccess()) {
                            Log.e(TAG, mContext.getString(R.string.fail_sending_message)
                                    + messageResult.getStatus());
                        }
                    }
                    mGoogleApiClient.disconnect();
                    return null;
                }
            }.execute();
        }
    }

    /**
     * GoogleApiClientとの接続状況を取得する.
     * @return 接続時:true, 切断時:false
     */
    public boolean isConnected() {
        return mGoogleApiClient.isConnected();
    }


    /**
     * Wear側との通信を行うためのGoogleApiClientを設定する.
     * @param context コンテクスト
     */
    private void setGoogleApiClient(final Context context) {
        try{
            mGoogleApiClient = new GoogleApiClient.Builder(context)
                    .addApi(Wearable.API)
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .build();
        } catch (NullPointerException e) {
            throw e;
        }
    }


    @Override
    public void onConnected(Bundle bundle) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_success));
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_suspended));
    }

    @Override
    public void onConnectionFailed(ConnectionResult result) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_failed)+ result.getErrorCode());
    }
}
