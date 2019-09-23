package jp.co.uniontool.receiveddata;

public class RriPeakData implements SerializableReceivedData {

	private static final long serialVersionUID = 1L;
	private int rri;
	private long receivedMillis;
    private double temperature;
    private double accelerationXPlus;
    private double accelerationYPlus;
    private double accelerationZPlus;
    private double accelerationXMinus;
    private double accelerationYMinus;
    private double accelerationZMinus;

    public RriPeakData(){
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

    public void setAccelerationXPlus(double accelerationX){
        this.accelerationXPlus = accelerationX;
    }

    public void setAccelerationYPlus(double accelerationY){
        this.accelerationYPlus = accelerationY;
    }

    public void setAccelerationZPlus(double accelerationZ){
        this.accelerationZPlus = accelerationZ;
    }

    public void setAccelerationXMinus(double accelerationX){
        this.accelerationXMinus = accelerationX;
    }

    public void setAccelerationYMinus(double accelerationY){
        this.accelerationYMinus = accelerationY;
    }

    public void setAccelerationZMinus(double accelerationZ){
        this.accelerationZMinus = accelerationZ;
    }

    public int getRri(){
        return this.rri;
    }

    public double getTemperature(){
        return this.temperature;
    }

    public double getAccelerationX(){
        return (Math.abs(this.accelerationXPlus) > Math.abs(this.accelerationXMinus))?
                this.accelerationXPlus:this.accelerationXMinus;
    }

    public double getAccelerationY(){
        return (Math.abs(this.accelerationYPlus) > Math.abs(this.accelerationYMinus))?
                this.accelerationYPlus:this.accelerationYMinus;
    }

    public double getAccelerationZ(){
        return (Math.abs(this.accelerationZPlus) > Math.abs(this.accelerationZMinus))?
                this.accelerationZPlus:this.accelerationZMinus;
    }
        
    public double getAccelerationXPlus(){
        return this.accelerationXPlus;
    }

    public double getAccelerationYPlus(){
    	return this.accelerationYPlus;
    }

    public double getAccelerationZPlus(){
    	return this.accelerationZPlus;
    }
    
    public double getAccelerationXMinus(){
        return this.accelerationXMinus;
    }

    public double getAccelerationYMinus(){
    	return this.accelerationYMinus;
    }

    public double getAccelerationZMinus(){
    	return this.accelerationZMinus;
    }
}