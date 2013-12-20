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
    typeRriPeakReceiveLength = 0,
    typeRriPeakReceiveSetting = 1,
    typeRriPeakReceiveBlank = 2,
    typeRriPeakReceiveNumber = 3,
    typeRriPeakReceiveEcg = 4,
    typeRriPeakReceiveTemperature = 6,
    typeRriPeakReceiveAccelerationX = 8,
    typeRriPeakReceiveAccelerationY = 9,
    typeRriPeakReceiveAccelerationZ = 10,
    typeRriPeakReceiveAccelerationMinusX = 11,
    typeRriPeakReceiveAccelerationMinusY = 12,
    typeRriPeakReceiveAccelerationMinusZ = 13,
};

@interface MBMeasureRriPeak : NSObject<MBMeasureReceiveProtocol>

@property (nonatomic) NSDate *receivedDate;

- (id)initWithData:(NSData *)receivedData receivedDate:(NSDate *)receivedDate;
- (double)getEcgValue;
- (double)getTemperatureValue;
- (double)getAccelerationXValue;
- (double)getAccelerationYValue;
- (double)getAccelerationZValue;
- (double)getAccelerationXminusValue;
- (double)getAccelerationYminusValue;
- (double)getAccelerationZminusValue;
- (NSMutableArray *)getReceiveDatas;

@end
