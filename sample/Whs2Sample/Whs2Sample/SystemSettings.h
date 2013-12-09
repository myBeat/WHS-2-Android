//
//  SystemSettings.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSettings : NSObject

+ (NSDictionary *)loadSettingMasterItems;
+ (NSDictionary *)loadSettingItemsBehaviors;
+ (NSDictionary *)loadSettingItemsAccelerations;

@end
