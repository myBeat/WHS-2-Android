//
//  HealthKitController.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/24.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const KeyNotificationHealthKitHeartRate;
extern NSString* const KeyNotificationValueHeartRate;

@interface HealthController : NSObject

- (void)writeHeartRate:(NSInteger)heartRate date:(NSDate *)date;
- (void)readUsersHeartRate;

@end
