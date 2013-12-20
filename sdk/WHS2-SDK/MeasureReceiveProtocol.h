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

@property (nonatomic) NSDate *receivedDate;

- (id)initWithData:(NSData *)receivedData receivedDate:(NSDate *)receivedDate;

- (NSMutableArray *)getReceiveDatas;

@end
