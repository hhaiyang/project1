//
//  PushManager.h
//  XJX
//
//  Created by Cai8 on 16/1/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  Message Define
 *  @"header"
 *  @"state"
 */

@protocol PushManagerDelegate <NSObject>

- (void)onRemoteMessageReceived:(NSString *)message;

@end

@interface PushManager : NSObject

@property (nonatomic,assign) id<PushManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)prepareWithAppLaunchingOptions:(NSDictionary *)options;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)receiveRemoteNotification:(NSDictionary *)userinfo;

- (void)receiveRemoteNotification:(NSDictionary *)userinfo backgroundFetch:(void (^)(UIBackgroundFetchResult))handler;

- (void)setTag:(NSSet *)tags alias:(NSString *)alias;

@end
