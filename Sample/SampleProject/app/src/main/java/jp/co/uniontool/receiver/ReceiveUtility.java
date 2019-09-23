package jp.co.uniontool.receiver;

import jp.co.uniontool.le.WhsHelper;

public class ReceiveUtility {
    private ReceiveUtility(){}

    /**
     * 受信データを受信値を利用するためのクラスに格納して返す
     * @param data　受信データ
     * @return 計測モード受信用のクラス。測定モードの場合はnull。
     */
    public static MeasureReceiver getMeasureObject(byte[] data){
    	if (!checkMeasureMode(data)) return null;
    	
        int behavior = convertBehaviorMode(data[1]);
        int acceleration = convertAccelerationMode(data[1]);

        if (behavior == WhsHelper.MEASURE_PACKET_BEHAVIOR_PQRST){
            return new PqrstReceiver(data);
        }
        
        if (behavior == WhsHelper.MEASURE_PACKET_BEHAVIOR_RRI){
            if (acceleration == WhsHelper.MEASURE_PACKET_ACCELERATION_PEAK){
                return new RriPeakReceiver(data);
            }else if (acceleration == WhsHelper.MEASURE_PACKET_ACCELERATION_AVERAGE){
                return new RriAverageReceiver(data);
            }
        }
        return null;
    }
    
    /**
     * 受信データフォーマットから、計測モードか設定モードかを判定する
     *  何か良い方法があれば変更したい
     * @param dataLength
     * @return true 計測モード false 設定モード
     */
    public static boolean checkMeasureMode(final byte[] data) {
    	return data[0] == 15;
    }
   
    /**
     * 2バイトからEcg値に変換
     * @param data1
     * @param data2
     * @return
     */
    public static int convertEcg(byte data1, byte data2){
        int result1 = (data1 << 8);
        int result2 = data2 & 0xFF;
        return result1 + result2;
    }

    /**
     * 2バイトから温度データに変換
     * @param data1
     * @param data2
     * @return
     */
    public static double convertTemperature(byte data1, byte data2){
        int result1 = (data1 << 8);
        int result2 = data2 & 0xFF;
        return (result1 + result2)*0.0625;
    }

    /**
     * 加速度に変換
     * @param data
     * @return
     */
    public static double convertAcceleration(byte data){
        return data * 0.03125;
    }

    /**
     * 動作モードを読み込む(0000 0001)
     * @return 0:pqrst 1:rri
     */
    public static int convertBehaviorMode(byte data){
        return data & 0x01;
    }

    /**
     * 加速度モードを読み込む(0000 0100)
     * @return 0:average 1:peak
     */
    public static int convertAccelerationMode(byte data){
        return data>>2 & 0x01;
    }

    /**
     * 心拍信号不飽を読み込む(0010 0000)
     * @return 0:不飽和 1:飽和
     */
    public static int convertSaturation(byte data){
        return data>>5 & 0x01;
    }

    /**
     * 電圧を読み込む(0001 0000)
     * @return 0:正常電圧 1:低電圧
     */
    public static int convertVoltage(byte data){
        return data>>4 & 0x01;
    }
}
