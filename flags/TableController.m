//
//  TableController.m
//  flags
//
//  Created by chris on 26/03/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "TableController.h"
#import "Flag.h"

@interface TableController ()

@end

@implementation TableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Flag all] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Flag *flag = [[Flag all] objectAtIndex:indexPath.row];

    cell.textLabel.text = flag.name;
    cell.imageView.image = flag.image;
    
    return cell;
}

@end
