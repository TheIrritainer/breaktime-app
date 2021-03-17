//
//  NotificationManager.h
//  Breaktime app
//
//  Created by Michael Tiel on 28/02/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef Breaktime_app_NotificationManager_h
#define Breaktime_app_NotificationManager_h

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"


@interface NotificationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic,strong) NSMutableArray *notifications;
@property (nonatomic, strong) DBManager *db;

+(instancetype)singleton;

-(instancetype)initPrivate;

-(void) initGPS;

-(BOOL) setNotification:(int)hours minutes:(int)minutes;
-(void) deleteNotification:(NSInteger) notifId;
-(void) askPermission;
-(void) loadExistingNotifications;
- (NSDate*)createDateFromBreaktime:(int)hours minutes:(int)minutes;
-(NSString*)parseTimeFromDate:(NSDate *)fromDate;


- (BOOL) isBreakTime;

- (NSInteger)calculateMinutes:(NSInteger)hours minutes:(NSInteger)minutes;
- (NSInteger)getNowMinutes;


- (BOOL) notificationTimeExists:(int)hours minutes:(int)minutes;
-(UILocalNotification*) findNotification:(int)hours minutes:(int)minutes;

-(void)addNotificationByDate:(NSDate *)date isDaily:(BOOL)isDaily isPrivate:(BOOL)isPrivate;

-(int)getNrofNotifications;

-(NSArray *)getLog;

@end

#endif
