//
//  DifficultyScaler.m
//  flags
//
//  Created by Chris Patuzzo on 05/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "DifficultyScaler.h"

@implementation DifficultyScaler

+ (NSArray *)scale:(NSArray *)array forDifficultyKey:(NSString *)key
{
    NSInteger currentDifficulty = [self currentDifficulty:key];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (id<ScalableDifficulty> element in array) {
        if ((NSInteger)[element difficulty] <= currentDifficulty) {
            [mutableArray addObject:element];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

+ (void)increaseDifficultyForKey:(NSString *)key
{
    NSInteger numberSeen = [self get:key];
    numberSeen++;
    [self set:key value:numberSeen];
}

+ (NSInteger)currentDifficulty:(NSString *)key
{
    NSInteger numberSeen = [self get:key];
    NSArray *thresholds = [self thresholds];
    
    for (NSInteger i = 0; i < [thresholds count]; i++) {
        NSInteger threshold = [(NSNumber *)[thresholds objectAtIndex:i] intValue];

        if (numberSeen < threshold) {
            return i + 1;
        }
    }
    
    return [thresholds count] + 1;
}

+ (NSInteger)get:(NSString *)key
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences integerForKey:key];
}

+ (void)set:(NSString *)key value:(NSInteger)value
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:value forKey:key];
    [preferences synchronize];
}

+ (NSArray *)thresholds
{
    return @[@20, @100];
}

@end
