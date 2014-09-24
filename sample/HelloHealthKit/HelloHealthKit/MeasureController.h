//
//  Measures.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/23.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Measure;

@interface MeasureController : NSObject

- (void)addData:(Measure *)measure;
- (void)addDataWithDictionary:(NSDictionary *)data;

- (NSInteger)calculateLatestHeartRate;
- (Measure *)getLatestData;
- (NSDate *)getLatestDate;
- (NSInteger)getLatestRri;

@end
