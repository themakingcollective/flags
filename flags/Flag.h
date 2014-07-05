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

@property (nonatomic, strong, readonly) NSString *name;

+ (NSArray *)all;
- (NSDictionary *)metadata;
- (NSArray *)layeredImagePaths;
- (NSArray *)shuffledColors;
- (UIImage *)image;
- (NSInteger)difficulty;

@end
