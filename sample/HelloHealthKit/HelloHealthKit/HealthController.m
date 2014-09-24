//
//  HealthKitController.m
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/24.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import "HealthController.h"
#import "AppDelegate.h"

NSString* const KeyNotificationHealthKitHeartRate = @"KeyNotificationHealthKitHeartRate";
NSString* const KeyNotificationValueHeartRate = @"KeyNotificationValueHeartRate";

@interface HealthController()

@property (weak, nonatomic) HKHealthStore *store;

@end

@implementation HealthController

- (id)init
{
    self = [super init];
    if(self) {
        [self initHealthKit];
    }
    return self;
}

- (void)initHealthKit {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _store = app.store;
}

- (void)writeHeartRate:(NSInteger)heartRate date:(NSDate *)date {
    if ([self checkIgnore:heartRate date:date]) return;
    
    NSString *identifierHeartRate = HKQuantityTypeIdentifierHeartRate;
    HKQuantityType *heartRateType = [HKObjectType quantityTypeForIdentifier:identifierHeartRate];
    HKQuantity *myHeartRate = [HKQuantity quantityWithUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]] doubleValue:heartRate];
    NSDictionary *metaTemperature = @{HKMetadataKeyHeartRateSensorLocation:@(HKHeartRateSensorLocationChest)};
    HKQuantitySample *heartRateSample = [HKQuantitySample quantitySampleWithType:heartRateType
                                                                        quantity:myHeartRate
                                                                       startDate:date
                                                                         endDate:date
                                                                        metadata:metaTemperature];
    [self.store saveObject:heartRateSample withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Saved! %@",heartRateSample);
        } else {
            NSLog(@"%@. %@.", heartRateSample, error);
            abort();
        }
    }];
}

- (BOOL)checkIgnore:(NSInteger)heartRate date:(NSDate *)date {
    if (heartRate == 0) return YES;
    if (date == nil) return YES;
    return NO;
}

- (void)readUsersHeartRate {
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleLong;
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    [self fetchMostRecentDataOfQuantityType:heartRateType
                             withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
                                 if (error) {
                                     NSLog(@"%@", error);
                                     abort();
                                 }
                                 if (mostRecentQuantity) {
                                     HKUnit *heartRateUnit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
                                     double usersHeartRate = [mostRecentQuantity doubleValueForUnit:heartRateUnit];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [[NSNotificationCenter defaultCenter]postNotificationName:KeyNotificationHealthKitHeartRate
                                                                                            object:nil
                                                                                          userInfo:@{KeyNotificationValueHeartRate:@(usersHeartRate)}];
                                     });
                                 }
                             }];
}


- (void)fetchMostRecentDataOfQuantityType:(HKQuantityType *)quantityType
                           withCompletion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion {
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:nil
                                                               limit:1
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (completion && error) {
            completion(nil, error);
            return;
        }
        HKQuantitySample *quantitySample = results.firstObject;
        HKQuantity *quantity = quantitySample.quantity;
        if (completion) completion(quantity, error);
    }];
    
    [self.store executeQuery:query];
}

@end
