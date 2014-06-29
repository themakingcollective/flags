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

+ (NSArray *)shuffledColors:(Flag *)flag
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    colors = (NSMutableArray *)[colors arrayByAddingObjectsFromArray:[flag correctColors]];
    colors = (NSMutableArray *)[colors arrayByAddingObjectsFromArray:[flag incorrectColors]];
    colors = (NSMutableArray *)[Utils unique:colors];
    colors = (NSMutableArray *)[Utils shuffle:colors];
    
    return colors;
}


@end
