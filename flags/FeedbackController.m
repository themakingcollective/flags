//
//  FeedbackController.m
//  flags
//
//  Created by Chris Patuzzo on 19/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "FeedbackController.h"
#import "PuzzleController.h"

@interface FeedbackController ()

@property (nonatomic, strong) NSString *difficulty;

@end

@implementation FeedbackController

@synthesize difficulty=_difficulty;
@synthesize correct=_correct;

- (void)viewDidLoad
{
    NSString *previousTitle = [self puzzleController].navigationItem.title;
    
    self.difficulty = [previousTitle isEqualToString:@"colours"] ? @"easy" : @"hard";
    self.navigationItem.title = previousTitle;
    
    [super viewDidLoad];
}

- (IBAction)dismiss:(id)sender {
    [[self puzzleController] nextFlag];
    [self.navigationController popViewControllerAnimated:NO];
}

- (PuzzleController *)puzzleController
{
    NSInteger previousIndex = [self.navigationController.viewControllers count] - 2;
    UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:previousIndex];
    return (PuzzleController *)previousController;
}

@end
