#import "MBWhsSendCommand.h"

@implementation MBWhsSendCommand

+ (NSData *)getSendCommand:(BleCommand)command{
    switch (command) {
        case typeCommandSettingModeStart:
            return [self getSendCommandStartSetting];
            
        case typeCommandSettingModeEnd:
            return [self getSendCommandEndSetting];
            
        case typeCommandMeasureModeStart:
            return [self getSendCommandStartMeasure];
            
        case typeCommandBehaviorAllRead:
            return [self getSendCommandReadMode];
            
        case typeCommandBehaviorRead:
            return [self getSendCommandReadBehaviorMode];
            
        case typeCommandBehaviorWritePqrst:
            return [self getSendCommandWritePqrst];
            
        case typeCommandBehaviorWriteRri:
            return [self getSendCommandWriteRri];
            
        case typeCommandAccelerationRead:
            return [self getSendCommandReadAccelerationMode];
            
        case typeCommandAccelerationWriteAverage:
            return [self getSendCommandWriteAverage];
            
        case typeCommandAccelerationWritePeak:
            return [self getSendCommandWritePeak];
            
        case typeCommandExteriorRead:
            return [self getSendCommandReadExperiorSerial];
            
        case typeCommandSubstrateRead:
            return [self getSendCommandReadSubstrateSerial];
            
        case typeCommandMainFarmRead:
            return [self getSendCommandMainFarm];
            
        case typeCommandBleFarmRead:
            return [self getSendCommandBleFarm];
            
        default:
            return nil;
    }
}

//A A CR 設定モード開始
+ (NSData *)getSendCommandStartSetting{
    unsigned char bytes[] = {0x03 , 0x41, 0x41, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//Z Z CR　設定モード終了
+ (NSData *)getSendCommandEndSetting{
    unsigned char bytes[] = {0x03 , 0x5A, 0x5A, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//S S CR　測定モード開始
+ (NSData *)getSendCommandStartMeasure{
    unsigned char bytes[] = {0x03 , 0x53, 0x53, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 2 CR 動作モード読み出し
+ (NSData *)getSendCommandReadMode{
    unsigned char bytes[] = {0x03 , 0x43, 0x32, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 4 CR 動作モード読み出し
+ (NSData *)getSendCommandReadBehaviorMode{
    unsigned char bytes[] = {0x03 , 0x43, 0x34, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 4 PQRST
+ (NSData *)getSendCommandWritePqrst{
    unsigned char bytes[] = {0x06 , 0x43, 0x34, 0x2c, 0x31, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 4 RRI
+ (NSData *)getSendCommandWriteRri{
    unsigned char bytes[] = {0x06 , 0x43, 0x34, 0x2c, 0x32, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 5 CR 加速度モード読み出し
+ (NSData *)getSendCommandReadAccelerationMode{
    unsigned char bytes[] = {0x03 , 0x43, 0x35, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 5 加速度　平均
+ (NSData *)getSendCommandWriteAverage{
    unsigned char bytes[] = {0x06 , 0x43, 0x35, 0x2c, 0x30, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//C 5 加速度　ピーク
+ (NSData *)getSendCommandWritePeak{
    unsigned char bytes[] = {0x06 , 0x43, 0x35, 0x2c, 0x31, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//F 7 CR 外装シリアル番号読み出し
+ (NSData *)getSendCommandReadExperiorSerial{
    unsigned char bytes[] = {0x03 , 0x46, 0x37, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//F 8 CR 基板シリアル番号読み出し
+ (NSData *)getSendCommandReadSubstrateSerial{
    unsigned char bytes[] = {0x03 , 0x46, 0x38, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//T 5 CR メインファームバージョン
+ (NSData *)getSendCommandMainFarm{
    unsigned char bytes[] = {0x03 , 0x54, 0x35, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

//R 3 CR　BLEファームバージョン
+ (NSData *)getSendCommandBleFarm{
    unsigned char bytes[] = {0x03 , 0x52, 0x33, 0x0d};
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

@end
