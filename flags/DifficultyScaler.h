//
//  DifficultyScaler.h
//  flags
//
//  Created by Chris Patuzzo on 05/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScalableDifficulty

- (NSInteger)difficulty;

@end

@interface DifficultyScaler : NSObject

- (id)initWithDifficultyKey:(NSString *)key;
- (NSArray *)scale:(NSArray *)array;
- (void)increaseDifficulty;

@end
