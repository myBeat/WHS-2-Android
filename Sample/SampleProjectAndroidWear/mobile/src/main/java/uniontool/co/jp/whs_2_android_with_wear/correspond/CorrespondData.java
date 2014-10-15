package uniontool.co.jp.whs_2_android_with_wear.correspond;

import com.google.android.gms.wearable.PutDataMapRequest;
import com.google.android.gms.wearable.PutDataRequest;

import uniontool.co.jp.whs_2_android_with_wear.Constants;
import uniontool.co.jp.whs_2_android_with_wear.receiveddata.RriPeakData;
import uniontool.co.jp.whs_2_android_with_wear.receiveddata.SerializableReceivedData;

/**
 * Wearデバイスへ送信するデータリクエストを生成するためのクラス.
 * RriPeakData以外には対応しない.
 */
public class CorrespondData {
    /** 心拍周期かつ加速度ピークホールドモード判定. */
    private boolean mIsRriPeakData;
    /** 受信データ. */
    SerializableReceivedData mData;

    /**
     * コンストラクタ.
     * 渡されたSerializableReceivedDataがRriPeakData型を実装しているかどうかの判定も行う.
     * @param data 受信したデータ.
     */
    public CorrespondData(final SerializableReceivedData data) {
        mData = data;
        mIsRriPeakData = data instanceof RriPeakData;
    }

    /**
     * Wear側に送信するデータリクエストを作成する.
     * コンストラクタに渡されたオブジェクトがRriPeakDatagata型に実装せれていない場合は例外を返す.
     * @return 送信するデータリクエスト
     */
    public PutDataRequest createDataRequest() {
        if (!mIsRriPeakData) {
            throw new IllegalArgumentException();
        }
        double moving = Math.sqrt(Math.pow(mData.getAccelerationX(), 2)
                + Math.pow(mData.getAccelerationY(), 2)
                + Math.pow(mData.getAccelerationZ(), 2)) - 1D;
        PutDataMapRequest putDataMapRequest = PutDataMapRequest.create(Constants.PATH_NOTIFICATION);
        putDataMapRequest.getDataMap().putInt(Constants.KEY_HEARTRATE, 60000 / mData.getEcg());
        putDataMapRequest.getDataMap().putDouble(Constants.KEY_TEMPERATURE, mData.getTemperature());
        putDataMapRequest.getDataMap().putDouble(Constants.KEY_MOVING, moving);

        return putDataMapRequest.asPutDataRequest();
    }

}
