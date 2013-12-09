#import <Foundation/Foundation.h>

typedef NS_ENUM(int, BleCommand){
    typeCommandSettingModeStart=0,          //設定モード開始
    typeCommandSettingModeEnd=1,            //設定モード終了
    typeCommandMeasureModeStart=2,          //計測モード開始
    typeCommandBehaviorAllRead=3,           //動作モード、加速度モード読み込み
    typeCommandBehaviorRead=8,              //動作モード読み込み
    typeCommandBehaviorWritePqrst=9,        //動作モードをPQRSTに設定する
    typeCommandBehaviorWriteRri=10,         //動作モードをRRIに設定する
    typeCommandAccelerationRead=11,         //加速度モード読み込み
    typeCommandAccelerationWriteAverage=12, //加速度モードを移動平均に設定する
    typeCommandAccelerationWritePeak=13,    //加速度モードをピークホールドに設定する
    typeCommandExteriorRead=14,             //外装シリアル番号を読み込む
    typeCommandSubstrateRead=15,            //基板シリアル番号を読み込む
    typeCommandMainFarmRead=16,             //メインファームバージョンを読み込む
    typeCommandBleFarmRead=17,              //BLEファームバージョンを読み込む
};

@interface MBWhsSendCommand : NSObject

+ (NSData *)getSendCommand:(BleCommand)command;
+ (NSData *)getSendCommandStartSetting;
+ (NSData *)getSendCommandEndSetting;
+ (NSData *)getSendCommandStartMeasure;
+ (NSData *)getSendCommandReadMode;
+ (NSData *)getSendCommandReadBehaviorMode;
+ (NSData *)getSendCommandWritePqrst;
+ (NSData *)getSendCommandWriteRri;
+ (NSData *)getSendCommandReadAccelerationMode;
+ (NSData *)getSendCommandWriteAverage;
+ (NSData *)getSendCommandWritePeak;
+ (NSData *)getSendCommandReadExperiorSerial;
+ (NSData *)getSendCommandReadSubstrateSerial;
+ (NSData *)getSendCommandMainFarm;
+ (NSData *)getSendCommandBleFarm;

@end
