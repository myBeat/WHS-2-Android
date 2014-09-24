//
//  AppDelegate.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/07/15.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HealthKit;

@class MBLeManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MBLeManager *leManager;
@property (nonatomic) HKHealthStore *store;

@end

