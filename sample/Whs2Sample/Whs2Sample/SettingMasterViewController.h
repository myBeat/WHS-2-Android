//
//  SystemSettings.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WhsSampleService.h"

@class MBLeManager;
@class MBWhsWriter;

@interface SettingMasterViewController : UITableViewController

@property (weak, nonatomic) MBLeManager *leManager;
@property (nonatomic) MBWhsWriter *leWriter;
@property (nonatomic) WhsSampleService *settingPeripheral;

- (IBAction)navigationBackButtonListener:(id)sender;

@end
