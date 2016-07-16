//
//  PushManager.m
//  XJX
//
//  Created by Cai8 on 16/1/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "PushManager.h"
#import "lib/JPUSHService.h"

@implementation PushManager

+ (instancetype)sharedManager{
    static PushManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushManager alloc] init];
        [manager prepare];
    });
    return manager;
}

- (void)prepare{
    [NotificationRegistrator registerNotificationOnTarget:self name:kJPFNetworkDidReceiveMessageNotification selector:@selector(onMessageRecved:)];
}

- (void)onMessageRecved:(NSNotification *)noti{
    NSDictionary *message = noti.userInfo;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onRemoteMessageReceived:)]){
        [self.delegate onRemoteMessageReceived:message[@"content"]];
    }
}

- (void)prepareWithAppLaunchingOptions:(NSDictionary *)options{
    [JPUSHService setBadge:0];
    
    if(SYSTEM_VERSION_GREATER_THAN(@"8.0")){
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    }
    else{
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound) categories:nil];
    }
    
    [JPUSHService setupWithOption:options appKey:JPUSH_KEY channel:@"App Store" apsForProduction:YES];
}

- (void)registerDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)receiveRemoteNotification:(NSDictionary *)userinfo{
    [JPUSHService handleRemoteNotification:userinfo];
}

- (void)receiveRemoteNotification:(NSDictionary *)userinfo backgroundFetch:(void (^)(UIBackgroundFetchResult))handler{
    [JPUSHService handleRemoteNotification:userinfo];
    handler(UIBackgroundFetchResultNewData);
}

- (void)setTag:(NSSet *)tags alias:(NSString *)alias{
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if(iResCode == 0){
            NSLog(@"push notification registered");
        }
    }];
}

@end
