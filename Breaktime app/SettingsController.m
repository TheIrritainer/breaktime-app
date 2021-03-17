//
//  SettingsController.m
//  breaktimeapp
//
//  Created by Michael Tiel on 01/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//



#import "SettingsController.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationManager = [NotificationManager singleton];
    self.tableData = [[NSMutableArray alloc] init];
//    self.tableData = self.notificationManager.notifications;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSString *)parseFireDate:(UILocalNotification *)notif
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
        
    NSString *cellContent = [dateFormatter stringFromDate:notif.fireDate];
    return cellContent;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notificationManager.notifications count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"notifIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    UILocalNotification *currentNotif = (UILocalNotification *) self.notificationManager.notifications[indexPath.row];
    
    cell.textLabel.text = [self parseFireDate:currentNotif];

    if (currentNotif.repeatInterval == NSCalendarUnitDay)
    {
        cell.detailTextLabel.text = @"Daily break";
    }
    else
    {
        cell.detailTextLabel.text = @"Extra break";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete)
    {
        return;
    }
    
    [self.table beginUpdates];
    
    [self.notificationManager deleteNotification:indexPath.row];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     
    [self.table endUpdates];
    [self.table reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"SettingsViewController: viewDidAppear");
    [super viewDidAppear:animated];
    
    [self.table reloadData];
    
    NSLog(@"%lu", (unsigned long)[self.notificationManager.notifications count]);
    }


- (IBAction)editButtonClicked:(id)sender
{
    static BOOL editMode = NO;

    if (editMode)
    {
        editMode = NO;
        [self.table setEditing:NO animated:YES];
    }
    else
    {
        editMode = YES;
        [self.table setEditing:YES animated:YES];
    }
    
}


@end