//
//  ViewController.m
//  Breaktime app
//
//  Created by Michael Tiel on 25/02/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.breakTimes = @[ @"10.45",
                         @"13.15",
                         @"15.30",
                         @"17.45"];
    
    self.texts = @[ @"No, its not break time yet. Neener-neener",
                    @"Yeaaahhh!!!! it is break time!"];


    self.notificationManager = [NotificationManager singleton];
    [self initializeNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeNotifications
{
    if ([self.notificationManager getNrofNotifications] > 0)
    {
        return;
    }
    
    
    for (id breakTime in self.breakTimes)
    {
        NSArray *timeParts = [breakTime componentsSeparatedByString:@"."];
        [self.notificationManager setNotification:[timeParts[0] intValue] minutes:[timeParts[1] intValue]];

    }
    
}


-(IBAction)breakButtonClicked:(id)sender {

    int breakTimeId = (int) [self.notificationManager isBreakTime];

    [self displayBreaktimeText:breakTimeId];
}

-(void)displayBreaktimeText:(int)textId
{
    NSString *breakString = self.texts[textId];
    
    self.breaktimeText.text = [NSString stringWithFormat:@"Decision:\n\n%@",  breakString];
}

@end
