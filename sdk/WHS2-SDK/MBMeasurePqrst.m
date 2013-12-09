//
//  PqrstWaveData.m
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import "MBMeasurePqrst.h"
#import "MBWhsService.h"
#import "MBLeConvert.h"

const double pqrstInterval = 0.025;

@interface MBMeasurePqrst(){
    unsigned char chars[15];
}
@end

@implementation MBMeasurePqrst

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
                        KeyRecievedDate:[self.recievedDate dateByAddingTimeInterval:-1 * pqrstInterval]}];
    [result addObject:@{KeyEcgValue:@([self getEcg2Value]),
                        KeyAccelerationValueX:@([self getAccelerationX2Value]),
                        KeyAccelerationValueY:@([self getAccelerationY2Value]),
                        KeyAccelerationValueZ:@([self getAccelerationZ2Value]),
                        KeyTemperatureValue:@([self getTemperatureValue]),
                        KeyRecievedDate:self.recievedDate}];
    return result;
}

#pragma mark - one received data
//RRI(1)
- (double)getEcgValue{
    return [MBLeConvert convertEcg:chars[typePqrstRecieveEcg1]
                           char1:chars[typePqrstRecieveEcg1+1]];
}

//加速度x(1)
- (double)getAccelerationXValue{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelX1]];
}

//加速度y(1)
- (double)getAccelerationYValue{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelY1]];
}

//加速度z(1)
- (double)getAccelerationZValue{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelZ1]];
}

//RRI(2)
- (double)getEcg2Value{
    return [MBLeConvert convertEcg:chars[typePqrstRecieveEcg2]
                           char1:chars[typePqrstRecieveEcg2+1]];
}

//加速度x(2)
- (double)getAccelerationX2Value{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelX2]];
}

//加速度y(2)
- (double)getAccelerationY2Value{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelY2]];
}

//加速度z(2)
- (double)getAccelerationZ2Value{
    return [MBLeConvert convertAcceleration:chars[typePqrstRecieveAccelZ2]];
}

- (double)getTemperatureValue{
    return [MBLeConvert convertTemperature:chars[typePqrstRecieveTemperature]
                                   char1:chars[typePqrstRecieveTemperature+1]];
}

@end
