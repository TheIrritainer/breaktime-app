//
//  ExtraBreaktimeController.h
//  breaktimeapp
//
//  Created by Michael Tiel on 01/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef breaktimeapp_ExtraBreaktimeController_h
#define breaktimeapp_ExtraBreaktimeController_h


#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface ExtraBreaktimeController : UIViewController

@property (nonatomic, strong) NotificationManager *notificationManager;
@property (nonatomic, strong) IBOutlet UIDatePicker *time;
@property (nonatomic, strong) IBOutlet UISwitch *daily;
@property (nonatomic, strong) IBOutlet UISwitch *personalBreak;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

- (IBAction)editButtonClicked:(id)sender;

@end

#endif
