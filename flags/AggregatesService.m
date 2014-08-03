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

- (NSString *)textForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty andCorrectness:(BOOL)correct
{
    NSDictionary *aggregate = [[[AggregatesService sharedInstance] where:@{
                                                                           @"flag_name": [flag name],
                                                                           @"difficulty": difficulty,
                                                                           @"mode": mode
                                                                           }] firstObject];
    
    int correctCount = [aggregate[@"correct_count"] intValue];
    int totalCount = [aggregate[@"total_count"] intValue];
    
    if (totalCount == 0) {
        return @"";
    }
    else {
        float percent = (float)correctCount / totalCount;
        percent *= 100;
        percent = floor(percent + 0.5);
        NSString *term;
        
        if (correct) {
            term = @"right";
        }
        else {
            term = @"wrong";
            percent = 100 - percent;
        }
        
        return [NSString stringWithFormat:@"%0.0f%% of %d people got this %@", percent, totalCount, term];
    }
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
