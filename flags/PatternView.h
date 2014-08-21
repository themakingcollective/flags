//
//  PatternView.h
//  flags
//
//  Created by Chris Patuzzo on 12/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flag.h"

@protocol PatternViewDelegate <NSObject>

- (void)touchedPattern:(id)pattern;

@end

@interface PatternView : UIImageView

@property (strong, nonatomic) Flag *flag;
@property (weak, nonatomic) id delegate;

- (void)setFlagImage;
- (void)setupHighlights;
- (void)setHighlighted:(BOOL)state;

@end
