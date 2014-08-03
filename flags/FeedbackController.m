//
//  FeedbackController.m
//  flags
//
//  Created by Chris Patuzzo on 19/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "FeedbackController.h"
#import "PuzzleController.h"
#import "Utils.h"
#import "ResultsController.h"
#import "AggregatesService.h"

@interface FeedbackController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *correctFlagView;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation FeedbackController

@synthesize difficulty=_difficulty;
@synthesize playerWasCorrect=_playerWasCorrect;
@synthesize layeredView=_layeredView;
@synthesize correctFlag=_correctFlag;

- (void)viewDidLoad
{
    self.navigationItem.title = [self puzzleController].navigationItem.title;
    
    UIColor *green = [UIColor colorWithRed:(73 / 255.0f) green:(142 / 255.0f) blue:(93 / 255.0f) alpha:1.0f];
    UIColor *red = [UIColor colorWithRed:(194 / 255.0f) green:(32 / 255.0f) blue:(38 / 255.0f) alpha:1.0f];
    
    UIColor *color = self.playerWasCorrect ? green : red;
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:30];
    
    [self.titleLabel setTextColor:color];
    [self.titleLabel setFont:titleFont];
    [self.socialLabel setTextColor:color];
    
    NSArray *phrases = self.playerWasCorrect ? [self goodPhrases] : [self badPhrases];
    phrases = [Utils shuffle:phrases];
    self.titleLabel.text = [phrases firstObject];
    
    [self.view addSubview:self.layeredView];
    
    [self.correctFlagView setImage:[self.correctFlag image]];
    [self.correctFlagView setContentMode:UIViewContentModeScaleAspectFit];
    self.correctFlagView.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.correctFlagView.layer.borderWidth = 1.0f;
    [self.correctFlagView.layer setCornerRadius:3.0f];

    self.flagLabel.text = [NSString stringWithFormat:@"%@:", [self.correctFlag name]];
    
    NSString *imageName = [self.difficulty isEqualToString:@"easy"] ? @"Next-Button-Easy-Enabled" : @"Next-Button-Hard-Enabled";
    [self.nextButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    self.socialLabel.text = [[AggregatesService sharedInstance] textForFlag:self.correctFlag andMode:@"puzzle" andDifficulty:self.difficulty andCorrectness:!self.playerWasCorrect];
    
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [self.layeredView setFrame:CGRectMake(20, 106, 130, 90)];
    [Utils resizeFrameToFitImage:self.correctFlagView];
    
    [super viewDidLayoutSubviews];
}

- (IBAction)dismiss:(id)sender {
    if ([[self puzzleController] nextFlag]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        [self showResults];
    }
}

- (PuzzleController *)puzzleController
{
    NSInteger previousIndex = [self.navigationController.viewControllers count] - 2;
    UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:previousIndex];
    return (PuzzleController *)previousController;
}

- (void)showResults
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ResultsController *results = [storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
    results.quiz = self.quiz;
    results.difficulty = self.difficulty;
    
    [self.navigationController pushViewController:results animated:YES];
}

- (NSArray *)goodPhrases
{
    return @[
        @"Good job!",
        @"Awesome!",
        @"Nice one!",
        @"You're a pro!",
        @"Way to go!"
    ];
}

- (NSArray *)badPhrases
{
    return @[
        @"Bad luck!",
        @"Not quite",
        @"Nice try",
        @"That's not right",
        @"Nuh-uh"
    ];
}

@end
