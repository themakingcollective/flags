//
//  PaletteService.m
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PaletteService.h"
#import "Utils.h"

@implementation PaletteService

+ (NSArray *)shuffledColors:(NSString *)flagName
{
    NSMutableArray *correct = [self correctColors:flagName];
    NSMutableArray *incorrect = [self incorrectColors:flagName];
    
    NSArray *colors = [correct arrayByAddingObjectsFromArray:incorrect];
    
    colors = [Utils shuffle:colors];
    colors = [self pad:colors with:[UIColor lightGrayColor] upto:6];
    
    return colors;
}

+ (NSMutableArray *)correctColors:(NSString *)flagName
{
    NSArray *paths = [Utils pathsFor:flagName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *path in paths) {
        UIColor *color = [self colorFromPath:path];
        if (color) {
            [array addObject:color];
        }
    }
    
    return array;
}

+ (UIColor *)colorFromPath:(NSString *)path
{
    NSString *name = [path lastPathComponent];
    name = [name stringByDeletingPathExtension];
    name = [[name componentsSeparatedByString:@"-"] lastObject];
    
    return [Utils colorWithHexString:name];
}

+ (NSMutableArray *)incorrectColors:(NSString *)flagName
{
    return [NSMutableArray arrayWithArray:@[[UIColor blueColor]]];
}

// This can be removed once we have verified the colors are correct.
+ (NSArray *)pad:(NSArray *)colors with:(UIColor *)color upto:(NSInteger)count
{
    if ([colors count] != count) {
        NSLog(@"Warning: Palette is being padded");
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:colors];
    
    while ([array count] < count) {
        [array addObject:color];
    }
    
    [array subarrayWithRange:(NSRange){0, count}];
    
    return [NSArray arrayWithArray:array];
}


@end
