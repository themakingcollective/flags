#import <Foundation/Foundation.h>

@interface PointsService : NSObject

@property (nonatomic, assign) NSInteger gamePoints;

+ (PointsService *)sharedInstance;
- (void) reset;
- (void) correct;
- (NSInteger)totalPoints;

@end
