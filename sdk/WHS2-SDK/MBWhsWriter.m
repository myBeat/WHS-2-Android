#import "MBWhsWriter.h"
#import "MBLeConvert.h"
#import "MBLeManager.h"
#import "MBWhsService.h"
#import "MBWhsSendCommand.h"
#import "MBWhsDevice.h"

NSString* const BleCommandYesMark = @"1";
NSString* const BleCommandNoMark = @"0";

@implementation MBWhsWriter

#pragma mark -
#pragma mark Init

- (id)initWithPeripheral:(MBLeManager *)manager leService:(MBWhsService *)leService{
    self = [super init];
    if(self!=nil){
        self.leManager = manager;
        self.isSetting = NO;
        self.leService = leService;
        
        [self.leManager addObserver:self
                         forKeyPath:@"recievedData"
                            options:NSKeyValueObservingOptionNew
                            context:(__bridge void *)self];
        self.commandQue = [[NSMutableDictionary alloc]init];
        self.whsDevice = [[MBWhsDevice alloc]init];
    }
    return self;
}

- (void)initiaraizeCommandQue{
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandSettingModeStart]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandSettingModeEnd]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandMeasureModeStart]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandBehaviorAllRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandBehaviorWritePqrst]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandBehaviorWriteRri]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandAccelerationRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandAccelerationWriteAverage]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandAccelerationWritePeak]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandExteriorRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandSubstrateRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandMainFarmRead]];
    [self.commandQue setObject:BleCommandNoMark
                        forKey:[NSString stringWithFormat:@"%i",typeCommandBleFarmRead]];
}

- (void)dealloc {
    [self.leManager removeObserver:self forKeyPath:@"recievedData"];
}

#pragma mark -
#pragma mark Key Value Observing(KVO)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)self) {
        [self updateValue];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setCommandQue:(NSString *)value commandType:(BleCommand)commandType{
    [self.commandQue setObject:BleCommandYesMark forKey:[NSString stringWithFormat:@"%i",commandType]];
}

- (NSString *)getBleCommandJudge:(NSString *)judge{
    return ([judge isEqualToString:@"OK"])? BleCommandYesMark:BleCommandNoMark;
}

- (void)updateValue {
    if (self.leManager.recievedData==nil) return;
    
    unsigned char scratchVal[self.leManager.recievedData.length];
    [self.leManager.recievedData getBytes:&scratchVal
                                   length:self.leManager.recievedData.length];
    
    NSInteger dataLength = [[NSNumber numberWithChar:scratchVal[0]]integerValue];
    NSString *stringFromData = [[NSString alloc]initWithData:self.leManager.recievedData
                                                    encoding:NSUTF8StringEncoding];
    NSString *command = [stringFromData substringWithRange:NSMakeRange(1, 2)];
    
    if ([command isEqualToString:@"AA"]) {
        //設定モード開始
        self.isSetting = YES;
        NSString *result = [stringFromData substringWithRange:NSMakeRange(4, 2)];
        [self setCommandQue:[self getBleCommandJudge:result] commandType:typeCommandSettingModeStart];
    }
    else if ([command isEqualToString:@"ZZ"]) {
        //設定モード終了
        self.isSetting = NO;
        NSString *result = [stringFromData substringWithRange:NSMakeRange(4, 2)];
        [self setCommandQue:[self getBleCommandJudge:result] commandType:typeCommandSettingModeEnd];
    }
    else if ([command isEqualToString:@"SS"]) {
        //測定モード開始
        NSString *result = [stringFromData substringWithRange:NSMakeRange(4, 2)];
        [self setCommandQue:[self getBleCommandJudge:result] commandType:typeCommandMeasureModeStart];
    }
    else if ([command isEqualToString:@"C2"]) {
        //動作モード・加速度モード一括読み出し
        NSString *behaviorString = [stringFromData substringWithRange:NSMakeRange(4, 1)];
        self.whsDevice.behavior = @([behaviorString integerValue]);
        
        NSString *accelerationString = [stringFromData substringWithRange:NSMakeRange(5, 1)];
        self.whsDevice.acceleration = @([accelerationString integerValue]);
        
        [self setCommandQue:BleCommandYesMark commandType:typeCommandMeasureModeStart];
        
    }
    else if ([command isEqualToString:@"C4"]) {
        NSString *behaviorString;
        switch (dataLength){
            case 6:
                //動作モード設定
                [self setCommandQue:BleCommandYesMark commandType:typeCommandBehaviorWritePqrst];
                [self setCommandQue:BleCommandYesMark commandType:typeCommandBehaviorWriteRri];
                break;
            case 5:
                //動作モード読み出し
                behaviorString = [stringFromData substringWithRange:NSMakeRange(4, 1)];
                self.whsDevice.behavior = @([behaviorString integerValue]);
                [self setCommandQue:BleCommandYesMark commandType:typeCommandBehaviorRead];
                break;
        }
    }
    else if ([command isEqualToString:@"C5"]) {
        NSString *accelerationString;
        switch (dataLength){
            case 6:
                //動作モード設定
                [self setCommandQue:BleCommandYesMark commandType:typeCommandAccelerationWriteAverage];
                [self setCommandQue:BleCommandYesMark commandType:typeCommandAccelerationWritePeak];
                break;
            case 5:
                //加速度モード読み出し
                accelerationString = [stringFromData substringWithRange:NSMakeRange(4, 1)];
                self.whsDevice.acceleration = @([accelerationString integerValue]);
                [self setCommandQue:BleCommandYesMark commandType:typeCommandAccelerationRead];
                break;
        }
    }
    else if ([command isEqualToString:@"F7"]) {
        //外装シリアル番号読み出し
        self.whsDevice.exteriorSerialId = [stringFromData substringWithRange:NSMakeRange(4, 10)];
        [self setCommandQue:BleCommandYesMark commandType:typeCommandExteriorRead];
    }
    else if ([command isEqualToString:@"F8"]) {
        //基板シリアル番号読み出し
        self.whsDevice.substrateSerialId = [stringFromData substringWithRange:NSMakeRange(4, 10)];
        [self setCommandQue:BleCommandYesMark commandType:typeCommandSubstrateRead];
    }
    else if ([command isEqualToString:@"T5"]) {
        //メインフォームバージョン読み出し
        self.whsDevice.mainFarmVersion = [stringFromData substringWithRange:NSMakeRange(4, 6)];
        [self setCommandQue:BleCommandYesMark commandType:typeCommandMainFarmRead];
    }
    else if ([command isEqualToString:@"R3"]) {
        //BLEファームバージョン読み出し
        self.whsDevice.bleFarmVersion = [stringFromData substringWithRange:NSMakeRange(4, 6)];
        [self setCommandQue:BleCommandYesMark commandType:typeCommandBleFarmRead];
    }
}

#pragma mark -
#pragma mark Send Command

- (void)sendCommand:(BleCommand)command{
    NSData *commandString = [MBWhsSendCommand getSendCommand:command];
    [self.leManager writeValue:self.leService.peripheral value:commandString];
    [self.commandQue setObject:BleCommandNoMark forKey:[NSString stringWithFormat:@"%i",command]];
    [self.leManager setNotify:YES peripheral:self.leService.peripheral];
}

@end
