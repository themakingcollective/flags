//
//  ScoringService.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ScoringService.h"
#import "AggregatesService.h"

@interface ScoringService ()

@property (nonatomic, strong) NSDictionary *bestAggregate;
@property (nonatomic, strong) NSDictionary *worstAggregate;

@end

@implementation ScoringService

@synthesize roundsCount=_roundsCount;
@synthesize correctCount=_correctCount;
@synthesize incorrectCount=_incorrectCount;

+ (ScoringService *)sharedInstance
{
    static dispatch_once_t once;
    static ScoringService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)reset
{
    self.roundsCount = 0;
    self.correctCount = 0;
    self.incorrectCount = 0;
    self.bestAggregate = nil;
    self.worstAggregate = nil;
}

- (void)correctForFlag:(Flag *)flag andMode:(NSString *)mode andVariant:(NSString *)variant
{
    self.correctCount++;
    self.roundsCount++;

    NSDictionary *aggregate = [self aggregate:flag mode:mode variant:variant];
    [self updateBestWorst:YES aggregate:aggregate];
}

- (void)incorrectForFlag:(Flag *)flag andMode:(NSString *)mode andVariant:(NSString *)variant
{
    self.incorrectCount++;
    self.roundsCount++;

    NSDictionary *aggregate = [self aggregate:flag mode:mode variant:variant];
    [self updateBestWorst:NO aggregate:aggregate];
}

- (Flag *)bestFlag
{
    if (self.bestAggregate) {
        NSString *flagName = self.bestAggregate[@"flag_name"];
        return [Flag find_by_name:flagName];
    }
    else {
        return nil;
    }
}

- (Flag *)worstFlag
{
    if (self.worstAggregate) {
        NSString *flagName = self.worstAggregate[@"flag_name"];
        return [Flag find_by_name:flagName];
    }
    else {
        return nil;
    }
}

- (NSDictionary *)aggregate:(Flag *)flag mode:(NSString *)mode variant:(NSString *)variant
{
    NSDictionary *aggregate = [[[AggregatesService sharedInstance] where:@{
       @"flag_name": [flag name],
       @"mode": mode,
       @"variant": variant
    }] firstObject];

    return [AggregatesService withStats:aggregate];
}

- (void)updateBestWorst:(BOOL)best aggregate:(NSDictionary *)aggregate
{
    if (aggregate[@"correct_percent"]) {
        best ? [self updateBest:aggregate] : [self updateWorst:aggregate];
    }
    else {
        // There are no results for this aggregate, so skip.
        return;
    }
}

- (void)updateBest:(NSDictionary *)aggregate
{
    NSInteger correctPercent = [aggregate[@"correct_percent"] intValue];
    NSInteger correctCount = [aggregate[@"total_count"] intValue];
    NSInteger lowestCorrectPercent = [self.bestAggregate[@"correct_percent"] intValue];
    NSInteger lowestCorrectCount = [self.bestAggregate[@"total_count"] intValue];

    NSLog(@"correctPercent: %d, correctCount: %d, lowestCorrectPercent: %d, lowestCorrectCount: %d", correctPercent, correctCount, lowestCorrectPercent, lowestCorrectCount);
    
    // First time since reset.
    if (!self.bestAggregate) {
        self.bestAggregate = aggregate;
        NSLog(@"** setting best flag - first time");
    }
    // Fewer people got this flag right.
    else if (lowestCorrectPercent > correctPercent) {
        self.bestAggregate = aggregate;
        NSLog(@"** setting best flag - fewer people got this right");
    }
    // The same percentage got this flag right, but it's over a larger sample size.
    else if (lowestCorrectPercent == correctPercent && lowestCorrectCount < correctCount) {
        self.bestAggregate = aggregate;
        NSLog(@"** setting best flag - larger sample size");
    }
}

- (void)updateWorst:(NSDictionary *)aggregate
{
    NSInteger correctPercent = [aggregate[@"correct_percent"] intValue];
    NSInteger correctCount = [aggregate[@"total_count"] intValue];
    NSInteger highestCorrectPercent = [self.worstAggregate[@"correct_percent"] intValue];
    NSInteger highestCorrectCount = [self.worstAggregate[@"total_count"] intValue];

    NSLog(@"correctPercent: %d, correctCount: %d, highestCorrectPercent: %d, highestCorrectCount: %d", correctPercent, correctCount, highestCorrectPercent, highestCorrectCount);
    
    // First time since reset.
    if (!self.worstAggregate) {
        self.worstAggregate = aggregate;
        NSLog(@"** setting worst flag - first time");
    }
    // More people got this flag right.
    else if (highestCorrectPercent < correctPercent) {
        self.worstAggregate = aggregate;
        NSLog(@"** setting worst flag - more people got this right");
    }
    // The same percentage got this flag right, but it's over a larger sample size.
    else if (highestCorrectPercent == correctPercent && highestCorrectCount < correctCount) {
        self.worstAggregate = aggregate;
        NSLog(@"** setting worst flag - larger sample size");
    }
}

@end
