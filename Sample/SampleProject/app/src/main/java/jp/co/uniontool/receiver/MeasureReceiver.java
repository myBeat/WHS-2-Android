package jp.co.uniontool.receiver;

import jp.co.uniontool.receiveddata.SerializableReceivedData;

public interface MeasureReceiver {
    /**
     * 動作モードを読み込む
     * @return (Enum)Behavior
     */
    public int getBehaviorMode();

    /**
     * 加速度モードを読み込む
     * @return (Enum)Acceleration
     */
    public int getAccelerationMode();

    /**
     * 心拍信号不飽を読み込む
     * @return (Enum)Saturation
     */
    public int getSaturation();

    /**
     * 電圧を読み込む
     * @return (Enum)Voltage
     */
    public int getVoltage();


    public SerializableReceivedData getReceivedData();
}
