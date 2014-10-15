package uniontool.co.jp.whs_2_android_with_wear;

import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataMap;
import com.google.android.gms.wearable.DataMapItem;

/**
 * Handheld側から受信したデータを取得するためのクラス.
 */
public class ReceivedData {
    /**
     * DataEventから心拍数の文字列を取得する.
     * @param event データイベント
     * @return 心拍数の文字列
     */
    public static String getHeartRate(DataEvent event) {
        return Integer.toString(getDataMap(event).getInt(Constants.KEY_HEARTRATE, 0));
    }

    /**
     * DataEventから体動の文字列を取得する.
     * @param event データイベント
     * @return 体動の文字列(小数点第2位まで)
     */
    public static String getMoving(DataEvent event) {
        return String.format("%.2f", getDataMap(event).getDouble(Constants.KEY_MOVING, 0));
    }

    /**
     * DataEventから体表温の文字列を取得する.
     * @param event データイベント
     * @return 体表温の文字列(小数点第1位まで)
     */
    public static String getTemperature(DataEvent event) {
        return String.format("%.1f", getDataMap(event).getDouble(Constants.KEY_TEMPERATURE, 0));
    }

    /**
     * データイベントに格納されているデータマップを取得する.
     * @param event データイベント
     * @return 格納されているデータマップ
     */
    private static DataMap getDataMap(DataEvent event) {
        return DataMapItem.fromDataItem(event.getDataItem()).getDataMap();
    }

}
