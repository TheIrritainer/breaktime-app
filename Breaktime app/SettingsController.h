//
//  SettingsController.h
//  breaktimeapp
//
//  Created by Michael Tiel on 01/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef breaktimeapp_SettingsController_h
#define breaktimeapp_SettingsController_h


#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface SettingsController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NotificationManager *notificationManager;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) IBOutlet UIButton *editButton;

-(NSString *)parseFireDate:(UILocalNotification *)notif;

- (IBAction)editButtonClicked:(id)sender;


@end

#endif
