//
//  Measures.m
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/23.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import "MeasureController.h"
#import "Measure.h"
#import "MBHeartRate.h"

const NSInteger Denominator = 8;

@interface MeasureController()

@property (nonatomic) NSMutableArray *datas;
@property (nonatomic) MBHeartRate *heartreate;

@end

@implementation MeasureController

- (id)init
{
    self = [super init];
    if(self) {
        _datas = [[NSMutableArray alloc] init];
        _heartreate = [[MBHeartRate alloc] init];
    }
    return self;
}

- (void)addData:(Measure *)measure
{
    [_datas addObject:measure];
    [_heartreate setRri:measure.rri];
}

- (void)addDataWithDictionary:(NSDictionary *)data
{
    Measure *measure = [[Measure alloc] initWithData:data];
    [self addData:measure];
}

- (NSInteger)calculateLatestHeartRate
{
    return [_heartreate getHeartRateFromRri];
}

- (Measure *)getLatestData
{
    return [_datas lastObject];
}

- (NSDate *)getLatestDate
{
    return [[_datas lastObject] date];
}

- (NSInteger)getLatestRri
{
    return [[_datas lastObject] rri];
}

@end
