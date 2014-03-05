#import "MBLeConvert.h"

@implementation MBLeConvert

//動作モードを読み込む(0000 0001)
//0:pqrst
//1:rri
+ (NSInteger)convertBehaviorMode:(unsigned char)byte{
    return byte&0x01;
}

//加速度モードを読み込む(0000 0100)
//0:average
//1:peak
+ (NSInteger)convertAccelerationMode:(unsigned char)byte{
    return byte>>2 & 0x01;
}

//心拍信号不飽を読み込む(0010 0000)
//0:不飽和
//1:飽和
+ (NSInteger)convertSaturation:(unsigned char)byte{
    return byte>>5 & 0x01;
}

//電圧を読み込む(0001 0000)
//0:正常電圧
//1:低電圧
+ (NSInteger)convertVoltage:(unsigned char)byte{
    return byte>>4 & 0x01;
}

//電圧を読み込む(1100 0000)
//11:電池残量100% 10:電池残量75% 01:電池残量50% 00:電池残量25%
+ (NSInteger)convertVoltageLevel:(unsigned char)byte{
    int bit8 = byte >> 7 & 0x01;
    int bit7 = byte >> 6 & 0x01;
    if (bit8 == 0) {
        // 01 or 00
        return (bit7 == 0) ? 0 : 1;
    } else {
        // 11 or 10
        return (bit7 == 0) ? 2 : 3;
    }
}

+ (double)convertEcg:(unsigned char)byte0 char1:(unsigned char)byte1{
    double result = (byte0 << 8) + byte1;
    return result;
}

+ (double)convertTemperature:(unsigned char)byte0 char1:(unsigned char)byte1{
    double tmp = (byte0 << 8) + byte1;
    double result = tmp * 0.0625;
    return result;
}

+ (double)convertAcceleration:(unsigned char)byte{
    signed char tmp = (signed char)byte;
    double result = tmp * 0.03125;
    return result;
}

@end
