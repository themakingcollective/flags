//
//  TableController.m
//  flags
//
//  Created by chris on 26/03/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "TableController.h"
#import "Flag.h"
#import "Utils.h"

@interface TableController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *groupedFlags;

@end

@implementation TableController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.groupedFlags = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 26; i++) {
            [self.groupedFlags addObject:[[NSMutableArray alloc] init]];
        }
        
        for (Flag *flag in [Flag all]) {
            NSInteger c = [[flag name] characterAtIndex:0];
            [self.groupedFlags[c - 65] addObject:flag];
        }
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupedFlags count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupedFlags[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Flag *flag = self.groupedFlags[indexPath.section][indexPath.row];

    [self setColors:tableView];
    
    cell.textLabel.text = [flag name];
    cell.imageView.image = flag.image;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [Utils backgroundColor];
    return header;
}

- (void)setColors:(UITableView *)tableView
{
    tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [Utils backgroundColor];
    [tableView setSectionIndexBackgroundColor:[Utils backgroundColor]];
}

@end
