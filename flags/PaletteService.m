//
//  PaletteService.m
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PaletteService.h"

@implementation PaletteService

+ (NSArray *)shuffledColors:(NSString *)flagName
{
    return @[[UIColor redColor], [UIColor greenColor]];
}

@end
