//
//  PqrstWaveData.h
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasureReceiveProtocol.h"

typedef NS_ENUM(NSInteger, PqrstReceiveDataFormat) {
    typePqrstReceiveLength = 0,
    typePqrstReceiveSetting = 1,
    typePqrstReceiveBlank = 2,
    typePqrstReceiveNumber = 3,
    typePqrstReceiveEcg1 = 4,
    typePqrstReceiveAccelX1 = 6,
    typePqrstReceiveAccelY1 = 7,
    typePqrstReceiveAccelZ1 = 8,
    typePqrstReceiveEcg2 = 9,
    typePqrstReceiveAccelX2 = 11,
    typePqrstReceiveAccelY2 = 12,
    typePqrstReceiveAccelZ2 = 13,
    typePqrstReceiveTemperature = 14,
};

@interface MBMeasurePqrst : NSObject<MBMeasureReceiveProtocol>

@property (nonatomic) NSDate *receivedDate;

- (id)initWithData:(NSData *)receivedData receivedDate:(NSDate *)receivedDate;
- (double)getEcgValue;
- (double)getAccelerationXValue;
- (double)getAccelerationYValue;
- (double)getAccelerationZValue;
- (double)getEcg2Value;
- (double)getAccelerationX2Value;
- (double)getAccelerationY2Value;
- (double)getAccelerationZ2Value;
- (double)getTemperatureValue;
- (NSMutableArray *)getReceiveDatas;

@end
