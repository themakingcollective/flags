//
//  Flag.h
//  flags
//
//  Created by Chris Patuzzo on 29/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DifficultyScaler.h"

@interface Flag : NSObject <ScalableDifficulty>

+ (NSArray *)all;
- (NSDictionary *)metadata;
- (NSArray *)layeredImagePaths;
- (NSArray *)shuffledColors;
- (UIImage *)image;
- (NSInteger)difficulty;
- (NSString *)name;
- (NSArray *)patternFlags;
- (UIImage *)patternImage;
- (BOOL)isEqualTo:(Flag *)other;

@end
