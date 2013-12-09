//
//  AppDelegate.m
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//
#import "ManiViewController.h"
#import "AppDelegate.h"
#import "MBWhsService.h"
#import "MBLeManager.h"
#import "SettingMasterViewController.h"
#import "WhsSampleService.h"

NSString* const ObserverKeyRecieveData = @"recievedData";
NSString* const ObserverKeyFindDevice = @"foundPeripheral";

@interface ManiViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSMutableArray *peripheralLists;
@property (nonatomic) NSTimer *stopScanTimer;
@end

@implementation ManiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self attachRefreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.leManager = app.leManager;
    
    //接続済みのPeripheralがある場合はNotifyを設定
    for(WhsSampleService *service in self.leManager.connectedPeripherals){
        [self.leManager setNotify:YES peripheral:service.peripheral];
    }
    
    self.peripheralLists = [[NSMutableArray alloc]init];
    
    [self addBluetoothObserver];
    
    [self updateTableViewData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.stopScanTimer != nil){
        [self.stopScanTimer invalidate];
    }
    
    [self removeBluetoothObserver];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peripheralLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    WhsSampleService *whs = [self getWhsPeripheral:indexPath.row];
    
    [self setCellValue:cell whs:whs];
    
    [[self getCellViewPowerOnOff:cell] addTarget:self
                                          action:@selector(changeSwitch:)
                                forControlEvents:UIControlEventValueChanged];
    return cell;
}


#pragma mark -
#pragma mark Table View Cell


- (void)setCellValue:(UITableViewCell *)cell whs:(WhsSampleService *)whs {
    //基本情報
    [self setCellBasicValue:cell whs:whs];
    
    if (!whs.recievedDataDictionary){
        [self clearCellValue:cell];
        return;
    }
    
    //計測データ
    [self setCellMeasureValue:cell whs:whs];
}

- (void)setCellBasicValue:(UITableViewCell *)cell whs:(WhsSampleService *)whs {
    [self getCellViewUUID:cell].text = whs.uuid;
    [self getCellViewPeripheralRSSI:cell].text = [NSString stringWithFormat:@"%ld",(long)whs.rssi];
    [self getCellViewHeartMode:cell].text = [self getBehaviorText:whs.behaviorType];
    
    if (whs.behaviorType == typeBehaviorRri)
        [self getCellViewAccelerationMode:cell].text = [self getAccelerationText:whs.accelerationType];
    else
        [self getCellViewAccelerationMode:cell].text = @"";
    
    [self getCellViewRecievedDate:cell].text = [self getDateStringMillisecondFromDate:whs.recievedDateTime];
    
    if (whs.behaviorType == typeBehaviorRri)
        [self getCellViewHRValue:cell].text = [NSString stringWithFormat:@"%li",(long)[whs getHeartRateFromRri]];
    else
        [self getCellViewHRValue:cell].text = @"";
}

- (void)setCellMeasureValue:(UITableViewCell *)cell whs:(WhsSampleService *)whs {
    NSDictionary *recievedData = [self getLatestRecievedData:whs.recievedDataDictionary];
    //加速度
    double x = [[recievedData objectForKey:KeyAccelerationValueX] doubleValue];
    double y = [[recievedData objectForKey:KeyAccelerationValueY] doubleValue];
    double z = [[recievedData objectForKey:KeyAccelerationValueZ] doubleValue];
    [self getCellViewAccelerationXValue:cell].text = [self editAccelerationValue:x];
    [self getCellViewAccelerationYValue:cell].text = [self editAccelerationValue:y];
    [self getCellViewAccelerationZValue:cell].text = [self editAccelerationValue:z];
    //温度
    double temperature = [[recievedData objectForKey:KeyTemperatureValue] doubleValue];
    [self getCellViewTemperatureValue:cell].text = [self editRemperature:temperature];
    //RRI
    [self getCellViewPeripheralRRIValue:cell].text
    = [NSString stringWithFormat:@"%@",[recievedData objectForKey:KeyEcgValue]];
}

- (NSDictionary *)getLatestRecievedData:(NSArray *)datas {
    for(NSDictionary *recievedData in [datas reverseObjectEnumerator]){
        return recievedData;
    }
    return nil;
}

- (void)clearCellValue:(UITableViewCell *)cell {
    [self getCellViewAccelerationXLabel:cell].text = @"X";
    [self getCellViewAccelerationYLabel:cell].text = @"Y";
    [self getCellViewAccelerationZLabel:cell].text = @"Z";
    [self getCellViewHRValue:cell].text = @"";
    [self getCellViewAccelerationXValue:cell].text = @"";
    [self getCellViewAccelerationYValue:cell].text = @"";
    [self getCellViewAccelerationZValue:cell].text = @"";
    [self getCellViewTemperatureValue:cell].text = @"";
    [self getCellViewPeripheralRRIValue:cell].text = @"";
}

- (UISwitch *)getCellViewPowerOnOff:(UITableViewCell *)cell {
    return (UISwitch *)[cell viewWithTag:typeDeviceCellViewPeripheralPowerOnOff];
}

- (UILabel *)getCellViewUUID:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewUuid];
}

- (UILabel *)getCellViewHeartMode:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewHeartMode];
}

- (UILabel *)getCellViewAccelerationMode:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationMode];
}

- (UILabel *)getCellViewPeripheralRSSI:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewPeripheralRSSI];
}

- (UILabel *)getCellViewAccelerationXValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationX];
}

- (UILabel *)getCellViewAccelerationYValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationY];
}

- (UILabel *)getCellViewAccelerationZValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationZ];
}

- (UILabel *)getCellViewTemperatureValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewTemperature];
}

- (UILabel *)getCellViewPeripheralRRIValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewPeripheralRRI];
}

- (UILabel *)getCellViewRecievedDate:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewRecievedDate];
}

- (UILabel *)getCellViewHRValue:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewHR];
}

- (UILabel *)getCellViewAccelerationXLabel:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationXLabel];
}

- (UILabel *)getCellViewAccelerationYLabel:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationYLabel];
}

- (UILabel *)getCellViewAccelerationZLabel:(UITableViewCell *)cell {
    return (UILabel *)[cell viewWithTag:typeDeviceCellViewAccelerationZLabel];
}

- (NSString *)editRemperature:(double)temperature {
    return [NSString stringWithFormat:@"%.3f",temperature];
}

- (NSString *)editAccelerationValue:(double)acceleration {
    return [NSString stringWithFormat:@"%.3f",acceleration];
}

#pragma mark -
#pragma mark BLE

- (void)startScan {
    [self.leManager startScan];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.stopScanTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                          target:self
                                                        selector:@selector(stopScan)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)stopScan {
    [self.leManager stopScan];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.stopScanTimer invalidate];
}

- (void)updateTableViewData {
    [self addPeripheralToPeripheralLists];
    [self.tableView reloadData];
}

- (void)addPeripheralToPeripheralLists {
    //接続済みのPeripheralの処理
    [self reloadTableViewPeripheral];
    
    //新たに接続したペリフェラルに対する処理
    [self addNewConnectedPeripheral];
    
    [self.tableView reloadData];
}
- (void)reloadTableViewPeripheral {
    for(MBWhsService *service in self.leManager.connectedPeripherals) {
        [self replaceTableViewLeWhsService:service];
    }
}

- (void)addNewConnectedPeripheral {
    for(CBPeripheral *cbperipheral in self.leManager.foundPeripherals) {
        if (![self existsTableViewPeripheral:cbperipheral]){
            [self.peripheralLists addObject:[[WhsSampleService alloc]initWithPeripheral:cbperipheral]];
        }
    }
}

- (BOOL)existsTableViewPeripheral:(CBPeripheral *)peripheral {
    for (WhsSampleService *whs in self.peripheralLists) {
        if (whs.peripheral == peripheral){
            return YES;
        }
    }
    return NO;
}

- (void)replaceTableViewLeWhsService:(MBWhsService *)service {
    [_peripheralLists enumerateObjectsUsingBlock:
     ^(WhsSampleService *whs, NSUInteger idx, BOOL *stop) {
         if([whs.peripheral isEqual:service.peripheral]) {
             whs.peripheral = service.peripheral;
             whs.name = service.name;
             whs.uuid = service.uuid;
             whs.rssi = service.rssi;
             whs.behaviorType = service.behaviorType;
             whs.accelerationType = service.accelerationType;
             whs.recievedDataDictionary = service.recievedDataDictionary;
             whs.recievedDateTime = service.recievedDateTime;
             *stop = YES;
         }
     }];
}

- (void)addBluetoothObserver {
    //計測データ受信の監視
    [self.leManager addObserver:self
                     forKeyPath:ObserverKeyRecieveData
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    //デバイス発見の監視
    [self.leManager addObserver:self
                     forKeyPath:ObserverKeyFindDevice
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
}

- (void)removeBluetoothObserver {
    [self.leManager removeObserver:self forKeyPath:ObserverKeyRecieveData];
    [self.leManager removeObserver:self forKeyPath:ObserverKeyFindDevice];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:ObserverKeyRecieveData]) {
        [self updateTableViewData];
    }
    else if([keyPath isEqualToString:ObserverKeyFindDevice]) {
        [self updateTableViewData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DevicePropertySegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WhsSampleService *whsService = [self getWhsPeripheral:indexPath.row];
        
        SettingMasterViewController *nextViewController = [segue destinationViewController];
        [nextViewController setSettingPeripheral:whsService];
    }
}

- (WhsSampleService *)getWhsPeripheral:(NSInteger)index {
    return [_peripheralLists objectAtIndex:index];
}


#pragma mark -
#pragma mark Display Edit

- (NSString *)getBehaviorText:(BehaviorType)behavior {
    switch (behavior) {
        case typeBehaviorPqrst:
            return @"PQRST";
        case typeBehaviorRri:
            return @"RRI";
        default:
            return @"-";
    }
}

- (NSString *)getAccelerationText:(AccelerationType)acceleration {
    switch (acceleration) {
        case typeAccelerationPeak:
            return @"PEAK";
        case typeAccelerationAverage:
            return @"AVERAGE";
        default:
            return @"-";
    }
}

- (NSString *)getDateStringMillisecondFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
    return [formatter stringFromDate:date];
}

#pragma mark -
#pragma mark Listener

- (void) changeSwitch:(UISwitch *)sender {
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview]superview];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    WhsSampleService *service = [self.peripheralLists objectAtIndex:index.row];
    
    if (sender.on)
        [self.leManager connectPeripheral:service.peripheral];
    else
        [self.leManager disconnectPeripheral:service.peripheral];
}

- (IBAction)refreshDevices:(id)sender {
    [self refreshDevices];
}

- (void)attachRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor orangeColor];
    [refreshControl addTarget:self
                       action:@selector(refreshControllerListenr)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)refreshControllerListenr {
    [self refreshDevices];
    [self.refreshControl endRefreshing];
}

- (void)refreshDevices {
    [self startScan];
    [self updateTableViewData];
}
@end
