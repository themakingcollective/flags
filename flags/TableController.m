//
//  TableController.m
//  flags
//
//  Created by chris on 26/03/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "TableController.h"
#import "Flag.h"

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

    cell.textLabel.text = flag.name;
    cell.imageView.image = flag.image;
    
    return cell;
}

@end
