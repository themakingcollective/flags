#import "PointsService.h"

@implementation PointsService

@synthesize gamePoints=_gamePoints;
@synthesize totalPoints=_totalPoints;

+ (PointsService *)sharedInstance
{
    static dispatch_once_t once;
    static PointsService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)reset
{
    self.totalPoints += self.gamePoints;
    self.gamePoints = 0;
}

- (void)correct
{
    self.gamePoints++;
    NSLog(@"Game points: %ld, Total points: %ld", self.gamePoints, self.totalPoints);
}

@end