//
//  DifficultyScaler.m
//  flags
//
//  Created by Chris Patuzzo on 05/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "DifficultyScaler.h"

@interface DifficultyScaler ()

@property (nonatomic, strong) NSString *key;

@end

@implementation DifficultyScaler

- (id)initWithDifficultyKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

- (NSArray *)scale:(NSArray *)array
{
    NSInteger currentDifficulty = [self currentDifficulty];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (id<ScalableDifficulty> element in array) {
        if ((NSInteger)[element difficulty] <= currentDifficulty) {
            [mutableArray addObject:element];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (void)increaseDifficulty
{
    NSInteger numberSeen = [self get:self.key];
    numberSeen++;
    [self set:self.key value:numberSeen];
}

- (NSInteger)currentDifficulty
{
    NSInteger numberSeen = [self get:self.key];
    NSArray *thresholds = [self thresholds];
    
    for (NSInteger i = 0; i < [thresholds count]; i++) {
        NSInteger threshold = [(NSNumber *)[thresholds objectAtIndex:i] intValue];

        if (numberSeen < threshold) {
            return i + 1;
        }
    }
    
    return [thresholds count] + 1;
}

- (NSInteger)get:(NSString *)key
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences integerForKey:key];
}

- (void)set:(NSString *)key value:(NSInteger)value
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:value forKey:key];
    [preferences synchronize];
}

- (NSArray *)thresholds
{
    return @[@1, @100];
}

@end
