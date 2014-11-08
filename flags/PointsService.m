#import "PointsService.h"

@implementation PointsService

@synthesize gamePoints=_gamePoints;

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
}

- (void)setTotalPoints:(NSInteger)totalPoints
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:totalPoints forKey:@"totalPoints"];
    [preferences synchronize];
}

- (NSInteger)totalPoints
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences integerForKey:@"totalPoints"];
}

@end