//
//  NotificationRegistrator.h
//  SmartWatch_NewUI
//
//  Created by Barton on 14-9-13.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationNames.h"

@interface NotificationRegistrator : NSObject

+ (void)registerNotificationOnTarget:(id)target name:(NSString *)name selector:(SEL)selector;

+ (void)callNoti:(NSString *)name object:(id)object;

+ (void)raiseLocalNotificationWithCaption:(NSString *)caption timeAfter:(NSTimeInterval)interval userinfo:(id)userinfo;

@end
