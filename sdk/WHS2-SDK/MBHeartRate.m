#import "MBHeartRate.h"

const NSInteger Denominator = 8;

@interface MBHeartRate()
@property (nonatomic) NSMutableArray *rris;
@end

@implementation MBHeartRate

- (id)init {
    self = [super init];
    if (self){
        _rris = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setRri:(NSInteger)rri {
    if (![self filterOutlier:rri]) return;
    
    _rri = rri;
    [self addRris:rri];
}

- (void)addRris:(NSInteger)rri {
    [_rris addObject:@(rri)];
    //8点の処理をするので
    while (_rris.count > 8){
        [_rris removeObjectAtIndex:0];
    }
}

- (NSInteger)calculateAverageRri:(NSArray *)rris {
    NSInteger sum = 0;
    NSInteger dataCount = 0;
    
    for(NSNumber *rrinum in [rris reverseObjectEnumerator]){
        sum += [rrinum integerValue];
        dataCount++;
        
        if (dataCount == Denominator) break;
    }
    if (dataCount < Denominator) {
        return 0;
    }
    
    NSInteger averageRri = sum/dataCount;
    return 60000/averageRri;
}

- (NSInteger)getHeartRateFromRri {
    return [self calculateAverageRri:_rris];
}

- (BOOL)filterOutlier:(NSInteger)rri {
    //心拍計が取得できる範囲を超えるデータは無視する
    if (rri > 2000) return NO;
    if (rri < 300) return NO;
    return YES;
}
@end
