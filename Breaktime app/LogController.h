//
//  LogController.h
//  breaktimeapp
//
//  Created by Michael Tiel on 01/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef breaktimeapp_LogController_h
#define breaktimeapp_LogController_h


#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface LogController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NotificationManager *notificationManager;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *tableData;


@end

#endif

