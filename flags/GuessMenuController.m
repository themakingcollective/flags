//
//  GuessMenuController.m
//  flags
//
//  Created by Chris Patuzzo on 22/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "GuessMenuController.h"
#import "Utils.h"

@interface GuessMenuController ()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation GuessMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *defaultFont = [UIFont fontWithName:@"BPreplay" size:13];
    
    self.topLabel.font = defaultFont;
    self.topLabel.attributedText = [Utils style:self.topLabel.text with:@{
        @"country":[UIFont fontWithName:@"BPreplay-Italic" size:13],
        @"flag":[UIFont fontWithName:@"BPreplay-Bold" size:13]
    }];
    
    self.bottomLabel.font = defaultFont;
    self.bottomLabel.attributedText = [Utils style:self.bottomLabel.text with:@{
       @"flag":[UIFont fontWithName:@"BPreplay-Italic" size:13],
       @"country":[UIFont fontWithName:@"BPreplay-Bold" size:13]
    }];
}

@end
