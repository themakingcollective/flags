//
//  ResultsController.m
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ResultsController.h"
#import "HighlightsController.h"

@interface ResultsController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIImageView *rosetteImageView;

@end

@implementation ResultsController

@synthesize quiz=_quiz;
@synthesize difficulty=_difficulty;

- (void)viewDidLoad
{
    self.navigationItem.title = [self.difficulty isEqualToString:@"easy"] ? @"colours" : @"patterns + colours";
    NSString *difficulty = [self.difficulty isEqualToString:@"easy"] ? @"Easy" : @"Hard";
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Play-Again", difficulty]];
    [self.playAgainButton setBackgroundImage:image forState:UIControlStateNormal];
    
    NSString *switchImageName = [self.difficulty isEqualToString:@"easy"] ? @"Easy-Switch-to-Hard" : @"Hard-Switch-to-Easy";
    [self.switchButton setBackgroundImage:[UIImage imageNamed:switchImageName] forState:UIControlStateNormal];
    
    NSString *rosetteImageName = [NSString stringWithFormat:@"%@-results-rosette", difficulty];
    [self.rosetteImageView setImage:[UIImage imageNamed:rosetteImageName]];
    
    NSInteger total = self.quiz.correctCount + self.quiz.incorrectCount;
    
    UIFont *font = [UIFont fontWithName:@"Pacifico" size:60];
    [self.scoreLabel setFont:font];
    [self.totalLabel setFont:font];

    // blue is 20, 96, 137
    UIColor *blue = [UIColor colorWithRed:(20 / 255.0f) green:(96 / 255.0f) blue:(137 / 255.0f) alpha:1.0f];
    UIColor *pink = [UIColor colorWithRed:(207 / 255.0f) green:(62 / 255.0f) blue:(96 / 255.0f) alpha:1.0f];
    UIColor *textColor = [self.difficulty isEqualToString:@"easy"] ? pink : blue;
    
    self.scoreLabel.textColor = textColor;
    self.totalLabel.textColor = textColor;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.quiz.correctCount];
    self.totalLabel.text = [NSString stringWithFormat:@"%d", total];
    
    [super viewDidLoad];
}

- (IBAction)highlights:(id)sender
{
    NSLog(@"highlights");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HighlightsController *highlights = [storyboard instantiateViewControllerWithIdentifier:@"HighlightsController"];
    
    highlights.mode = @"puzzle";
    highlights.difficulty = self.difficulty;
    
    [self.navigationController pushViewController:highlights animated:YES];
}

@end
