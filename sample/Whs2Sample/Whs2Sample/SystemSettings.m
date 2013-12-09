//
//  SystemSettings.m
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//

#import "SystemSettings.h"

NSString* const SettingMasterItems = @"SettingMasterItems";
NSString* const SettingItemsBehaviors = @"SettingItemsBehaviors";
NSString* const SettingItemsAccelerations = @"SettingItemsAccelerations";

@implementation SystemSettings

+ (NSDictionary *)loadSettingMasterItems {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"動作モード", @"1",
            @"加速度モード", @"2",
            nil];
}

//動作モード詳細
+ (NSDictionary *)loadSettingItemsBehaviors {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"心拍波形：PQRST", @"1",
            @"心拍周期：RRI", @"2",
            nil];
}

+ (NSDictionary *)loadSettingItemsAccelerations {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"移動平均", @"0",
            @"ピークホールド", @"1",
            nil];
}

@end