package jp.co.uniontool.receiver;

import jp.co.uniontool.receiveddata.SerializableReceivedData;
import jp.co.uniontool.receiveddata.PqrstData;

public class PqrstReceiver implements MeasureReceiver {
    private final byte[] data;

    public PqrstReceiver(byte[] data){
        this.data = data;
    }

    /**
     * 動作モードを読み込む
     * @return 0:pqrst 1:rri
     */
    @Override
    public int getBehaviorMode(){
        return ReceiveUtility.convertBehaviorMode(this.data[1]);
    }

    /**
     * 加速度モードを読み込む
     * @return 0:average 1:peak
     */
    @Override
    public int getAccelerationMode(){
        return ReceiveUtility.convertAccelerationMode(this.data[1]);
    }

    /**
     * 心拍信号不飽を読み込む
     * @return 0:不飽和 1:飽和
     */
    @Override
    public int getSaturation(){
        return ReceiveUtility.convertSaturation(this.data[1]);
    }

    /**
     * 電圧を読み込む
     * @return 0:正常電圧 1:低電圧
     */
    @Override
    public int getVoltage(){
        return ReceiveUtility.convertVoltage(this.data[1]);
    }

    @Override
    public SerializableReceivedData getReceivedData(){
        PqrstData pqrst = new PqrstData();
        pqrst.setPqrst1(getEcg1());
        pqrst.setPqrst2(getEcg2());
        pqrst.setTemperature(getTemperature());
        pqrst.setAccelerationX1(getAccelerationX1());
        pqrst.setAccelerationY1(getAccelerationY1());
        pqrst.setAccelerationZ1(getAccelerationZ1());
        pqrst.setAccelerationX2(getAccelerationX2());
        pqrst.setAccelerationY2(getAccelerationY2());
        pqrst.setAccelerationZ2(getAccelerationZ2());
        return pqrst;
    }

    public int getEcg1(){
        return ReceiveUtility.convertEcg(data[4], data[5]);
    }

    public int getEcg2(){
        return ReceiveUtility.convertEcg(data[9], data[10]);
    }

    public double getAccelerationX1(){
        return ReceiveUtility.convertAcceleration(data[6]);
    }

    public double getAccelerationY1(){
        return ReceiveUtility.convertAcceleration(data[7]);
    }

    public double getAccelerationZ1(){
        return ReceiveUtility.convertAcceleration(data[8]);
    }

    public double getAccelerationX2(){
        return ReceiveUtility.convertAcceleration(data[11]);
    }

    public double getAccelerationY2(){
        return ReceiveUtility.convertAcceleration(data[12]);
    }

    public double getAccelerationZ2(){
        return ReceiveUtility.convertAcceleration(data[13]);
    }

    public double getTemperature(){
        return ReceiveUtility.convertTemperature(data[14], data[15]);
    }
}