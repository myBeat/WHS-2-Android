#import <Foundation/Foundation.h>

#import "MBWhsSendCommand.h"

@class MBLeManager;
@class MBWhsService;
@class MBWhsDevice;

extern NSString* const BleCommandYesMark;
extern NSString* const BleCommandNoMark;

@interface MBWhsWriter : NSObject

@property (nonatomic) MBLeManager *leManager;
@property (nonatomic) MBWhsService *leService;
@property (nonatomic) MBWhsDevice *whsDevice;
@property (nonatomic) NSMutableDictionary *commandQue;
@property (nonatomic) BOOL isSetting;

- (id)initWithPeripheral:(MBLeManager *)manager leService:(MBWhsService *)leService;
- (void)initiaraizeCommandQue;
- (void)sendCommand:(BleCommand)command;

@end
