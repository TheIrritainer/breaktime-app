//
//  ViewController.h
//  Breaktime app
//
//  Created by Michael Tiel on 25/02/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) NSArray *breakTimes;
@property (nonatomic,strong) NSArray *texts;

@property (nonatomic, strong) NotificationManager *notificationManager;

@property (nonatomic, strong) IBOutlet UILabel *breaktimeText;

- (void)initializeNotifications;

- (IBAction)breakButtonClicked:(id)sender;

-(void)displayBreaktimeText:(int)textId;

@end

