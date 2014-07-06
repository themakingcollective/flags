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

- (void)setupBorders
{
    self.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.layer.borderWidth = 2.0f;
    [self.layer setCornerRadius:5.0f];
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
    
    return [Utils equalColors:self.currentColor and:correctColor];
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
