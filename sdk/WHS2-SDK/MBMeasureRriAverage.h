//
//  RriWaveData.h
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasureReceiveProtocol.h"

typedef NS_ENUM(NSInteger, RriAverageWaveDataFormat) {
    typeRriAverageRecieveLength = 0,
    typeRriAverageRecieveSetting = 1,
    typeRriAverageRecieveBlank = 2,
    typeRriAverageRecieveNumber = 3,
    typeRriAverageRecieveEcg = 4,
    typeRriAverageRecieveTemperature = 6,
    typeRriAverageRecieveAccelerationX = 8,
    typeRriAverageRecieveAccelerationY = 9,
    typeRriAverageRecieveAccelerationZ = 10,
};

@interface MBMeasureRriAverage : NSObject<MBMeasureReceiveProtocol>

@property (nonatomic) NSDate *recievedDate;

- (id)initWithData:(NSData *)recievedData recievedDate:(NSDate *)recievedDate;
- (double)getEcgValue;
- (double)getAccelerationXValue;
- (double)getAccelerationYValue;
- (double)getAccelerationZValue;
- (double)getTemperatureValue;
- (NSMutableArray *)getRecieveDatas;

@end
