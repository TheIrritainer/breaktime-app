//
//  NotificationManager.m
//  Breaktime app
//
//  Created by Michael Tiel on 28/02/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationManager.h" 

@implementation NotificationManager

CLLocationManager *locationManager;
CLLocation *lastLocation;


-(instancetype)initPrivate
{
    self = [super init];
    
    if (self)
    {
        [self askPermission];
        [self loadExistingNotifications];
        
        [self initGPS];
        
        NSLog(@"%@", self.notifications);
        self.db = [[DBManager alloc] initWithDatabaseFilename:@"breaktimedb.sql"];
        
        NSArray *logs = [self getLog];
        NSLog(@"%@", logs);
    }
    return self;
}

-(void)initGPS
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    lastLocation = nil;
    
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [locationManager requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];

    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    lastLocation = newLocation;
    
    [locationManager stopUpdatingLocation];
    
}

-(instancetype)init
{
    return [[self class] singleton];
}

+(instancetype)singleton
{
    static NotificationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
    
}

-(NSArray *)getLog
{
    return [self.db getQuery:@"SELECT * FROM breaktimelog ORDER BY id DESC"];
}

- (BOOL) isBreakTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowMinutes = [self getNowMinutes];
    
    for(UILocalNotification *notif in self.notifications)
    {
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:notif.fireDate];
        NSInteger breakTimeInMinutes = [self calculateMinutes:[components hour] minutes:[components minute]];
        if (nowMinutes - breakTimeInMinutes < 20 && nowMinutes - breakTimeInMinutes >= 0)
        {
            return YES;
        }
        
    }
    return NO;
}

- (NSInteger)getNowMinutes
{
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:today];
    
    return [self calculateMinutes:[components hour] minutes:[components minute]];
}


-(NSInteger)calculateMinutes:(NSInteger)hours minutes:(NSInteger)minutes
{
    NSInteger toReturn = 0;
    toReturn += 60 * hours;
    toReturn += minutes;
    return toReturn;
}



-(void) askPermission
{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

-(void) loadExistingNotifications
{
    NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.notifications = [currentNotifications mutableCopy];
}


-(BOOL)setNotification:(int)hours minutes:(int)minutes
{
    if ([self notificationTimeExists:hours minutes:minutes])
    {
        return NO;
    }
    
    NSDate *fireDate = [self createDateFromBreaktime:hours minutes:minutes];
    [self addNotificationByDate:fireDate isDaily:YES isPrivate:NO];

    return YES;
}

-(void) deleteNotification:(NSInteger) notifId
{
    
    UILocalNotification *notif = self.notifications[notifId];
    [[UIApplication sharedApplication] cancelLocalNotification:notif];
    
    if (! [notif.alertBody containsString:@"Private"])
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO breaktimelog (logtype, logtime, reason) values('user', strftime('%%s', 'now'), 'deleted breaktime %@') ", [self parseTimeFromDate:notif.fireDate]];
        [self.db execQuery:query];
    }
    [self.notifications removeObjectAtIndex:notifId];
}

-(void)addNotificationByDate:(NSDate *)date isDaily:(BOOL)isDaily isPrivate:(BOOL)isPrivate
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        notification.fireDate = date;
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = @"breaktime.aiff";
        
        if(isDaily)
        {
            notification.repeatInterval = NSCalendarUnitDay;
        }
        
        if (isPrivate)
        {
            notification.alertBody = @"Private break time!!";
        }
        else
        {
            notification.alertBody = @"Break time!!";
            NSString *query = [NSString stringWithFormat:@"INSERT INTO breaktimelog (logtype, logtime, reason) values('user', strftime('%%s', 'now'), 'added breaktime %@' ) ", [self parseTimeFromDate:notification.fireDate]];
            [self.db execQuery:query];
        }

        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [self loadExistingNotifications];
    }
}

-(NSString*)parseTimeFromDate:(NSDate *)fromDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    return [formatter stringFromDate:fromDate];
}


-(int)getNrofNotifications
{
    return (int)[self.notifications count];
}

- (NSDate*)createDateFromBreaktime:(int)hours minutes:(int)minutes
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    
    // Set the time components manually
    [dateComps setHour:hours];
    [dateComps setMinute:minutes];
    [dateComps setSecond:0];
    
    NSDate *alertTime = [calendar dateFromComponents:dateComps];
    return alertTime;
}

- (BOOL) notificationTimeExists:(int)hours minutes:(int)minutes
{
    return ([self findNotification:hours minutes:minutes] != nil);
}

-(UILocalNotification*) findNotification:(int)hours minutes:(int)minutes
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for(UILocalNotification *notif in self.notifications)
    {
        NSDate *date = notif.fireDate;
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        
        if ([components hour] == hours && [components minute] == minutes)
        {
            return notif;
        }
    }
    return nil;
}


@end