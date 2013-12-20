#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol MBMeasureReceiveProtocol;

extern NSString* const ServiceWhsUuid;
extern NSString* const CharacteristicsWhsUuid;
extern NSString* const KeyAccelerationValueX;
extern NSString* const KeyAccelerationValueY;
extern NSString* const KeyAccelerationValueZ;
extern NSString* const KeyAccelerationValueXPlus;
extern NSString* const KeyAccelerationValueYPlus;
extern NSString* const KeyAccelerationValueZPlus;
extern NSString* const KeyAccelerationValueXMinus;
extern NSString* const KeyAccelerationValueYMinus;
extern NSString* const KeyAccelerationValueZMinus;
extern NSString* const KeyEcgValue;
extern NSString* const KeyTemperatureValue;
extern NSString* const KeyReceivedDate;

typedef NS_ENUM(NSInteger, BleStatus) {
    typeBleStatusNotConnected = 1,
    typeBleStatusConnected = 2,
};

typedef NS_ENUM(NSInteger, SettingKind) {
    typeSettingItemBehavior = 1,
    typeSettingItemAcceleration = 2,
};

typedef NS_ENUM(NSInteger, BehaviorSettingType) {
    typeBehaviorSettingPqrst = 1,
    typeBehaviorSettingRri = 2,
};

typedef NS_ENUM(NSInteger, AccelerationSettingType) {
    typeAccelerationSettingAverage = 0,
    typeAccelerationSettingPeak = 1,
};

typedef NS_ENUM(NSInteger, AccelerationType) {
    typeAccelerationAverage = 0,
    typeAccelerationPeak = 1,
};

typedef NS_ENUM(NSInteger, BehaviorType) {
    typeBehaviorPqrst = 0,
    typeBehaviorRri = 1,
};

@interface MBWhsService : NSObject

@property (nonatomic) CBPeripheral *peripheral;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *uuid;
@property (nonatomic) NSInteger rssi;
@property (nonatomic) NSArray *receivedDataDictionary;
@property (nonatomic) NSDate *receivedDateTime;
@property (nonatomic) NSData *receivedData;
@property (nonatomic) BehaviorType behaviorType;
@property (nonatomic) AccelerationType accelerationType;
@property (nonatomic) id<MBMeasureReceiveProtocol> receiver;

- (id)initWithPeripheral:(CBPeripheral *)peripheral;
- (void)setReceivedMeasureData:(NSData *)receivedData date:(NSDate *)date;
- (id<MBMeasureReceiveProtocol>)getMeasureReceiver:(NSData *)data date:(NSDate *)date;

@end
