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

@interface PuzzleController () <PaintPotViewDelegate>

@property (weak, nonatomic) IBOutlet LayeredView *layeredView;

@end

@implementation PuzzleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.layeredView setBackgroundColor:[UIColor clearColor]];
    [self.layeredView setFlag:@"France"];
    [self setupPaintPots];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit
{
    if ([self.layeredView isCorrect]) {
        NSLog(@"correct!");
    }
    else {
        NSLog(@"incorrect!");
    }
}

- (void)setupPaintPots
{
    NSArray *colors = [PaletteService shuffledColors:@"France"];
    NSInteger index = 0;
    
    for (PaintPotView *pot in [self paintPotViews]) {
        [pot setDelegate:self];
        
        if (index < [colors count]) {
            [pot setBackgroundColor:[colors objectAtIndex:index]];
            index++;
        }
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
