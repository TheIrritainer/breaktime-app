//
//  AppDelegate.h
//  Breaktime app
//
//  Created by Michael Tiel on 25/02/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


-(void)createAlert:(UILocalNotification *)notification;

@end

