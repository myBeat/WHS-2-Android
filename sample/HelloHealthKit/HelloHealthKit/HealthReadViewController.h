//
//  ReadSampleViewController.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/07/25.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthReadViewController : UIViewController

- (IBAction)readAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *heartRateText;
@property (weak, nonatomic) IBOutlet UILabel *heightText;

@end
