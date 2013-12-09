//
//  SystemSettings.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//
#import "SettingDetailViewController.h"
#import "MBWhsService.h"
#import "MBWhsWriter.h"
#import "SettingItem.h"
#import "SystemSettings.h"

NSString* const CHECK_ON = @"1";
NSString* const CHECK_NONE = @"0";

@interface SettingDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) NSMutableArray *tableRecords;
@end

@implementation SettingDetailViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableRecords:[self getTableData]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Initiaraize

- (NSMutableArray *)getTableData {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSDictionary *items = [self getSettingItems];
    NSArray *keys = [items allKeys];
    [keys enumerateObjectsUsingBlock:
     ^(NSString *key, NSUInteger i, BOOL *stop) {
         SettingItem *item = [[SettingItem alloc]init];
         item.itemId = key;
         item.itemIdDescription = [items objectForKey:key];
         item.itemValue = [self getCheckMark:item.itemId];
         [result addObject:item];
     }];
    
    return result;
}

- (NSString *)getCheckMark:(NSString *)itemId {
    return ([itemId isEqualToString:self.masterItem.itemValue])? CHECK_ON:CHECK_NONE;
}

- (NSDictionary *)getSettingItems {
    if ([self.masterItem.itemId isEqualToString:
         [NSString stringWithFormat:@"%li",(long)typeSettingItemBehavior]]) {
        return [SystemSettings loadSettingItemsBehaviors];
    }
    else if ([self.masterItem.itemId isEqualToString:
              [NSString stringWithFormat:@"%li",(long)typeSettingItemAcceleration]]) {
        return [SystemSettings loadSettingItemsAccelerations];
    }
    return nil;
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
    static NSString *CellIdentifier = @"settingEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SettingItem *item = [self.tableRecords objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemIdDescription;
    
    if ([item.itemValue isEqualToString:CHECK_ON])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)clearCheckMark {
    for(NSInteger i=0;i<[self.tableRecords count];i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clearCheckMark];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.leWriter sendCommand:typeCommandSettingModeStart];
    
    SettingItem *item = [self.tableRecords objectAtIndex:indexPath.row];
    [self sendWriteCommand:[self.masterItem.itemId integerValue] writeValue:[item.itemId integerValue]];
    
    [self.leWriter sendCommand:typeCommandSettingModeEnd];
    [self.leWriter sendCommand:typeCommandMeasureModeStart];
    
    self.masterItem.itemValue = item.itemId;
    self.masterItem.itemValueDescription = item.itemIdDescription;
}

#pragma mark -
#pragma mark Send Commands

- (void)sendWriteCommand:(SettingKind)kind writeValue:(NSInteger)writeValue {
    switch (kind) {
        case typeSettingItemBehavior:
            [self sendBehaviorCommand:writeValue];
            break;
        case typeSettingItemAcceleration:
            [self sendAccelerationCommand:writeValue];
            break;
    }
}

- (void)sendBehaviorCommand:(NSInteger)writeValue {
    switch ((BehaviorSettingType)writeValue) {
        case typeBehaviorSettingPqrst:
            [self.leWriter sendCommand:typeCommandBehaviorWritePqrst];
            break;
        case typeBehaviorSettingRri:
            [self.leWriter sendCommand:typeCommandBehaviorWriteRri];
            break;
    }
}

- (void)sendAccelerationCommand:(NSInteger)writeValue{
    switch ((AccelerationSettingType)writeValue) {
        case typeAccelerationSettingAverage:
            [self.leWriter sendCommand:typeCommandAccelerationWriteAverage];
            break;
        case typeAccelerationSettingPeak:
            [self.leWriter sendCommand:typeCommandAccelerationWritePeak];
            break;
    }
}

@end
