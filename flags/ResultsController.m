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
    NSInteger total = self.quiz.correctCount + self.quiz.incorrectCount;
    self.resultsLabel.text = [NSString stringWithFormat:@"%d out of %d", self.quiz.correctCount, total];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:YES animated:animated];
    [super viewWillAppear:animated];
}

@end
