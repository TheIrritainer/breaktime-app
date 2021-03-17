//
//  NavigationViewController.h
//  breaktimeapp
//
//  Created by Michael Tiel on 15/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef breaktimeapp_NavigationViewController_h
#define breaktimeapp_NavigationViewController_h


#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface NavigationViewController : UINavigationController

@property (nonatomic, strong) NotificationManager *notificationManager;

@end
#endif
