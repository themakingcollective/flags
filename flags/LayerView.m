//
//  LayerView.m
//  flags
//
//  Created by Chris Patuzzo on 07/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "LayerView.h"
#import "Utils.h"

@interface LayerView ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) NSString *path;

@end

@implementation LayerView

- (id)initWithPath:(NSString *)path
{
    self.currentColor = [UIColor whiteColor];
    self.path = path;
    
    return [super initWithImage:[UIImage imageWithContentsOfFile:path]];
}

- (void)setColor:(UIColor *)color
{
    self.currentColor = color;
    self.image = [Utils colorImage:self.image withColor:color];
}

- (BOOL)isCorrect
{
    if ([self isTemplate]) {
        return YES;
    }

    NSString *hex = [self pathSubstring];
    UIColor *correctColor = [Utils colorWithHexString:hex];
    
    return [self.currentColor isEqual:correctColor];
}

- (BOOL)isTemplate
{
    return [[self pathSubstring] isEqualToString:@"template"];
}

- (NSString *)pathSubstring
{
    NSString *filename = [self.path lastPathComponent];
    NSString *basename = [filename stringByDeletingPathExtension];
    return [[basename componentsSeparatedByString:@"-"] lastObject];
}

@end
