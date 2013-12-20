//
//  RriWaveData.m
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import "MBMeasureRriAverage.h"
#import "MBWhsService.h"
#import "MBLeConvert.h"

@interface MBMeasureRriAverage(){
    unsigned char chars[15];
}
@end

@implementation MBMeasureRriAverage

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
                        KeyTemperatureValue:@([self getTemperatureValue]),
                        KeyReceivedDate:self.receivedDate}];
    return result;
}

#pragma mark - one received data
- (double)getEcgValue{
    return [MBLeConvert convertEcg:chars[typeRriAverageReceiveEcg]
                           char1:chars[typeRriAverageReceiveEcg+1]];
}

- (double)getTemperatureValue{
    return [MBLeConvert convertTemperature:chars[typeRriAverageReceiveTemperature]
                                   char1:chars[typeRriAverageReceiveTemperature+1]];
}

- (double)getAccelerationXValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageReceiveAccelerationX]];
}

- (double)getAccelerationYValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageReceiveAccelerationY]];
}

- (double)getAccelerationZValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageReceiveAccelerationZ]];
}

@end
