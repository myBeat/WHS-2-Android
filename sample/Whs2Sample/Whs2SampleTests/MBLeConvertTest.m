//
//  MBLeConvertTest.m
//  Whs2Sample
//
//  Created by Masaaki Wada on 2014/03/05.
//  Copyright (c) 2014年 UNION TOOL. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "MBLeConvert.h"

@interface MBLeConvertTest : XCTestCase

@property (nonatomic) MBLeConvert *reciveConverter;

@end

@implementation MBLeConvertTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testPQRST
{
    //0000 000*
    unsigned char bytes = 0x00;
    int actual = [MBLeConvert convertBehaviorMode:bytes];
    int expect = 0;
    XCTAssertEqual(actual, expect, @"PQRST");
}

- (void)testRRI
{
    //0000 000*
    unsigned char bytes = 0x01;
    int actual = [MBLeConvert convertBehaviorMode:bytes];
    int expected = 1;
    XCTAssertEqual(actual, expected, @"RRI判定されること");
}

//入力byte列から加速度平均モードを判定できること
- (void)testAccelerationTypeAverage
{
    //0000 0*00
    unsigned char bytes = 0x00;
    int actual = [MBLeConvert convertAccelerationMode:bytes];
    //0:average  1:peak
    int expected = 0;
    XCTAssertEqual(actual, expected, @"加速度 移動平均");
}

//入力byte列から加速度ピークモードを判定できること
- (void)testAccelerationTypePeak
{
    //0000 0*00
    unsigned char bytes = 0x04;
    
    int actual = [MBLeConvert convertAccelerationMode:bytes];
    //0:average 1:peak
    int expected = 1;
    
    XCTAssertEqual(actual, expected, @"加速度 ピークホールド");
}

//入力byte列から飽和を判定できること
- (void)testSaturationTypeYes
{
    //00*0 0000
    unsigned char bytes = 0x20;
    int actual = [MBLeConvert convertSaturation:bytes];
    int expected = 1;
    
    XCTAssertEqual(actual, expected, @"飽和判定");
}

//入力byte列から不飽和を判定できること
- (void)testSaturationTypeNo
{
    //00*0 0000
    unsigned char bytes = 0x00;
    int actual = [MBLeConvert convertSaturation:bytes];
    int expected = 0;
    
    XCTAssertEqual(actual, expected, @"不飽和判定");
}

//入力byte列から低電圧を判定できること
- (void)testVoltageTypeYes
{
    //000* 0000
    unsigned char bytes = 0x10;
    int actual = [MBLeConvert convertVoltage:bytes];
    int expected = 1;
    XCTAssertEqual(actual, expected, @"低電圧判定");
}

//入力byte列から通常電圧を判定できること
- (void)testVoltageTypeNo
{
    //000* 0000
    unsigned char bytes = 0x00;
    int actual = [MBLeConvert convertVoltage:bytes];
    int expected = 0;
    XCTAssertEqual(actual, expected, @"低電圧でない判定");
}

//電圧レベルを判定する(100%)
- (void)testVoltageLebel3
{
    //**00 0000
    unsigned char bytes = 0xC0;
    int actual = [MBLeConvert convertVoltageLevel:bytes];
    int expected = 3;
    XCTAssertEqual(actual, expected, @"電圧レベル 3判定");
}

//電圧レベルを判定する(75%)
- (void)testVoltageLebel2
{
    //**00 0000
    unsigned char bytes = 0x80;
    int actual = [MBLeConvert convertVoltageLevel:bytes];
    int expected = 2;
    XCTAssertEqual(actual, expected, @"電圧レベル 2判定");
}

//電圧レベルを判定する(50%)
- (void)testVoltageLebel1
{
    //**00 0000
    unsigned char bytes = 0x40;
    int actual = [MBLeConvert convertVoltageLevel:bytes];
    int expected = 1;
    XCTAssertEqual(actual, expected, @"電圧レベル 1判定");
}

//電圧レベルを判定する(25%)
- (void)testVoltageLebel0
{
    //**00 0000
    unsigned char bytes = 0x00;
    int actual = [MBLeConvert convertVoltageLevel:bytes];
    int expected = 0;
    XCTAssertEqual(actual, expected, @"電圧レベル 0判定");
}

@end