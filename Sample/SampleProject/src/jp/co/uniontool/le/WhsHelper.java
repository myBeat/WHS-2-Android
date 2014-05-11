package jp.co.uniontool.le;

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
	public static final String INTENT_DATETIME = "jp.co.uniontool.INTENT_DATETIME";
	public static final String INTENT_HEART_RATE = "jp.co.uniontool.INTENT_HEART_RATE";
	public static final String INTENT_RECEIVED_OBJ = "jp.co.uniontool.INTENT_RECEIVED_OBJ";
	public static final String INTENT_ADDRESS = "jp.co.uniontool.INTENT_ADDRESS";
	public static final String INTENT_MODE = "jp.co.uniontool.INTENT_MODE";
	public static final String INTENT_COMMAND = "jp.co.uniontool.INTENT_COMMAND";
	public static final String INTENT_VALUE = "jp.co.uniontool.INTENT_RESULT";
}
