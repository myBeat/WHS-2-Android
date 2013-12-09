//
//  SystemSettings.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//
#import "SettingMasterViewController.h"
#import "AppDelegate.h"
#import "MBLeConvert.h"
#import "MBLeManager.h"
#import "MBWhsService.h"
#import "MBWhsWriter.h"
#import "SystemSettings.h"
#import "SettingItem.h"
#import "SettingDetailViewController.h"
#import "MBWhsDevice.h"

@interface SettingMasterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) NSMutableArray *tableRecords;
@property(nonatomic) NSDictionary *behaviors;
@property(nonatomic) NSDictionary *accelerations;
@property(nonatomic) NSTimer *commandTimer;

@end

@implementation SettingMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableRecords:[self loadSettingItems]];
    [self setBehaviors:[SystemSettings loadSettingItemsBehaviors]];
    [self setAccelerations:[SystemSettings loadSettingItemsAccelerations]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initiaraizeLe];
    [self.leManager setNotifyAllPeripherals:YES];
    [self addBluetoothObserverSetting];
    
    self.commandTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(readDeviceSettings)
                                                       userInfo:nil
                                                        repeats:YES];
    
    self.leWriter = [self createWhsWriter];
    [self addBluetoothObserverSetting];
    
    [self.leWriter initiaraizeCommandQue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.leWriter sendCommand:typeCommandSettingModeEnd];
    [self.leWriter sendCommand:typeCommandMeasureModeStart];
    
    [self.commandTimer invalidate];
    [self.leManager setNotifyAllPeripherals:NO];
    
    [self removeBluetoothObserverSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Initiaraize

- (void)initiaraizeLe {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.leManager = app.leManager;
}

- (NSMutableArray *)loadSettingItems {
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSDictionary *itemList = [SystemSettings loadSettingMasterItems];
    NSArray *keys = [itemList allKeys];
    
    [keys enumerateObjectsUsingBlock:
     ^(id key, NSUInteger idx, BOOL *stop){
         SettingItem *item = [[SettingItem alloc]init];
         item.itemId = key;
         item.itemIdDescription = [itemList objectForKey:key];
         item.itemValue = @"";
         item.itemValueDescription = @"";
         [records addObject:item];
     }];
    
    return records;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"settingViewerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SettingItem *item = [self.tableRecords objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemIdDescription;
    cell.detailTextLabel.text = item.itemValueDescription;
}

- (IBAction)navigationBackButtonListener:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SettingEditSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SettingItem *item = [self.tableRecords objectAtIndex:indexPath.row];
        [[segue destinationViewController] setMasterItem:item];
        [[segue destinationViewController] setLeWriter:self.leWriter];
    }
}

#pragma mark -
#pragma mark Key Value Observing(KVO)

- (void)addBluetoothObserverSetting {
    //動作モード読み込みの監視
    [self.leWriter.commandQue addObserver:self
                               forKeyPath:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]
                                  options:NSKeyValueObservingOptionNew
                                  context:NULL];
    
    //加速度モード読み込みの監視
    [self.leWriter.commandQue addObserver:self
                               forKeyPath:[NSString stringWithFormat:@"%i",typeCommandAccelerationRead]
                                  options:NSKeyValueObservingOptionNew
                                  context:NULL];
}

- (void)removeBluetoothObserverSetting {
    [self.leWriter.commandQue removeObserver:self
                                  forKeyPath:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]];
    [self.leWriter.commandQue removeObserver:self
                                  forKeyPath:[NSString stringWithFormat:@"%i",typeCommandAccelerationRead]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateViewControl:keyPath];
}

-(void)updateViewControl:(NSString *)keyPath {
    //動作モードの読み込み
    if([keyPath isEqualToString:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]]){
        if ([[self.leWriter whsDevice] behavior] != nil){
            [self setItemValueAndDescription:[NSString stringWithFormat:@"%li",(long)typeSettingItemBehavior]
                                   itemValue:[NSString stringWithFormat:@"%li",(long)[[[self.leWriter whsDevice] behavior]integerValue]]];
        }
    }
    
    //加速度モードの読み込み
    if([keyPath isEqualToString:[NSString stringWithFormat:@"%i",typeCommandAccelerationRead]]){
        if ([[self.leWriter whsDevice] acceleration] != nil){
            [self setItemValueAndDescription:[NSString stringWithFormat:@"%li",(long)typeSettingItemAcceleration]
                                   itemValue:[NSString stringWithFormat:@"%li",(long)[[[self.leWriter whsDevice] acceleration]integerValue]]];
        }
    }
    
    [self.tableView reloadData];
    
    if ([self checkEndConnect])
        [self stopConnectTimer];
}

- (void)setItemValueAndDescription:(NSString *)itemId itemValue:(NSString *)itemValue {
    for(SettingItem *item in self.tableRecords) {
        if([item.itemId isEqualToString:itemId]) {
            item.itemValue = itemValue;
            item.itemValueDescription = [self setItemDescription:itemId itemValue:itemValue];
        }
    }
}

- (NSString *)setItemDescription:(NSString *)itemId itemValue:(NSString *)itemValue {
    if([itemId isEqualToString:[NSString stringWithFormat:@"%li",(long)typeSettingItemBehavior]]){
        return [self.behaviors objectForKey:itemValue];
    }else if([itemId isEqualToString:[NSString stringWithFormat:@"%li",(long)typeSettingItemAcceleration]]){
        return [self.accelerations objectForKey:itemValue];
    }
    return @"";
}

#pragma mark -
#pragma mark Send Commands

-(void)readDeviceSettings {
    if ([[self.leManager connectedPeripherals] count]==0) {
        return;
    }
    
    if (self.leWriter==nil){
        self.leWriter = [self createWhsWriter];
        [self addBluetoothObserverSetting];
    }
    
    //設定モードに変更する
    float delay = 0;
    if(!self.leWriter.isSetting){
        [self.leWriter sendCommand:typeCommandSettingModeStart];
        //設定コマンドの処理時間を考慮する必要あり
        delay += 0.3;
    }
    
    if (![self checkCallCommand:typeCommandBehaviorRead]) {
        [self performSelector:@selector(sendCommandBehaviorRead) withObject:nil afterDelay:delay+0.4];
    }
    
    if (![self checkCallCommand:typeCommandAccelerationRead]) {
        [self performSelector:@selector(sendCommandAccelerationRead) withObject:nil afterDelay:delay+0.5];
    }
}

- (MBWhsWriter *)createWhsWriter{
    return [[MBWhsWriter alloc]initWithPeripheral:self.leManager
                                        leService:self.settingPeripheral];
}

- (BOOL)checkCallCommand:(BleCommand)command {
    NSString *result = [self.leWriter.commandQue objectForKey:[NSString stringWithFormat:@"%i",command]];
    return [result isEqualToString: BleCommandYesMark];
}

-(void)sendCommandBehaviorRead {
    [self.leWriter sendCommand:typeCommandBehaviorRead];
}

-(void)sendCommandAccelerationRead {
    [self.leWriter sendCommand:typeCommandAccelerationRead];
}

- (void)stopConnectTimer {
    [_commandTimer invalidate];
}

- (BOOL)checkEndConnect {
    return [self checkCallCommand:typeCommandBehaviorRead]
    && [self checkCallCommand:typeCommandAccelerationRead];
}

@end
