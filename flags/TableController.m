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

@end

@implementation TableController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Flag all] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Flag *flag = [[Flag all] objectAtIndex:indexPath.row];

    tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [Utils backgroundColor];
    
    cell.textLabel.text = flag.name;
    cell.imageView.image = flag.image;
    
    return cell;
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

@end
