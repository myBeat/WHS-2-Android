#import "MBHeartRate.h"


@interface MBHeartRate()
@end

@implementation MBHeartRate

- (NSInteger)getHeartRateFromRri{
    return [self calculateAverageRri:_rri];
}

- (NSInteger)calculateAverageRri:(NSInteger)rri{
    return (int)60000/rri;
}

@end
