#import "MBWhsService.h"
#import "MBLeConvert.h"
#import "MBMeasurePqrst.h"
#import "MBMeasureRriPeak.h"
#import "MBMeasureRriAverage.h"

@protocol MBMeasureReceiveProtocol;

NSString* const ServiceWhsUuid = @"63DD7335-6155-4919-8B85-8E329C8E5C79";
NSString* const CharacteristicsWhsUuid = @"E8DE8CB7-830B-4704-AD62-3324DC554564";

NSString* const KeyAccelerationValueX = @"AccelerationX";
NSString* const KeyAccelerationValueY = @"AccelerationY";
NSString* const KeyAccelerationValueZ = @"AccelerationZ";
NSString* const KeyAccelerationValueXPlus = @"AccelerationPlusX";
NSString* const KeyAccelerationValueYPlus = @"AccelerationPlusY";
NSString* const KeyAccelerationValueZPlus = @"AccelerationPlusZ";
NSString* const KeyAccelerationValueXMinus = @"AccelerationMinusX";
NSString* const KeyAccelerationValueYMinus = @"AccelerationMinusY";
NSString* const KeyAccelerationValueZMinus = @"AccelerationMinusZ";
NSString* const KeyEcgValue = @"Ecg";
NSString* const KeyTemperatureValue = @"Temperature";
NSString* const KeyReceivedDate = @"ReceivedDate";

@interface MBWhsService()
@end

@implementation MBWhsService

#pragma mark -
#pragma mark Init

- (id) initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _name = peripheral.name;
        _rssi = [peripheral.RSSI integerValue];
        _uuid = (peripheral.UUID==nil)?@"":[peripheral identifier].UUIDString;
	}
    return self;
}

- (void)setReceivedMeasureData:(NSData *)receivedData date:(NSDate *)date {
    
    _receivedDateTime = [NSDate date];
    _receivedData = receivedData;
    
    unsigned char chars[20];
    [_receivedData getBytes:&chars length:_receivedData.length];
    
    _behaviorType = [MBLeConvert convertBehaviorMode:chars[1]];
    _accelerationType = [MBLeConvert convertAccelerationMode:chars[1]];
    
    //RSSIを読み込む
    [_peripheral readRSSI];
    _rssi = [_peripheral.RSSI integerValue];
    
    //モードを考慮して受信データを読み込む
    _receiver = [self createReceiverInstance:receivedData date:date];
    if (!_receiver) {
        return;
    }
    
    self.receivedDataDictionary = [_receiver getReceiveDatas];
}

- (id<MBMeasureReceiveProtocol>)createReceiverInstance:(NSData *)receivedData date:(NSDate *)date {
    return [self getMeasureReceiver:receivedData date:date];
}

#pragma mark -
#pragma mark Measure receiver

- (id<MBMeasureReceiveProtocol>)getMeasureReceiver:(NSData *)data date:(NSDate *)date {
    unsigned char chars[20];
    [data getBytes:&chars length:data.length];
    
    if([MBLeConvert convertBehaviorMode:chars[1]] == typeBehaviorPqrst)
        return [[MBMeasurePqrst alloc] initWithData:data receivedDate:date];
    
    if([MBLeConvert convertBehaviorMode:chars[1]] == typeBehaviorRri){
        switch ([MBLeConvert convertAccelerationMode:chars[1]]) {
            case typeAccelerationPeak:
                return [[MBMeasureRriPeak alloc] initWithData:data receivedDate:date];
                
            case typeAccelerationAverage:
                return [[MBMeasureRriAverage alloc] initWithData:data receivedDate:date];
                
        }
    }
    return nil;
}
@end
