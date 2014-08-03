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

@property (nonatomic, strong, readwrite) NSString *directory;
@property (nonatomic, strong) NSDictionary *metadataCache;
@property (nonatomic, strong) NSArray *imagePathsCache;

@end

@implementation Flag

@synthesize directory=_directory;
static NSArray *allCache;

- (id)initWithDirectory:(NSString *)directory
{
    self = [super init];
    if (self) {
        self.directory = directory;
    }
    return self;
}

- (NSDictionary *)metadata
{
    if (!self.metadataCache) {
        NSString *filename = [NSString stringWithFormat:@"%@/%@/metadata.json", [self.class directoryName], self.directory];
        NSData *json = [NSData dataWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:nil];
        if (!json) {
            NSLog(@"No metadata for %@", self.directory);
        }
        self.metadataCache = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    }
    
    return self.metadataCache;
}

- (NSInteger)difficulty
{
    return [[[self metadata] valueForKey:@"category"] intValue];
}

- (NSString *)name
{
    return [[self metadata] valueForKey:@"name"];
}

- (NSArray *)layeredImagePaths
{
    if (!self.imagePathsCache) {
        NSString *directoryName = [NSString stringWithFormat:@"Puzzles/%@", self.directory];
        NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directoryName];
        NSMutableArray *layerPaths = [NSMutableArray arrayWithArray:paths];

        [layerPaths enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *s, NSUInteger index, BOOL *stop) {
            if ([s rangeOfString:@"original"].location != NSNotFound) {
                [layerPaths removeObjectAtIndex:index];
            }
            if ([s rangeOfString:@"pattern"].location != NSNotFound) {
                [layerPaths removeObjectAtIndex:index];
            }
        }];
        
        self.imagePathsCache = [NSArray arrayWithArray:layerPaths];
    }

    return self.imagePathsCache;
}

- (NSArray *)shuffledColors
{
    NSArray *incorrect = [self incorrectColors];
    incorrect = [Utils shuffle:incorrect];
    
    NSMutableArray *correct = [NSMutableArray arrayWithArray:[self correctColors]];
    [correct addObjectsFromArray:incorrect];
    
    NSArray *colors = [Utils unique:correct];
    
    while ([colors count] < 6) {
        NSLog(@"Not enough colours for %@", [self name]);
        NSMutableArray *mutableColors = [NSMutableArray arrayWithArray:colors];
        [mutableColors addObject:[UIColor whiteColor]];
        colors = [NSArray arrayWithArray:mutableColors];
    }
    
    colors = [Utils pickSample:colors size:6];
    return [Utils shuffle:colors];
}

- (NSArray *)correctColors
{
    NSArray *paths = [self layeredImagePaths];
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

- (NSArray *)incorrectFlags
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *flagDirectories = [[self metadata] objectForKey:@"incorrect_patterns"];
    
    for (NSString *directory in flagDirectories) {
        Flag *flag = [[self class] find_by_directory:directory];
        
        if (flag) {
            [array addObject:flag];
        }
        else {
            NSLog(@"The incorrectFlag '%@' is spelt incorrectly for '%@'", directory, self.name);
        }
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
        
        for (NSString *directory in [self flagDirectories]) {
            [flags addObject:[[Flag alloc] initWithDirectory:directory]];
        }
        
        allCache = [NSArray arrayWithArray:flags];
    }
    
    return allCache;
}

+ (Flag *)find_by_name:(NSString *)name
{
    for (Flag *flag in [[self class] all]) {
        
        if ([[flag name] isEqualToString:name]) {
            return flag;
        }
    }
    
    return nil;
}

+ (Flag *)find_by_directory:(NSString *)directory
{
    for (Flag *flag in [[self class] all]) {
        
        if ([[flag directory] isEqualToString:directory]) {
            return flag;
        }
    }
    
    return nil;
}

- (UIImage *)image
{
    NSString *filename = [NSString stringWithFormat:@"%@/%@/original.png", [self.class directoryName], self.directory];
    return [UIImage imageWithContentsOfFile:filename];
}

- (UIImage *)patternImage
{
    NSString *filename = [NSString stringWithFormat:@"%@/%@/pattern.png", [self.class directoryName], self.directory];
    return [UIImage imageWithContentsOfFile:filename];
}

+ (NSArray *)flagDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:[self directoryName] error:nil];
}

- (NSArray *)patternFlags
{
    NSArray *array = [self incorrectFlags];
    array = [Utils pickSample:array size:3];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    [mutableArray addObject:self];
    array = [NSArray arrayWithArray:mutableArray];
    return [Utils shuffle:array];
}

+ (NSString *)directoryName
{
    NSString *bundlePathName = [[NSBundle mainBundle] bundlePath];
    return [bundlePathName stringByAppendingPathComponent:@"Puzzles"];
}

- (BOOL)isEqualTo:(Flag *)other
{
    return [[self name] isEqualToString:other.name];
}

@end
