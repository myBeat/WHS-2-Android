//
//  ViewController.m
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/07/15.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//
#import "HealthWriteViewController.h"
#import "AppDelegate.h"
#import "MBLeManager.h"
#import "MBWhsService.h"

#import "MeasureController.h"
#import "HealthController.h"

@import HealthKit;

NSString* const KeyNotificationData = @"receivedData";

@interface HealthWriteViewController ()

@property (weak, nonatomic) MBLeManager *leManager;
@property (nonatomic) NSTimer *scanTimer;
@property (nonatomic) BOOL isConnected;
@property (nonatomic) BOOL isObserver;
@property (nonatomic) HealthController *healthController;
@property (nonatomic) MeasureController *measureController;

@end

@implementation HealthWriteViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _leManager = app.leManager;
    
    _healthController = [[HealthController alloc] init];
    _measureController = [[MeasureController alloc] init];
    
    [self addBluetoothObserver];
    [self setConnectedStatus:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_scanTimer != nil)
        [_scanTimer invalidate];

    [self removeBluetoothObserver];
    
    [_leManager disconnect];
    _leManager = nil;
}

- (void)startScan {
    [_leManager startScan];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(stopScan)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopScan {
    [_leManager stopScan];
    [_scanTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)connectAction:(id)sender {
    if (_isConnected) {
        [_leManager disconnect];
    } else {
        [self startScan];
    }
}

- (void)setConnectedStatus:(BOOL)value {
    _isConnected = value;
    if (value) {
        [_connectButton setTitle:@"切断" forState:UIControlStateNormal];
    } else {
        [_connectButton setTitle:@"接続" forState:UIControlStateNormal];
    }
}

- (void)receiveLeNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    if ([[notification name] isEqualToString:KeyNotificationDiscoverPeripheral]){
        NSLog(@"KeyNotificationDiscover");
        CBPeripheral *peripheral = [userInfo objectForKey:@"peripheral"];
        [_leManager connectPeripheral:peripheral];
        [self stopScan];

    } else if ([[notification name] isEqualToString:KeyNotificationDidConnectPeripheral]){
        NSLog(@"KeyNotificationConnect");
        [self setConnectedStatus:YES];

    } else if ([[notification name] isEqualToString:KeyNotificationDidDisconnectPeripheral]){
        NSLog(@"KeyNotificationDisConnect");
        [self setConnectedStatus:NO];

    } else if ([[notification name] isEqualToString:KeyNotificationFailToConnectPeripheral]){
        NSLog(@"KeyNotificationFailToConnect");
        [self setConnectedStatus:NO];
        [self startScan];

    } else if ([[notification name] isEqualToString:KeyNotificationDidUpdateState]){
        CBCentralManagerState state = (CBCentralManagerState)[userInfo objectForKey:@"state"];
        switch (state) {
            case CBCentralManagerStatePoweredOff:
                NSLog(@"CBCentralManagerStatePoweredOff");
                [self setConnectedStatus:NO];
                break;
            case CBCentralManagerStatePoweredOn:
                NSLog(@"CBCentralManagerStatePoweredOn");
                break;
            case CBCentralManagerStateResetting:
                NSLog(@"CBCentralManagerStateResetting");
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"CBCentralManagerStateUnauthorized");
                break;
            case CBCentralManagerStateUnknown:
                NSLog(@"CBCentralManagerStateUnknown");
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"CBCentralManagerStateUnsupported");
                break;
            default:
                break;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:KeyNotificationData]) {
        NSDictionary *receivedData = [_leManager.whsService.receivedDataDictionary lastObject];
        [self updateDisplayAndStore:receivedData];
    }
}

- (void)addBluetoothObserver {
    if (_isObserver) return;
    
    [_leManager addObserver:self forKeyPath:KeyNotificationData
                    options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationDiscoverPeripheral
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationDidConnectPeripheral
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationDidDisconnectPeripheral
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationFailToConnectPeripheral
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLeNotification:)
                                                 name:KeyNotificationDidUpdateState
                                               object:nil];
    _isObserver = YES;
}

- (void)removeBluetoothObserver {
    if (!_isObserver) return;
    [_leManager removeObserver:self forKeyPath:KeyNotificationData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationDiscoverPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationDidConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationFailToConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KeyNotificationDidUpdateState object:nil];
    
    _isObserver = NO;
}

- (void)updateDisplayAndStore:(NSDictionary *)data {
    [_measureController addDataWithDictionary:data];
    _rriText.text = [NSString stringWithFormat:@"%li",(long)[_measureController getLatestRri]];
    
    NSInteger heartRate = [_measureController calculateLatestHeartRate];
    if (heartRate == 0) {
        _heartRateText.text = @"";
    } else {
        _heartRateText.text = [NSString stringWithFormat:@"%li",(long)heartRate];
        [_healthController writeHeartRate:heartRate date:[_measureController getLatestDate]];
    }
}

@end
