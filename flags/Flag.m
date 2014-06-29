//
//  Flag.m
//  flags
//
//  Created by Chris Patuzzo on 29/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "Flag.h"

@interface Flag ()

@property (nonatomic, strong, readwrite) NSString *name;

@end

@implementation Flag

@synthesize name=_name;

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (NSDictionary *)metadata
{
    NSString *filename = [NSString stringWithFormat:@"%@/%@/metadata.json", [self.class directoryName], self.name];
    NSData *json = [NSData dataWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:nil];
    return [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
}

+ (NSArray *)all
{
    NSMutableArray *flags = [[NSMutableArray alloc] init];
    
    for (NSString *name in [self flagNames]) {
        [flags addObject:[[Flag alloc] initWithName:name]];
    }
    
    return [NSArray arrayWithArray:flags];
}

+ (NSArray *)flagNames
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:[self directoryName] error:nil];
}

+ (NSString *)directoryName
{
    NSString *bundlePathName = [[NSBundle mainBundle] bundlePath];
    return [bundlePathName stringByAppendingPathComponent:@"Puzzles"];
}

@end
