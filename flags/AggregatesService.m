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
        }
    }
}

- (NSArray *)where:(NSDictionary *)filters
{
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
        
        return [self.aggregates filteredArrayUsingPredicate:filter];
    }
    else {
        return @[];
    }
}

@end
