//
//  ExtraBreaktimeController.m
//  breaktimeapp
//
//  Created by Michael Tiel on 01/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import "ExtraBreaktimeController.h"
#import "SettingsController.h"

@interface ExtraBreaktimeController ()

@end

@implementation ExtraBreaktimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationManager = [NotificationManager singleton];
    
    NSLog(@"in de settings controller");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)editButtonClicked:(id)sender
{
    NSDate *fireDate = self.time.date;
    BOOL repeatDaily = self.daily.on;
    BOOL privateBreak = self.personalBreak.on;
    
    if ([fireDate timeIntervalSinceNow] < 0)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        fireDate = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:fireDate  options:0];
        
    }
    
    [self.notificationManager addNotificationByDate:fireDate isDaily:repeatDaily isPrivate:privateBreak];
    

    // reload all the stuffs
    [self.notificationManager loadExistingNotifications];

    [self.navigationController popViewControllerAnimated:YES];
}

@end