//
//  NotificationRegistrator.m
//  SmartWatch_NewUI
//
//  Created by Barton on 14-9-13.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import "NotificationRegistrator.h"

@implementation NotificationRegistrator

+ (void)registerNotificationOnTarget:(id)target name:(NSString *)name selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:name object:nil];
}

+ (void)callNoti:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

+ (void)raiseLocalNotificationWithCaption:(NSString *)caption timeAfter:(NSTimeInterval)interval userinfo:(id)userinfo
{
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
        notification.alertBody = caption;
        notification.userInfo = userinfo;
        notification.soundName = @"sound.caf";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else
    {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    }
}

@end
