//
//  Flag.m
//  flags
//
//  Created by Chris Patuzzo on 29/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "Flag.h"
#import "Utils.h"

@interface Flag ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong) NSDictionary *metadataCache;
@property (nonatomic, strong) NSArray *imagePathsCache;

@end

@implementation Flag

@synthesize name=_name;
static NSArray *allCache;

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
    if (!self.metadataCache) {
        NSString *filename = [NSString stringWithFormat:@"%@/%@/metadata.json", [self.class directoryName], self.name];
        NSData *json = [NSData dataWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:nil];
        self.metadataCache = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    }
    
    return self.metadataCache;
}

- (NSArray *)imagePaths
{
    if (!self.imagePathsCache) {
        NSString *directoryName = [NSString stringWithFormat:@"Puzzles/%@", self.name];
        self.imagePathsCache = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directoryName];
    }

    return self.imagePathsCache;
}

- (NSArray *)correctColors
{
    NSArray *paths = [self imagePaths];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *path in paths) {
        UIColor *color = [self colorFromPath:path];
        if (color) {
            [array addObject:color];
        }
    }
    
    return array;
}

- (NSArray *)incorrectColors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *hexes = [[self metadata] objectForKey:@"incorrect_colors"];
    
    for (NSString *hex in hexes) {
        [array addObject:[Utils colorWithHexString:hex]];
    }
    
    return array;
}

- (UIColor *)colorFromPath:(NSString *)path
{
    NSString *name = [path lastPathComponent];
    name = [name stringByDeletingPathExtension];
    name = [[name componentsSeparatedByString:@"-"] lastObject];
    
    return [Utils colorWithHexString:name];
}

+ (NSArray *)all
{
    if (!allCache) {
        NSMutableArray *flags = [[NSMutableArray alloc] init];
        
        for (NSString *name in [self flagNames]) {
            [flags addObject:[[Flag alloc] initWithName:name]];
        }
        
        allCache = [NSArray arrayWithArray:flags];
    }
    
    return allCache;
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
