//
//  ResultsController.m
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ResultsController.h"

@interface ResultsController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation ResultsController

@synthesize quiz=_quiz;

- (void)viewDidLoad
{
    NSInteger total = self.quiz.correctCount + self.quiz.incorrectCount;
    
    UIFont *font = [UIFont fontWithName:@"Pacifico" size:60];
    [self.scoreLabel setFont:font];
    [self.totalLabel setFont:font];

    // blue is 20, 96, 137
    UIColor *pink = [UIColor colorWithRed:(207 / 255.0f) green:(62 / 255.0f) blue:(96 / 255.0f) alpha:1.0f];
    self.scoreLabel.textColor = pink;
    self.totalLabel.textColor = pink;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.quiz.correctCount];
    self.totalLabel.text = [NSString stringWithFormat:@"%ld", total];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:YES animated:animated];
    [super viewWillAppear:animated];
}

@end
