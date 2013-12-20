//
//  RriPeakWaveData.m
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import "MBMeasureRriPeak.h"
#import "MBWhsService.h"
#import "MBLeConvert.h"

@interface MBMeasureRriPeak(){
    unsigned char chars[15];
}
@end

@implementation MBMeasureRriPeak

#pragma mark - constract

- (id)initWithData:(NSData *)receivedData receivedDate:(NSDate *)receivedDate{
    self = [super init];
    if (self){
        [receivedData getBytes:&chars length:receivedData.length];
        self.receivedDate = receivedDate;
    }
    return self;
}

- (void)setData:(NSData *)receiveData{
    [receiveData getBytes:&chars length:receiveData.length];
}

- (NSMutableArray *)getReceiveDatas{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [result addObject:@{KeyEcgValue:@([self getEcgValue]),
                        KeyAccelerationValueX:@([self getAccelerationXValue]),
                        KeyAccelerationValueY:@([self getAccelerationYValue]),
                        KeyAccelerationValueZ:@([self getAccelerationZValue]),
                        KeyAccelerationValueXPlus:@([self getAccelerationXplusValue]),
                        KeyAccelerationValueYPlus:@([self getAccelerationYplusValue]),
                        KeyAccelerationValueZPlus:@([self getAccelerationZplusValue]),
                        KeyAccelerationValueXMinus:@([self getAccelerationXminusValue]),
                        KeyAccelerationValueYMinus:@([self getAccelerationYminusValue]),
                        KeyAccelerationValueZMinus:@([self getAccelerationZminusValue]),
                        KeyTemperatureValue:@([self getTemperatureValue]),
                        KeyReceivedDate:self.receivedDate}];
    return result;
}

#pragma mark - one received data

//RRI
- (double)getEcgValue{
    return [MBLeConvert convertEcg:chars[typeRriPeakReceiveEcg]
                           char1:chars[typeRriPeakReceiveEcg+1]];
}

//温度
- (double)getTemperatureValue{
    return [MBLeConvert convertTemperature:chars[typeRriPeakReceiveTemperature]
                                   char1:chars[typeRriPeakReceiveTemperature+1]];
}

//加速度x
- (double)getAccelerationXValue{
    double plus = [self getAccelerationXplusValue];
    double minus = [self getAccelerationXminusValue];
    return fabs(plus)>fabs(minus)?plus:minus;
}

//加速度y
- (double)getAccelerationYValue{
    double plus = [self getAccelerationYplusValue];
    double minus = [self getAccelerationYminusValue];
    return fabs(plus)>fabs(minus)?plus:minus;
}

//加速度z
- (double)getAccelerationZValue{
    double plus = [self getAccelerationZplusValue];
    double minus = [self getAccelerationZminusValue];
    return fabs(plus)>fabs(minus)?plus:minus;
}

//加速度x(plus)
- (double)getAccelerationXplusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationX]];
}

//加速度y(plus)
- (double)getAccelerationYplusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationY]];
}

//加速度z(plus)
- (double)getAccelerationZplusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationZ]];
}

//加速度x(minus)
- (double)getAccelerationXminusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationMinusX]];
}

//加速度y(minus)
- (double)getAccelerationYminusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationMinusY]];
}

//加速度z(minus)
- (double)getAccelerationZminusValue{
    return [MBLeConvert convertAcceleration:chars[typeRriPeakReceiveAccelerationMinusZ]];
}
@end
