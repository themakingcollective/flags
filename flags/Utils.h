//
//  Utils.h
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSArray *)pathsFor:(NSString *)flagName;
+ (NSArray *)puzzleFlags;
+ (NSArray *)unique:(NSArray *)array;
+ (NSArray *)shuffle:(NSArray *)array;
+ (UIColor *)getRGBAsFromImage:(UIImage *)image atX:(int)xx andY:(int)yy;
+ (UIImage *)colorImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString*)hex;

@end
