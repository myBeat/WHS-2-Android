//
//  SettingDetailViewController.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBWhsWriter;
@class SettingItem;

@interface SettingDetailViewController : UITableViewController

@property (nonatomic) MBWhsWriter *leWriter;
@property (nonatomic) SettingItem *masterItem;

@end
