//
//  Utils.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIColor *)getRGBAsFromImage:(UIImage *)image atX:(int)xx andY:(int)yy
{
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    CGFloat red   = rawData[byteIndex]     / 255.0;
    CGFloat green = rawData[byteIndex + 1] / 255.0;
    CGFloat blue  = rawData[byteIndex + 2] / 255.0;
    CGFloat alpha = rawData[byteIndex + 3] / 255.0;
    
    NSLog(@"red is %f", red);
    NSLog(@"green is %f", green);
    NSLog(@"blue is %f", blue);
    NSLog(@"alpha is %f", alpha);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    free(rawData);
    
    return color;
}

@end
