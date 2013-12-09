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

- (id)initWithData:(NSData *)recievedData recievedDate:(NSDate *)recievedDate{
    self = [super init];
    if (self){
        [recievedData getBytes:&chars length:recievedData.length];
        self.recievedDate = recievedDate;
    }
    return self;
}

- (void)setData:(NSData *)recieveData{
    [recieveData getBytes:&chars length:recieveData.length];
}

- (NSMutableArray *)getRecieveDatas{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [result addObject:@{KeyEcgValue:@([self getEcgValue]),
                        KeyAccelerationValueX:@([self getAccelerationXValue]),
                        KeyAccelerationValueY:@([self getAccelerationYValue]),
                        KeyAccelerationValueZ:@([self getAccelerationZValue]),
                        KeyTemperatureValue:@([self getTemperatureValue]),
                        KeyRecievedDate:self.recievedDate}];
    return result;
}

#pragma mark - one received data
- (double)getEcgValue{
    return [MBLeConvert convertEcg:chars[typeRriAverageRecieveEcg]
                           char1:chars[typeRriAverageRecieveEcg+1]];
}

- (double)getTemperatureValue{
    return [MBLeConvert convertTemperature:chars[typeRriAverageRecieveTemperature]
                                   char1:chars[typeRriAverageRecieveTemperature+1]];
}

- (double)getAccelerationXValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageRecieveAccelerationX]];
}

- (double)getAccelerationYValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageRecieveAccelerationY]];
}

- (double)getAccelerationZValue{
    return [MBLeConvert convertAcceleration:chars[typeRriAverageRecieveAccelerationZ]];
}

@end
