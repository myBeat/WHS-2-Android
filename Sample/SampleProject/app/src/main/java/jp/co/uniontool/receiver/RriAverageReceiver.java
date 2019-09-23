package jp.co.uniontool.receiver;

import jp.co.uniontool.receiveddata.SerializableReceivedData;
import jp.co.uniontool.receiveddata.RriAverageData;

public class RriAverageReceiver implements MeasureReceiver {
    private final byte[] data;

    public RriAverageReceiver(byte[] data){
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
        RriAverageData rriAverage = new RriAverageData();
        rriAverage.setRri(getEcg());
        rriAverage.setTemperature(getTemperature());
        rriAverage.setAccelerationX(getAccelerationX());
        rriAverage.setAccelerationY(getAccelerationY());
        rriAverage.setAccelerationZ(getAccelerationZ());
        return rriAverage;
    }

    public int getEcg(){
        return ReceiveUtility.convertEcg(data[4], data[5]);
    }

    public double getTemperature(){
        return ReceiveUtility.convertTemperature(data[6], data[7]);
    }

    public double getAccelerationX(){
        return ReceiveUtility.convertAcceleration(data[8]);
    }

    public double getAccelerationY(){
        return ReceiveUtility.convertAcceleration(data[9]);
    }

    public double getAccelerationZ(){
        return ReceiveUtility.convertAcceleration(data[10]);
    }
}
