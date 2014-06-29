//
//  PuzzleController.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PuzzleController.h"
#import "LayeredView.h"
#import "PaintPotView.h"
#import "PaletteService.h"
#import "Quiz.h"
#import "ResultsController.h"
#import "Utils.h"

@interface PuzzleController () <PaintPotViewDelegate>

@property (nonatomic, weak) IBOutlet LayeredView *layeredView;
@property (nonatomic, strong) Quiz *quiz;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;

@end

@implementation PuzzleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.layeredView.backgroundColor = [UIColor clearColor];
    self.quiz = [[Quiz alloc] initWithArray:[Utils puzzleFlags] andRounds:2];
    
    [self nextFlag:nil];
}

- (void)nextFlag:(NSTimer *)timer
{
    [self setUserInteraction:YES];
    [self.layeredView setPaintColor:nil];
    
    NSString *flagName = [self.quiz currentElement];
    
    if (flagName) {
        [self.nameLabel setText:flagName];
        [self.feedbackLabel setText:@""];
        [self.layeredView setFlag:flagName];
        [self setupPaintPots:flagName];
    }
    else {
        [self showResults];
    }
}

- (IBAction)submit
{
    if ([self.layeredView isCorrect]) {
        [self.quiz correct];
        [self.feedbackLabel setText:@"correct"];
    }
    else {
        [self.quiz incorrect];
        [self.feedbackLabel setText:@"incorrect"];
    }
    
    [self setUserInteraction:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (void)showResults
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ResultsController *results = [storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
    results.quiz = self.quiz;
    
    [self.navigationController pushViewController:results animated:YES];
}

- (void)setupPaintPots:(NSString *)flagName
{
    NSArray *pots = [self paintPotViews];
    NSArray *colors = [PaletteService shuffledColors:flagName];
    
    if ([pots count] != [colors count]) {
        [NSException raise:@"Counts do not match" format:@"For flag %@", flagName];
    }
    
    for (NSInteger i = 0; i < [pots count]; i++) {
        PaintPotView *pot = [pots objectAtIndex:i];
        UIColor *color = [colors objectAtIndex:i];
        
        [pot setDelegate:self];
        [pot setBackgroundColor:color];
    }
}

- (NSArray *)paintPotViews
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[PaintPotView class]]) {
            [array addObject:subview];
        }
    }
    
    return [NSArray arrayWithArray:array];
}

- (void)touchedPaintPot:(PaintPotView *)paintPot
{
    [self.layeredView setPaintColor:paintPot.backgroundColor];
    
    for (PaintPotView *view in [self paintPotViews]) {
        [view setHighlighted:NO];
    }
    [paintPot setHighlighted:YES];
}

- (void)setUserInteraction:(BOOL)state
{
    self.view.userInteractionEnabled = state;
    self.navigationController.view.userInteractionEnabled = state;
    
    for (UIView *view in self.view.subviews) {
        [view setUserInteractionEnabled:state];
    }
}

@end
