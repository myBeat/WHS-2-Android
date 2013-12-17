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
    typeRriAverageReceiveLength = 0,
    typeRriAverageReceiveSetting = 1,
    typeRriAverageReceiveBlank = 2,
    typeRriAverageReceiveNumber = 3,
    typeRriAverageReceiveEcg = 4,
    typeRriAverageReceiveTemperature = 6,
    typeRriAverageReceiveAccelerationX = 8,
    typeRriAverageReceiveAccelerationY = 9,
    typeRriAverageReceiveAccelerationZ = 10,
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
