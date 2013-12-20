//
//  SystemSettings.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//

#import "WhsSampleService.h"
#import "MBHeartRate.h"

@interface WhsSampleService()
@property (nonatomic) MBHeartRate *heartRate;
@end

@implementation WhsSampleService

- (id)initWithPeripheral:(CBPeripheral *)peripheral{
    self = [super initWithPeripheral:peripheral];
    if (self) {
        _heartRate = [[MBHeartRate alloc]init];
        [self addObserver:self
               forKeyPath:@"receivedDataDictionary"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
        
    }
    return self;
}

-(void)dealloc{
    [self removeBluetoothObserver];
}

- (void)removeBluetoothObserver
{
    [self removeObserver:self forKeyPath:@"receivedDataDictionary"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if([keyPath isEqualToString:@"receivedDataDictionary"]){
        NSDictionary *dic = [self.receivedDataDictionary objectAtIndex:0];
        [_heartRate setRri:[[dic objectForKey:KeyEcgValue] integerValue]];
    }
}

- (NSInteger)getHeartRateFromRri{
    return [_heartRate getHeartRateFromRri];
}


@end