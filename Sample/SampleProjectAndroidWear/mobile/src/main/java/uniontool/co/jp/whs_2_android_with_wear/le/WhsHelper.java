package uniontool.co.jp.whs_2_android_with_wear.le;

public class WhsHelper {
	/**
	 * 計測モードでの受信値
	 */
	public static final int MEASURE_PACKET_BEHAVIOR_PQRST = 0;
	public static final int MEASURE_PACKET_BEHAVIOR_RRI = 1;
	public static final int MEASURE_PACKET_BEHAVIOR_NONE = -1;
	public static final int MEASURE_PACKET_ACCELERATION_AVERAGE = 0;
	public static final int MEASURE_PACKET_ACCELERATION_PEAK = 1;
	public static final int MEASURE_PACKET_ACCELERATION_NONE = -1;
    
	/**
	 * 設定モードでの受信値
	 */
	public static final String SETTING_VALUE_BEHAVIOR_PQRST = "1";
	public static final String SETTING_VALUE_BEHAVIOR_RRI = "2";
	public static final String SETTING_VALUE_ACCELERATION_AVERAGE = "0";
	public static final String SETTING_VALUE_ACCELERATION_PEAK = "1";
	public static final String SETTING_RESULT_OK = "OK";
	
	/**
	 * ServiceとActivity間のデータの受け渡し用のキー
	 */
	public static final String INTENT_DATETIME = "uniontool.co.jp.INTENT_DATETIME";
	public static final String INTENT_HEART_RATE = "uniontool.co.jp.INTENT_HEART_RATE";
	public static final String INTENT_RECEIVED_OBJ = "uniontool.co.jp.INTENT_RECEIVED_OBJ";
	public static final String INTENT_ADDRESS = "uniontool.co.jp.INTENT_ADDRESS";
	public static final String INTENT_MODE = "uniontool.co.jp.INTENT_MODE";
	public static final String INTENT_COMMAND = "uniontool.co.jp.INTENT_COMMAND";
	public static final String INTENT_VALUE = "uniontool.co.jp.INTENT_RESULT";
}
