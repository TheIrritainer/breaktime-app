//
//  LogController.m
//  breaktimeapp
//
//  Created by Michael Tiel on 14/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogController.h"

@interface LogController ()

@end

@implementation LogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationManager = [NotificationManager singleton];
    self.tableData = [self.notificationManager getLog];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"logIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSMutableArray *row = [self.tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [row objectAtIndex:3];
    
    NSString *epochTime = [row objectAtIndex:1];
    NSTimeInterval seconds = [epochTime doubleValue];
    
    NSDate *logDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yy HH:mm"];
    
    cell.detailTextLabel.text = [format stringFromDate:logDate];
    
    
    return cell;
}


@end