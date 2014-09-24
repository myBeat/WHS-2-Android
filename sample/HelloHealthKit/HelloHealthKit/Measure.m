//
//  Measure.m
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/23.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import "Measure.h"
#import "MBWhsService.h"

@implementation Measure

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _date = [data objectForKey:KeyReceivedDate];
        _rri = [[data objectForKey:KeyEcgValue] integerValue];
    }
    return self;
}
@end
