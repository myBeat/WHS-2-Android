package jp.co.uniontool.receiveddata;

public class RriAverageData implements SerializableReceivedData {

	private static final long serialVersionUID = 1L;
	private int rri;
	private long receivedMillis;
    private double temperature;
    private double accelerationX;
    private double accelerationY;
    private double accelerationZ;

    public RriAverageData(){
    }

    public int getEcg(){
    	return getRri();
    }
    
    public long getReceivedDate(){
    	return receivedMillis;
    }
    
    public void setReceivedDate(long date){
    	receivedMillis = date;
    }
    
    public void setRri(int rri){
        this.rri = rri;
    }

    public void setTemperature(double temperature){
        this.temperature = temperature;
    }

    public void setAccelerationX(double accelerationX){
        this.accelerationX = accelerationX;
    }

    public void setAccelerationY(double accelerationY){
        this.accelerationY = accelerationY;
    }

    public void setAccelerationZ(double accelerationZ){
        this.accelerationZ = accelerationZ;
    }

    public int getRri(){
        return this.rri;
    }

    public double getTemperature(){
        return this.temperature;
    }

    public double getAccelerationX(){
        return this.accelerationX;
    }

    public double getAccelerationY(){
        return this.accelerationY;
    }

    public double getAccelerationZ(){
        return this.accelerationZ;
    }
}