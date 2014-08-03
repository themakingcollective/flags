//
//  AggregatesService.m
//  flags
//
//  Created by Chris Patuzzo on 27/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "AggregatesService.h"

@interface AggregatesService ()

@property (nonatomic, strong) NSArray *aggregates;

@end

@implementation AggregatesService

+ (AggregatesService *)sharedInstance
{
    static dispatch_once_t once;
    static AggregatesService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSDictionary *)withStats:(NSDictionary *)aggregate
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:aggregate];
    NSNumber *correctPercentNumber;
    NSNumber *incorrectPercentNumber;

    NSInteger correctCount = [aggregate[@"correct_count"] intValue];
    NSInteger totalCount = [aggregate[@"total_count"] intValue];

    if (totalCount == 0) {
        return aggregate;
    }
    else {
        float correctPercent = (float)correctCount / totalCount;
        correctPercent *= 100;
        correctPercent = floor(correctPercent + 0.5);
        float incorrectPercent = 100 - correctPercent;

        correctPercentNumber = [NSNumber numberWithInt:(NSInteger)correctPercent];
        incorrectPercentNumber = [NSNumber numberWithInt:(NSInteger)incorrectPercent];

        [dictionary setObject:correctPercentNumber forKey:@"correct_percent"];
        [dictionary setObject:incorrectPercentNumber forKey:@"incorrect_percent"];

        return [NSDictionary dictionaryWithDictionary:dictionary];
    }
}

- (NSURL *)url
{
    NSString *host = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Flags Server"];
    NSString *path = [NSString stringWithFormat:@"%@/aggregates", host];

    return [NSURL URLWithString:path];
}

- (void)fetch
{
    NSData *data = [NSData dataWithContentsOfURL:[self url]];

    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        if (dict) {
            self.aggregates = dict[@"aggregates"];
            [self saveAggregatesToUserDefaults];
        }
    }

    if (!self.aggregates) {
        [self loadAggregatesFromUserDefaults];
    }
}

- (NSString *)textForFlag:(Flag *)flag andMode:(NSString *)mode andVariant:(NSString *)variant andCorrectness:(BOOL)correct
{
    NSDictionary *aggregate = [[[AggregatesService sharedInstance] where:@{
       @"flag_name": [flag name],
       @"variant": variant,
       @"mode": mode
    }] firstObject];

    aggregate = [[self class] withStats:aggregate];

    NSInteger totalCount = [aggregate[@"total_count"] intValue];
    NSNumber *percent;
    NSString *term;

    if (totalCount == 0) {
        return @"";
    }
    else {
        if (correct) {
            percent = aggregate[@"correct_percent"];
            term = @"right";
        }
        else {
            percent = aggregate[@"incorrect_percent"];
            term = @"wrong";
        }
    }

    return [NSString stringWithFormat:@"%@%% of %d people got this %@", percent, totalCount, term];
}

- (NSArray *)where:(NSDictionary *)filters
{
    NSArray *filteredArray = @[];

    if (self.aggregates) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSDictionary *aggregate = (NSDictionary *)evaluatedObject;

            for (NSString *key in filters) {
                NSString *aValue = [aggregate objectForKey:key];
                NSString *fValue = [filters objectForKey:key];

                if (![aValue isEqualToString:fValue]) {
                    return false;
                }
            }
            return true;
        }];

        filteredArray = [self.aggregates filteredArrayUsingPredicate:filter];
    }

    if ([filteredArray count] == 0) {
        filteredArray = @[@{@"correct_count": @0, @"total_count": @0}];
    }

    return filteredArray;
}

- (void)loadAggregatesFromUserDefaults
{
    NSData *archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"aggregates"];
    self.aggregates = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}

- (void)saveAggregatesToUserDefaults
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.aggregates];
    [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"aggregates"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
