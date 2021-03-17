//
//  NavigationViewController.m
//  breaktimeapp
//
//  Created by Michael Tiel on 15/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"


@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Nav view loaded");
    self.notificationManager = [NotificationManager singleton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end