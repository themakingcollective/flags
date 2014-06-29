//
//  LayeredView.h
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flag.h"

@interface LayeredView : UIView

- (void)setFlag:(Flag *)flag;
- (void)setPaintColor:(UIColor *)color;
- (BOOL)isCorrect;

@end
