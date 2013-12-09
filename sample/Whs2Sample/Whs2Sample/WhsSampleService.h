//
//  WhsExampleService.h
//  Whs2Sample
//
//  Created by Masaaki Wada on 2013/12/09.
//  Copyright (c) 2013年 UNION TOOL. All rights reserved.
//

#import "MBWhsService.h"

@interface WhsSampleService : MBWhsService

- (id)initWithPeripheral:(CBPeripheral *)peripheral;
- (NSInteger)getHeartRateFromRri;

@end

