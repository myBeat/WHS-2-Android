//
//  ViewController.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/07/15.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthWriteViewController : UIViewController

- (IBAction)connectAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *rriText;
@property (weak, nonatomic) IBOutlet UILabel *heartRateText;

@end

