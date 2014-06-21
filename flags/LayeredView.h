//
//  LayeredView.h
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayeredView : UIView

- (void)setFlag:(NSString *)flagName;
- (void)setPaintColor:(UIColor *)color;
- (BOOL)isCorrect;

@end
