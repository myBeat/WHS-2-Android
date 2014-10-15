package uniontool.co.jp.whs_2_android_with_wear;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.wearable.DataApi;
import com.google.android.gms.wearable.Wearable;

import java.util.concurrent.TimeUnit;

import uniontool.co.jp.whs_2_android_with_wear.common.R;

/**
 * Android Wear上でGoogleApiClientを操作するクラス.
 * GoogleApiClientの初期設定、接続、切断の操作が可能.
 */
public class GoogleApiClientController implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    /** タグ. */
    private static final String TAG = GoogleApiClientController.class.getSimpleName();
    /** タイムアウトまでの時間. */
    private static final int TIMEOUT = 30;
    /** GoogleApiClientインスタンス. */
    private GoogleApiClient mGoogleApiClient;
    /** 親クラスのコンテキスト. */
    private Context mContext;
    /** GoogleApiClientに登録するDataListener. */
    private DataApi.DataListener mDataListener;
    /** Activity判定(WearableListenerServiceを継承したクラスから呼び出されたかどうかの判定). */
    private boolean mIsActivity;

    /**
     * コンストラクタ.
     * コンストラクタ生成時にGoogleApiClientの初期設定を行う.
     * WearableListenerServiceを継承しているクラスから呼び出す場合は第2引数にNullを指定する.
     * @param context 親クラスのコンテキスト.
     * @param dataListener DataListener
     */
    public GoogleApiClientController(Context context, DataApi.DataListener dataListener) {
        mContext = context;
        mDataListener = dataListener;
        mIsActivity = mDataListener != null;
        setGoogleApiClient(context);
    }

    @Override
    public void onConnected(Bundle bundle) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_success));
        if (mIsActivity) {
            Wearable.DataApi.addListener(mGoogleApiClient, mDataListener);
        }
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_suspended));

    }

    @Override
    public void onConnectionFailed(ConnectionResult result) {
        Log.i(TAG, mContext.getString(R.string.googleapiclient_connection_failed) + result.getErrorCode());
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
            if (mIsActivity) {
                Wearable.DataApi.removeListener(mGoogleApiClient, mDataListener);
            }

            mGoogleApiClient.disconnect();
        }
    }

    /**
     * GoogleApiClientに接続する.
     * @return 接続成否.
     */
    public boolean isConnected() {
        return mGoogleApiClient.isConnected();
    }

    /**
     * GoogleApiClientへの接続処理の結果を取得する.
     * 指定されている秒数が経過した場合、接続タイムアウトとなる.
     * (現状30秒でタイムアウトと設定.)
     * @return 対象のConnectionResult
     */
    public ConnectionResult getConnectionResult() {
        return mGoogleApiClient.blockingConnect(TIMEOUT, TimeUnit.SECONDS);
    }

    /**
     * Wear側との通信を行うためのGoogleApiClientを設定する.
     * @param context 親クラスのコンテクスト
     */
    private void setGoogleApiClient(Context context) {
        mGoogleApiClient = new GoogleApiClient.Builder(context)
                .addApi(Wearable.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();
    }
}
