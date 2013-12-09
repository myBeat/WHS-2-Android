//
//  AppDelegate.m
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@class MBLeManager;

typedef NS_ENUM(NSInteger, DeviceCellView){
    typeDeviceCellViewPeripheralPowerOnOff = 1,
    typeDeviceCellViewPeripheralRSSI = 2,
    typeDeviceCellViewHR= 3,
    typeDeviceCellViewPeripheralRRI = 4,
    typeDeviceCellViewTemperature= 5,
    typeDeviceCellViewAccelerationX = 6,
    typeDeviceCellViewAccelerationY = 7,
    typeDeviceCellViewAccelerationZ = 8,
    typeDeviceCellViewRecievedDate = 9,
    typeDeviceCellViewUuid = 10,
    typeDeviceCellViewImageHeart = 11,
    typeDeviceCellViewAccelerationXLabel = 12,
    typeDeviceCellViewAccelerationYLabel = 13,
    typeDeviceCellViewAccelerationZLabel = 14,
    typeDeviceCellViewHeartMode = 15,
    typeDeviceCellViewAccelerationMode= 16,
};

@interface ManiViewController : UITableViewController

@property (weak, nonatomic) MBLeManager *leManager;

- (IBAction)refreshDevices:(id)sender;

@end
