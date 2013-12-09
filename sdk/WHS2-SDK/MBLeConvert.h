#import <Foundation/Foundation.h>

@interface MBLeConvert : NSObject

+ (NSInteger)convertBehaviorMode:(unsigned char)byte;
+ (NSInteger)convertAccelerationMode:(unsigned char)byte;
+ (NSInteger)convertSaturation:(unsigned char)byte;
+ (NSInteger)convertVoltage:(unsigned char)byte;

+ (double)convertEcg:(unsigned char)byte0 char1:(unsigned char)byte1;
+ (double)convertTemperature:(unsigned char)byte0 char1:(unsigned char)byte1;
+ (double)convertAcceleration:(unsigned char)byte;

@end
