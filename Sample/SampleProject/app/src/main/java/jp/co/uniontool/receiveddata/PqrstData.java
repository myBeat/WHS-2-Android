package jp.co.uniontool.receiveddata;


public class PqrstData implements SerializableReceivedData {

	private static final long serialVersionUID = 1L;
	private long receivedMillis;
	private int pqrst1;
    private double accelerationX1;
    private double accelerationY1;
    private double accelerationZ1;
    private int pqrst2;
    private double accelerationX2;
    private double accelerationY2;
    private double accelerationZ2;
    private double temperature;

    public PqrstData(){
    }
    
    public long getReceivedDate(){
    	return receivedMillis;
    }
    
    public void setReceivedDate(long date){
    	receivedMillis = date;
    }

    public int getEcg(){
    	return getPqrst1();
    }
    
    public double getAccelerationX(){
    	return getAccelerationX1();
    }
    
    public double getAccelerationY(){
    	return getAccelerationY1();
    }
    
    public double getAccelerationZ(){
    	return getAccelerationZ1();
    }
    
    public void setPqrst1(int pqrst){
        this.pqrst1 = pqrst;
    }

    public void setPqrst2(int pqrst){
        this.pqrst2 = pqrst;
    }

    public void setTemperature(double temperature){
        this.temperature = temperature;
    }

    public void setAccelerationX1(double accelerationX1){
        this.accelerationX1 = accelerationX1;
    }

    public void setAccelerationY1(double accelerationY1){
        this.accelerationY1 = accelerationY1;
    }

    public void setAccelerationZ1(double accelerationZ1){
        this.accelerationZ1 = accelerationZ1;
    }

    public void setAccelerationX2(double accelerationX2){
        this.accelerationX2 = accelerationX2;
    }

    public void setAccelerationY2(double accelerationY2){
        this.accelerationY2 = accelerationY2;
    }

    public void setAccelerationZ2(double accelerationZ2){
        this.accelerationZ2 = accelerationZ2;
    }

    public int getPqrst1(){
        return this.pqrst1;
    }

    public int getPqrst2(){
        return this.pqrst2;
    }

    public double getTemperature(){
        return this.temperature;
    }

    public double getAccelerationX1(){
        return this.accelerationX1;
    }

    public double getAccelerationY1(){
        return this.accelerationY1;
    }

    public double getAccelerationZ1(){
        return this.accelerationZ1;
    }

    public double getAccelerationX2(){
        return this.accelerationX2;
    }

    public double getAccelerationY2(){
        return this.accelerationY2;
    }

    public double getAccelerationZ2(){
        return this.accelerationZ2;
    }
}
