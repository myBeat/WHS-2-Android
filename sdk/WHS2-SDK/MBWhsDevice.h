#import <Foundation/Foundation.h>

@interface MBWhsDevice : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *name;

/* 外装シリアル番号 */
@property (strong, nonatomic) NSString *exteriorSerialId;
/* 基板シリアル番号 */
@property (strong, nonatomic) NSString *substrateSerialId;
/* BLEファームVersion */
@property (strong, nonatomic) NSString *bleFarmVersion;
/* メインファームVersion */
@property (strong, nonatomic) NSString *mainFarmVersion;
/* 動作モード(心拍) */
@property (strong, nonatomic) NSNumber *behavior;
/* 加速度モード */
@property (strong, nonatomic) NSNumber *acceleration;

@end
