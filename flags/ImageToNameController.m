//
//  ImageToNameController.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ImageToNameController.h"
#import "Quiz.h"
#import "DifficultyScaler.h"
#import "Flag.h"
#import "ScoringService.h"
#import "HighlightsController.h"
#import "EventRecorder.h"

@interface ImageToNameController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *cButton;
@property (weak, nonatomic) IBOutlet UIButton *dButton;

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) NSArray *choices;

@end

@implementation ImageToNameController

- (void)viewDidLoad
{
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:@"image-to-name-quiz"];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:10];
    
    [[ScoringService sharedInstance] reset];
    [self nextFlag:nil];
    
    [super viewDidLoad];
}

- (void)nextFlag:(NSTimer *)timer
{
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        self.imageView.image = [flag image];
        self.choices = [self.quiz choices:4];
        [self updateButtons];
    }
    else {
        [self highlights];
    }
}

- (void)updateButtons
{
    UIColor *blue = [UIColor colorWithRed:(110 / 255.0) green:(149 / 255.0) blue:(233 / 255.0) alpha:1.0f];
    
    Flag *aFlag = [self.choices objectAtIndex:0];
    [self.aButton setTitle:[aFlag name] forState:UIControlStateNormal];
    [self.aButton setBackgroundColor:blue];
    
    Flag *bFlag = [self.choices objectAtIndex:1];
    [self.bButton setTitle:[bFlag name] forState:UIControlStateNormal];
    [self.bButton setBackgroundColor:blue];
    
    Flag *cFlag = [self.choices objectAtIndex:2];
    [self.cButton setTitle:[cFlag name] forState:UIControlStateNormal];
    [self.cButton setBackgroundColor:blue];
    
    Flag *dFlag = [self.choices objectAtIndex:3];
    [self.dButton setTitle:[dFlag name] forState:UIControlStateNormal];
    [self.dButton setBackgroundColor:blue];
}

- (IBAction)submit:(UIButton *)button
{
    NSString *flagName = button.titleLabel.text;
    Flag *flag = [Flag find_by_name:flagName];
    
    if ([flag isEqualTo:[self.quiz currentElement]]) {
        [self recordEvent:YES flag:flag];
        [[ScoringService sharedInstance] correctForFlag:flag andMode:@"quiz" andVariant:@"image_to_name"];
        [button setBackgroundColor:[UIColor greenColor]];
    }
    else {
        [self recordEvent:NO flag:flag];
        [[ScoringService sharedInstance] incorrectForFlag:flag andMode:@"quiz" andVariant:@"image_to_name"];
        [button setBackgroundColor:[UIColor redColor]];
    }
    
    [self.quiz nextRound];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (void)highlights
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HighlightsController *highlights = [storyboard instantiateViewControllerWithIdentifier:@"HighlightsController"];
    
    highlights.mode = @"quiz";
    highlights.variant = @"image_to_name";
    
    [self.navigationController pushViewController:highlights animated:YES];
}

- (void)recordEvent:(BOOL)playerWasCorrect flag:(Flag *)flag
{
    [[EventRecorder sharedInstance] record:@{
         @"flag_name": [flag name],
         @"mode": @"quiz",
         @"variant": @"image_to_name",
         @"correct": playerWasCorrect ? @"true" : @"false"
    }];
}

@end
