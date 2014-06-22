//
//  ResultsController.m
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ResultsController.h"

@interface ResultsController ()

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@end

@implementation ResultsController

@synthesize quiz=_quiz;

- (void)viewDidLoad
{
    self.resultsLabel.text = [NSString stringWithFormat:@"Correct: %d, Incorrect: %d", self.quiz.correctCount, self.quiz.incorrectCount];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

@end
