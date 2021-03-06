//
//  Utils.h
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (UIColor *)backgroundColor;
+ (NSArray *)unique:(NSArray *)array;
+ (NSArray *)shuffle:(NSArray *)array;
+ (UIColor *)getRGBAsFromImage:(UIImage *)image atX:(int)xx andY:(int)yy;
+ (UIImage *)colorImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString*)hex;
+ (BOOL) equalColors:(UIColor *)a and:(UIColor *)b;
+ (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView;
+ (NSArray *)pickSample:(NSArray *)array size:(NSInteger)size;
+ (id)copyView:(UIView *)view;
+ (void)resizeFrameToFitImage:(UIImageView *)imageView;
+ (NSFileHandle *)fileAtDocumentsPath:(NSString *)path;
+ (void)deleteDocument:(NSString *)path;
+ (NSString *)documentsPath:(NSString *)path;
+ (NSMutableAttributedString *)style:(NSString *)text with:(NSDictionary *)styles;

@end
