//
//  TableCell.m
//  flags
//
//  Created by Chris Patuzzo on 13/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "TableCell.h"
#import "Utils.h"

@implementation TableCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [Utils backgroundColor];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setFrame:CGRectMake(10, 7, 115, 80)];
    [self resizeFrameToFitImage:self.imageView];
    [self.imageView.layer setCornerRadius:3.0f];
    
    CGRect f = self.textLabel.frame;
    [self.textLabel setFrame:CGRectMake(140, f.origin.y, 180, f.size.height)];
}

- (void)resizeFrameToFitImage:(UIImageView *)imageView
{
    CGRect frame = [Utils getFrameSizeForImage:imageView.image inImageView:imageView];
    
    CGRect imageViewFrame = CGRectMake(
        imageView.frame.origin.x + frame.origin.x,
        imageView.frame.origin.y + frame.origin.y,
        frame.size.width,
        frame.size.height
    );
    
    imageView.frame = imageViewFrame;
    imageView.layer.masksToBounds = YES;
}

@end
