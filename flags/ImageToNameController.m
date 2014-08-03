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
    [self nextFlag];
    
    [super viewDidLoad];
}

- (void)nextFlag
{
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        self.imageView.image = [flag image];
        self.choices = [self.quiz choices:4];
        [self updateButtons];
    }
    else {
        NSLog(@"finished!");
    }
}

- (void)updateButtons
{
    Flag *aFlag = [self.choices objectAtIndex:0];
    [self.aButton setTitle:[aFlag name] forState:UIControlStateNormal];
    
    Flag *bFlag = [self.choices objectAtIndex:1];
    [self.bButton setTitle:[bFlag name] forState:UIControlStateNormal];
    
    Flag *cFlag = [self.choices objectAtIndex:2];
    [self.cButton setTitle:[cFlag name] forState:UIControlStateNormal];
    
    Flag *dFlag = [self.choices objectAtIndex:3];
    [self.dButton setTitle:[dFlag name] forState:UIControlStateNormal];
}

- (IBAction)submit:(UIButton *)button
{
    NSString *flagName = button.titleLabel.text;
    Flag *flag = [Flag find_by_name:flagName];
    
    if ([flag isEqualTo:[self.quiz currentElement]]) {
//        [[ScoringService sharedInstance] correctForFlag:flag andMode:@"quiz" andDifficulty:@"image_to_name"];
    }
    else {
//        [[ScoringService sharedInstance] incorrectForFlag:flag andMode:@"quiz" andDifficulty:@"image_to_name"];
    }
    
    [self.quiz nextRound];
    [self nextFlag];
}

@end
