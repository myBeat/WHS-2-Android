#import <Foundation/Foundation.h>

@interface MBLeConvert : NSObject

/** 動作モードを読み込む(0000 0001)
 @return 0:pqrst 1:rri
 */
+ (NSInteger)convertBehaviorMode:(unsigned char)byte;

/** 加速度モードを読み込む(0000 0100)
 @return 0:average 1:peak
 */
+ (NSInteger)convertAccelerationMode:(unsigned char)byte;

/** 心拍信号不飽を読み込む(0010 0000)
 @return 0:不飽和 1:飽和
 */
+ (NSInteger)convertSaturation:(unsigned char)byte;

/** 電圧を読み込む(0001 0000)
 @return 0:正常電圧 1:低電圧
 */
+ (NSInteger)convertVoltage:(unsigned char)byte;

/** 電圧を読み込む(1100 0000)
 @return 
 3:おおよそ電池残量100%,
 2:おおよそ電池残量75%,  
 1:おおよそ電池残量50%,  
 0:おおよそ電池残量25%
 */
+ (NSInteger)convertVoltageLevel:(unsigned char)byte;

/** ECG値に変換する
 @param byte0 先頭8bitシフトする1byte
 @param byte1 1byte
 @return ECG値
 */
+ (double)convertEcg:(unsigned char)byte0 char1:(unsigned char)byte1;

/** 温度に変換する
 @param byte0 先頭8bitシフトする1byte
 @param byte1 1byte
 @return 温度(°C)
 */
+ (double)convertTemperature:(unsigned char)byte0 char1:(unsigned char)byte1;

/** 加速度に変換する
 @param byte 1byte
 @return 加速度
 */
+ (double)convertAcceleration:(unsigned char)byte;

@end
