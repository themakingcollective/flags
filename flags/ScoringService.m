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

- (void)correctForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty
{
    self.correctCount++;
    self.roundsCount++;
    
    NSDictionary *aggregate = [self aggregate:flag mode:mode difficulty:difficulty];
    [self updateBestWorst:YES aggregate:aggregate];
}

- (void)incorrectForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty
{
    self.incorrectCount++;
    self.roundsCount++;
    
    NSDictionary *aggregate = [self aggregate:flag mode:mode difficulty:difficulty];
    [self updateBestWorst:NO aggregate:aggregate];
}

- (Flag *)bestFlag
{
    NSLog(@"here");
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
    NSLog(@"here");
    if (self.worstAggregate) {
        NSString *flagName = self.worstAggregate[@"flag_name"];
        return [Flag find_by_name:flagName];
    }
    else {
        return nil;
    }
}

- (NSDictionary *)aggregate:(Flag *)flag mode:(NSString *)mode difficulty:(NSString *)difficulty
{
    NSDictionary *aggregate = [[[AggregatesService sharedInstance] where:@{
       @"flag_name": [flag name],
       @"mode": mode,
       @"difficulty": difficulty
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
    NSInteger incorrectPercent = [aggregate[@"correct_percent"] intValue];
    NSInteger incorrectCount = [aggregate[@"total_count"] intValue];
    NSInteger lowestIncorrectPercent = [self.bestAggregate[@"correct_percent"] intValue];
    NSInteger lowestIncorrectCount = [self.bestAggregate[@"total_count"] intValue];
    
    // First time since reset.
    if (!lowestIncorrectPercent) {
        self.bestAggregate = aggregate;
    }
    // Fewer people got this flag right.
    else if (lowestIncorrectPercent > incorrectPercent) {
        self.bestAggregate = aggregate;
    }
    // The same percentage got this flag right, but it's over a larger sample size.
    else if (lowestIncorrectPercent == incorrectPercent && lowestIncorrectCount < incorrectCount) {
        self.bestAggregate = aggregate;
    }
}

- (void)updateWorst:(NSDictionary *)aggregate
{
    NSInteger correctPercent = [aggregate[@"correct_percent"] intValue];
    NSInteger correctCount = [aggregate[@"total_count"] intValue];
    NSInteger highestCorrectPercent = [self.worstAggregate[@"correct_percent"] intValue];
    NSInteger highestCorrectCount = [self.worstAggregate[@"total_count"] intValue];
    
    // First time since reset.
    if (!highestCorrectPercent) {
        self.worstAggregate = aggregate;
    }
    // More people got this flag right.
    else if (highestCorrectPercent < correctPercent) {
        self.worstAggregate = aggregate;
    }
    // The same percentage got this flag right, but it's over a larger sample size.
    else if (highestCorrectPercent == correctPercent && highestCorrectCount < correctCount) {
        self.worstAggregate = aggregate;
    }
}

@end
