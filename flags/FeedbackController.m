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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UIImageView *correctFlagView;

@end

@implementation FeedbackController

@synthesize difficulty=_difficulty;
@synthesize playerWasCorrect=_playerWasCorrect;
@synthesize layeredView=_layeredView;
@synthesize correctFlag=_correctFlag;

- (void)viewDidLoad
{
    self.navigationItem.title = [self puzzleController].navigationItem.title;
    [self.view addSubview:self.layeredView];
    
    self.titleLabel.text = self.playerWasCorrect ? @"CORRECT" : @"WRONG";
    
    [self.correctFlagView setImage:[self.correctFlag image]];
    self.flagLabel.text = [NSString stringWithFormat:@"%@:", [self.correctFlag name]];
    
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
