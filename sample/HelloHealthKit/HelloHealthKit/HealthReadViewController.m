//
//  ReadSampleViewController.m
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/07/25.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import "HealthReadViewController.h"
#import "HealthController.h"

@interface HealthReadViewController ()

@property (nonatomic) HealthController *health;

@end

@implementation HealthReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _health = [[HealthController alloc] init];
    
    [self addBluetoothObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeBluetoothObserver];
}

- (IBAction)readAction:(id)sender {
    [_health readUsersHeartRate];
}

- (void)addBluetoothObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationHealthKitHeartRate
                                               object:nil];
}

- (void)removeBluetoothObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationHealthKitHeartRate object:nil];
}

- (void)receiveLeNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([[notification name] isEqualToString:KeyNotificationHealthKitHeartRate]){
        NSNumber *heartRate = [userInfo objectForKey:KeyNotificationValueHeartRate];
        self.heartRateText.text = [NSNumberFormatter localizedStringFromNumber:heartRate numberStyle:NSNumberFormatterDecimalStyle];
    }
}


@end
