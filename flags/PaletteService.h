//
//  PaletteService.h
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaletteService : NSObject

+ (NSArray *)shuffledColors:(NSString *)flagName;

@end
