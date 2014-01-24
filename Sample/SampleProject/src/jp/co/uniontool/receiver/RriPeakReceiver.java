package jp.co.uniontool.receiver;

import jp.co.uniontool.receiveddata.SerializableReceivedData;
import jp.co.uniontool.receiveddata.RriPeakData;

public class RriPeakReceiver implements  MeasureReceiver {
    private final byte[] data;

    public RriPeakReceiver(byte[] data){
        this.data = data;
    }

    /**
     * 動作モードを読み込む(0000 0001)
     * @return 0:pqrst 1:rri
     */
    @Override
    public int getBehaviorMode(){
        return ReceiveUtility.convertBehaviorMode(this.data[1]);
    }

    /**
     * 加速度モードを読み込む(0000 0100)
     * @return 0:average 1:peak
     */
    @Override
    public int getAccelerationMode(){
        return ReceiveUtility.convertAccelerationMode(this.data[1]);
    }

    /**
     * 心拍信号不飽を読み込む(0010 0000)
     * @return 0:不飽和 1:飽和
     */
    @Override
    public int getSaturation(){
        return ReceiveUtility.convertSaturation(this.data[1]);
    }

    /**
     * 電圧を読み込む(0001 0000)
     * @return 0:正常電圧 1:低電圧
     */
    @Override
    public int getVoltage(){
        return ReceiveUtility.convertVoltage(this.data[1]);
    }

    @Override
    public SerializableReceivedData getReceivedData(){
        RriPeakData rriPeak = new RriPeakData();
        rriPeak.setRri(getEcg());
        rriPeak.setTemperature(getTemperature());
        rriPeak.setAccelerationXPlus(getAccelerationXPlus());
        rriPeak.setAccelerationYPlus(getAccelerationYPlus());
        rriPeak.setAccelerationZPlus(getAccelerationZPlus());
        rriPeak.setAccelerationXMinus(getAccelerationXMinus());
        rriPeak.setAccelerationYMinus(getAccelerationYMinus());
        rriPeak.setAccelerationZMinus(getAccelerationZMinus());
        return rriPeak;
    }

    public int getEcg(){
        return ReceiveUtility.convertEcg(data[4], data[5]);
    }

    public double getTemperature(){
        return ReceiveUtility.convertTemperature(data[6], data[7]);
    }

    public double getAccelerationXPlus(){
        return ReceiveUtility.convertAcceleration(data[8]);
    }

    public double getAccelerationYPlus(){
        return ReceiveUtility.convertAcceleration(data[9]);
    }

    public double getAccelerationZPlus(){
        return ReceiveUtility.convertAcceleration(data[10]);
    }

    public double getAccelerationXMinus(){
        return ReceiveUtility.convertAcceleration(data[11]);
    }

    public double getAccelerationYMinus(){
        return ReceiveUtility.convertAcceleration(data[12]);
    }

    public double getAccelerationZMinus(){
        return ReceiveUtility.convertAcceleration(data[13]);
    }
}