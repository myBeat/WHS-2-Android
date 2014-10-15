package uniontool.co.jp.whs_2_android_with_wear.receiveddata;

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
