//
//  MeasureReceiveProtocol.h
//  MyBeat
//
//  Created by Masaaki Wada on 13/03/28.
//  Copyright (c) 2013年 Masaaki Wada. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBMeasureReceiveProtocol <NSObject>

@required

@property (nonatomic) NSDate *recievedDate;

- (id)initWithData:(NSData *)receivedData recievedDate:(NSDate *)recievedDate;

- (NSMutableArray *)getRecieveDatas;

@end
