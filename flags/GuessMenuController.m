//
//  GuessMenuController.m
//  flags
//
//  Created by Chris Patuzzo on 22/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "GuessMenuController.h"

@interface GuessMenuController ()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation GuessMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *font = [UIFont fontWithName:@"BPreplay" size:13];
    self.topLabel.font = font;
    self.bottomLabel.font = font;
}

@end
