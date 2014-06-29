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

@end

@implementation PuzzleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.layeredView.backgroundColor = [UIColor clearColor];
    self.quiz = [[Quiz alloc] initWithArray:[Utils puzzleFlags] andRounds:2];
    
    [self nextFlag];
}

- (void)nextFlag
{
    NSString *flagName = [self.quiz currentElement];
    
    if (flagName) {
        [self.nameLabel setText:flagName];
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
        NSLog(@"correct");
    }
    else {
        [self.quiz incorrect];
        NSLog(@"incorrect");
    }
    
    [self nextFlag];
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

- (void)touchedPaintPot:(UIColor *)color
{
    [self.layeredView setPaintColor:color];
}

@end
