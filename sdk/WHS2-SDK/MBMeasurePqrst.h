//
//  PqrstWaveData.h
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasureReceiveProtocol.h"

typedef NS_ENUM(NSInteger, PqrstRecieveDataFormat) {
    typePqrstRecieveLength = 0,
    typePqrstRecieveSetting = 1,
    typePqrstRecieveBlank = 2,
    typePqrstRecieveNumber = 3,
    typePqrstRecieveEcg1 = 4,
    typePqrstRecieveAccelX1 = 6,
    typePqrstRecieveAccelY1 = 7,
    typePqrstRecieveAccelZ1 = 8,
    typePqrstRecieveEcg2 = 9,
    typePqrstRecieveAccelX2 = 11,
    typePqrstRecieveAccelY2 = 12,
    typePqrstRecieveAccelZ2 = 13,
    typePqrstRecieveTemperature = 14,
};

@interface MBMeasurePqrst : NSObject<MBMeasureReceiveProtocol>

@property (nonatomic) NSDate *recievedDate;

- (id)initWithData:(NSData *)recievedData recievedDate:(NSDate *)recievedDate;
- (double)getEcgValue;
- (double)getAccelerationXValue;
- (double)getAccelerationYValue;
- (double)getAccelerationZValue;
- (double)getEcg2Value;
- (double)getAccelerationX2Value;
- (double)getAccelerationY2Value;
- (double)getAccelerationZ2Value;
- (double)getTemperatureValue;
- (NSMutableArray *)getRecieveDatas;

@end
