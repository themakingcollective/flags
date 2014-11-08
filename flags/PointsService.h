#import <Foundation/Foundation.h>

@interface PointsService : NSObject

@property (nonatomic, assign) NSInteger gamePoints;
@property (nonatomic, assign) NSInteger totalPoints;

+ (PointsService *)sharedInstance;
- (void) reset;
- (void) correct;

@end
