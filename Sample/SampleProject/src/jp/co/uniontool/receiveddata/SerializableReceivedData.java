package jp.co.uniontool.receiveddata;

import java.io.Serializable;

public interface SerializableReceivedData extends Serializable {
    public int getEcg();
    public long getReceivedDate();
    public void setReceivedDate(long millis);
    public double getTemperature();
    public double getAccelerationX();
    public double getAccelerationY();
    public double getAccelerationZ();
}
