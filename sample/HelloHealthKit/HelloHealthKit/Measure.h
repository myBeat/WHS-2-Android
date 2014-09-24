//
//  Measure.h
//  HelloHealthKit
//
//  Created by Masaaki Wada on 2014/09/23.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Measure : NSObject

- (id)initWithData:(NSDictionary *)data;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSInteger rri;

@end
