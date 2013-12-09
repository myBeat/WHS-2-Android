//
//  RriPeakWaveData.h
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasureReceiveProtocol.h"

typedef NS_ENUM(NSInteger, RriPeakWaveDataFormat) {
    typeRriPeakRecieveLength = 0,
    typeRriPeakRecieveSetting = 1,
    typeRriPeakRecieveBlank = 2,
    typeRriPeakRecieveNumber = 3,
    typeRriPeakRecieveEcg = 4,
    typeRriPeakRecieveTemperature = 6,
    typeRriPeakRecieveAccelerationX = 8,
    typeRriPeakRecieveAccelerationY = 9,
    typeRriPeakRecieveAccelerationZ = 10,
    typeRriPeakRecieveAccelerationMinusX = 11,
    typeRriPeakRecieveAccelerationMinusY = 12,
    typeRriPeakRecieveAccelerationMinusZ = 13,
};

@interface MBMeasureRriPeak : NSObject<MBMeasureReceiveProtocol>

@property (nonatomic) NSDate *recievedDate;

- (id)initWithData:(NSData *)recievedData recievedDate:(NSDate *)recievedDate;
- (double)getEcgValue;
- (double)getTemperatureValue;
- (double)getAccelerationXValue;
- (double)getAccelerationYValue;
- (double)getAccelerationZValue;
- (double)getAccelerationXminusValue;
- (double)getAccelerationYminusValue;
- (double)getAccelerationZminusValue;
- (NSMutableArray *)getRecieveDatas;

@end
