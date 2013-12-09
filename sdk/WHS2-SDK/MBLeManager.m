#import "MBLeManager.h"
#import "MBWhsService.h"
#import "MeasureReceiveProtocol.h"

@interface MBLeManager() <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic) NSTimer *scanStopTimer;
@property (nonatomic) BOOL isBTPoweredOn;
@property (nonatomic) BOOL isSupport;
@property (nonatomic) id<MBMeasureReceiveProtocol> reciever;
@end

@implementation MBLeManager

#pragma mark -
#pragma mark Init
-(id)init {
    self = [super init];
    if(self) {
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.whsServiceUUID = [CBUUID UUIDWithString:ServiceWhsUuid];
        self.whsCharacteristicsUUID = [CBUUID UUIDWithString:CharacteristicsWhsUuid];
        self.foundPeripherals = [[NSMutableArray alloc] init];
        self.connectedPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Discovery
-(void)startScan {
    if(!self.isBTPoweredOn) return;
    
    NSArray *scanServices = [NSArray arrayWithObjects:self.whsServiceUUID,nil];
    NSDictionary *scanOptions = [self getScanningOption];

    [self.centralManager scanForPeripheralsWithServices:scanServices options:scanOptions];
    _scanStopTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
}

- (NSDictionary *)getScanningOption{
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                       forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
}

- (void)stopScan {
    [self.centralManager stopScan];
    [_scanStopTimer invalidate];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.foundPeripherals containsObject:peripheral]){
		[self.foundPeripherals addObject:peripheral];
    }
}

#pragma mark -
#pragma mark Connection/Disconnection
- (void)connectPeripheral:(CBPeripheral *)peripheral{
    if (![peripheral isConnected])
        [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)disconnect{
    for (MBWhsService *whs in self.connectedPeripherals){
        if ([whs.peripheral isConnected]){
            [self disconnectPeripheral:whs.peripheral];
        }
    }
    
    [self clearDevices];
}

- (void)disconnectPeripheral:(CBPeripheral*)peripheral {
	[self.centralManager cancelPeripheralConnection:peripheral];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch ([self.centralManager state]) {
        case CBCentralManagerStatePoweredOff:
            self.isBTPoweredOn = NO;
            [_scanStopTimer invalidate];
            break;
        case CBCentralManagerStatePoweredOn:
            self.isBTPoweredOn = YES;
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            self.isSupport = NO;
            break;
    }
}

- (CBUUID *)getCBUUIDfromUuidString:(NSString *)uuidString {
    return [CBUUID UUIDWithString:uuidString];
}

- (BOOL)compareCBUUID:(CBUUID *)selectUUID peripheralUUID:(CBUUID *)peripheralUUID {
    return ([peripheralUUID.data isEqualToData:selectUUID.data]);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self disconnectIntrinsic];
}

-(void)disconnectIntrinsic {
    self.isSupport = YES;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:[NSArray arrayWithObjects:self.whsServiceUUID,nil]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self disconnectIntrinsic];
    [self clearPeripheral:peripheral];
}

- (void)clearPeripheral:(CBPeripheral *)peripheral{
    NSArray *copyArray = [NSArray arrayWithArray:self.connectedPeripherals];
    for (MBWhsService *whs in copyArray){
        if (whs.peripheral == peripheral){
            [self.connectedPeripherals removeObject:whs];
        }
    }
}

- (void)clearDevices{
    [self.connectedPeripherals removeAllObjects];
    [self.foundPeripherals removeAllObjects];
}

#pragma mark -
#pragma mark CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID.data isEqualToData:self.whsServiceUUID.data]) {
            [peripheral discoverCharacteristics:[NSArray arrayWithObjects:self.whsCharacteristicsUUID,nil] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if ([service.UUID.data isEqualToData:self.whsServiceUUID.data]) {
        for (CBCharacteristic *characteristic in service.characteristics){
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CharacteristicsWhsUuid]]){
                self.whsService = [[MBWhsService alloc]initWithPeripheral:peripheral];
                
                if (![self.connectedPeripherals containsObject:_whsService]){
                    [self.connectedPeripherals addObject:_whsService];
                }
                
                [self setNotify:YES peripheral:peripheral];
                return;
            }
        }
    }
}

- (void)setNotifyAllPeripherals:(BOOL)value{
    for(MBWhsService *service in self.connectedPeripherals)
        [self setNotify:value peripheral:service.peripheral];
}

- (void)setNotify:(BOOL)value peripheral:(CBPeripheral *)peripheral{
    for (CBService *service in peripheral.services){
        if ([service.UUID.data isEqualToData:self.whsServiceUUID.data]) {
            for (CBCharacteristic *characteristic in service.characteristics){
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CharacteristicsWhsUuid]]){
                    [peripheral setNotifyValue:value forCharacteristic:characteristic];
                    [peripheral readRSSI];
                    return;
                }
            }
        }
    }
}

- (void)writeValue:(CBPeripheral *)peripheral value:(NSData *)value{
    for (CBService *service in peripheral.services){
        if ([service.UUID.data isEqualToData:self.whsServiceUUID.data]) {
            for (CBCharacteristic *characteristic in service.characteristics){
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CharacteristicsWhsUuid]]){
                    [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:CharacteristicsWhsUuid]]){
        return;
    }
    
    _recievedDateTime = [NSDate date];
    for (MBWhsService *whs in self.connectedPeripherals){
        if (whs.peripheral == peripheral){
            [whs setRecievedMeasureData:characteristic.value date:_recievedDateTime];
            self.recievedData = characteristic.value;
            break;
        }
    }
    
}

@end