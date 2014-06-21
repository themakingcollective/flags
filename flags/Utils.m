//
//  Utils.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSArray *)pathsFor:(NSString *)flagName
{
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:flagName];
}

+ (NSArray *)shuffle:(NSArray *)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    NSInteger count = [a count];
    
    for (int i = 0; i < count; i++) {
        int rand = arc4random() % count;
        [a exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
    
    return [NSArray arrayWithArray:a];
}

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
    NSUInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    CGFloat red   = rawData[byteIndex]     / 255.0;
    CGFloat green = rawData[byteIndex + 1] / 255.0;
    CGFloat blue  = rawData[byteIndex + 2] / 255.0;
    CGFloat alpha = rawData[byteIndex + 3] / 255.0;

    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    free(rawData);
    
    return color;
}

+ (UIImage *)colorImage:(UIImage *)image withColor:(UIColor *)color
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(image.size);

    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();

    // set the fill color
    [color setFill];

    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // set the blend mode to copy to replace the color in the image.
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);

    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);

    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+ (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
