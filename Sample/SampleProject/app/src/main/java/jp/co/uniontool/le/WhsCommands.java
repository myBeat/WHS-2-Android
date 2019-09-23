package jp.co.uniontool.le;

public class WhsCommands {
	/** 設定モード開始 */
	public static final int CommandSettingModeStart = 0;
	/** 設定モード終了 */
	public static final int CommandSettingModeEnd = 1;
	/** 測定モード開始 */
	public static final int CommandMeasureModeStart = 2;
	/** 動作モード、加速度モードの一括読み出し */
	public static final int CommandBehaviorAllRead = 3;
	/** 動作モード、加速度モードの一括書き込み 心拍波形 - 加速度移動平均 */
	public static final int CommandBehaviorAllWritePqrstAverage = 4;
	/** 動作モード、加速度モードの一括書き込み 心拍波形 - 加速度ピークホールド */
	public static final int CommandBehaviorAllWritePqrstPeak = 5;
	/** 動作モード、加速度モードの一括書き込み 心拍周期 - 加速度移動平均 */
	public static final int CommandBehaviorAllWriteRriAverage = 6;
	/** 動作モード、加速度モードの一括書き込み 心拍周期 - 加速度ピークホールド */
    public static final int CommandBehaviorAllWriteRriPeak = 7;
    /** 動作モードの読み込み */
    public static final int CommandBehaviorRead = 8;
    /** 動作モードの書き込み 心拍波形 */
    public static final int CommandBehaviorWritePqrst = 9;
    /** 動作モードの書き込み 心拍周期 */
    public static final int CommandBehaviorWriteRri = 10;
    /** 加速度モードの読み込み */
    public static final int CommandAccelerationRead = 11;
    /** 加速度モードの書き込　加速度移動平均 */
    public static final int CommandAccelerationWriteAverage = 12;
    /** 加速度モードの書き込　加速度ピークホールド */
    public static final int CommandAccelerationWritePeak = 13;
    /** 外装シリアル番号の読み込み */
    public static final int CommandExteriorRead = 14;
    /** 基板シリアル番号の読み込み */
    public static final int CommandSubstrateRead = 15;
    /** メインファームの読み込み */
    public static final int CommandMainFarmRead = 16;
    /** BLEファームの読み込み */
    public static final int CommandBleFarmRead = 17;
    
	/**
	 * コマンドインデックスに一致するコマンドを返す
	 * @param command
	 * @return
	 */
    public static byte[] getWriteCommandBytes(int command){
        switch (command) {
            case CommandSettingModeStart:
                return getSendCommandStartSetting();
            case CommandSettingModeEnd:
                return getSendCommandEndSetting();
            case CommandMeasureModeStart:
                return getSendCommandStartMeasure();
            case CommandBehaviorAllRead:
                return getSendCommandReadMode();
            case CommandBehaviorAllWritePqrstAverage:
                return getSendCommandWritePqrstAverage();
            case CommandBehaviorAllWritePqrstPeak:
                return getSendCommandWritePqrstPeak();
            case CommandBehaviorAllWriteRriAverage:
                return getSendCommandWriteRriAverage();
            case CommandBehaviorAllWriteRriPeak:
                return getSendCommandWriteRriPeak();
            case CommandBehaviorRead:
                return getSendCommandReadBehaviorMode();
            case CommandBehaviorWritePqrst:
                return getSendCommandWritePqrst();
            case CommandBehaviorWriteRri:
                return getSendCommandWriteRri();
            case CommandAccelerationRead:
                return getSendCommandReadAccelerationMode();
            case CommandAccelerationWriteAverage:
                return getSendCommandWriteAverage();
            case CommandAccelerationWritePeak:
                return getSendCommandWritePeak();
            case CommandExteriorRead:
                return getSendCommandReadExperiorSerial();
            case CommandSubstrateRead:
                return getSendCommandReadSubstrateSerial();
            case CommandMainFarmRead:
                return getSendCommandMainFarm();
            case CommandBleFarmRead:
                return getSendCommandBleFarm();
            default:
                return null;
        }
    }

    /**
     * A A CR 設定モード開始
     */
    private static byte[] getSendCommandStartSetting(){
        final byte writeBytes[] = {(byte)0x03 , (byte)0x41, (byte)0x41, (byte)0x0d};
        return writeBytes;
    }

    /**
     * Z Z CR　設定モード終了
     */
    private static byte[] getSendCommandEndSetting(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x5A, (byte)0x5A, (byte)0x0d};
        return writeBytes;
    }

    /**
     * S S CR　測定モード開始
     */
    private static byte[] getSendCommandStartMeasure(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x53, (byte)0x53, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 2 CR 動作モード読み出し
     */
    private static byte[] getSendCommandReadMode(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x43, (byte)0x32, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 2 PQRST平均
     */
    private static byte[] getSendCommandWritePqrstAverage(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x31, (byte)0x2c, (byte)0x31, (byte)0x30, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 2 PQRSTピーク
     */
    private static byte[] getSendCommandWritePqrstPeak(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x31, (byte)0x2c, (byte)0x31, (byte)0x31, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 2 RRI平均
     */
    private static byte[] getSendCommandWriteRriAverage(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x31, (byte)0x2c, (byte)0x32, (byte)0x30, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 2 RRIピーク
     */
    private static byte[] getSendCommandWriteRriPeak(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x31, (byte)0x2c, (byte)0x32, (byte)0x31, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 4 CR 動作モード読み出し
     */
    private static byte[] getSendCommandReadBehaviorMode(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x43, (byte)0x34, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 4 PQRST 書込み
     */
    private static byte[] getSendCommandWritePqrst(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x34, (byte)0x2c, (byte)0x31, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 4 RRI 書込み
     */
    private static byte[] getSendCommandWriteRri(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x34, (byte)0x2c, (byte)0x32, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 5 CR 加速度モード読み出し
     */
    private static byte[] getSendCommandReadAccelerationMode(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x43, (byte)0x35, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 5 加速度　平均 書込み
     */
    private static byte[] getSendCommandWriteAverage(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x35, (byte)0x2c, (byte)0x30, (byte)0x0d};
        return writeBytes;
    }

    /**
     * C 5 加速度　ピーク 書込み
     */
    private static byte[] getSendCommandWritePeak(){
        final byte writeBytes[] = {(byte)0x06, (byte)0x43, (byte)0x35, (byte)0x2c, (byte)0x31, (byte)0x0d};
        return writeBytes;
    }

    /**
     * F 7 CR 外装シリアル番号読み出し
     */
    private static byte[] getSendCommandReadExperiorSerial(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x46, (byte)0x37, (byte)0x0d};
        return writeBytes;
    }

    /**
     * F 8 CR 基板シリアル番号読み出し
     */
    private static byte[] getSendCommandReadSubstrateSerial(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x46, (byte)0x38, (byte)0x0d};
        return writeBytes;
    }

    /**
     * T 5 CR メインファームバージョン
     */
    private static byte[] getSendCommandMainFarm(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x54, (byte)0x35, (byte)0x0d};
        return writeBytes;
    }

    /**
     * R 3 CR　BLEファームバージョン
     */
    private static byte[] getSendCommandBleFarm(){
        final byte writeBytes[] = {(byte)0x03, (byte)0x52, (byte)0x33, (byte)0x0d};
        return writeBytes;
    }

}
