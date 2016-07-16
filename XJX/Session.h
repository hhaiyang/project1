//
//  Session.h
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^sessionLoginHandler)(NSString *err);

@interface Session : NSObject

@property (nonatomic,assign) NSUInteger ID;
@property (nonatomic,copy) NSString *wechat_name;
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *headimgUrl;
@property (nonatomic,copy) NSString *phone;

+ (instancetype)current;

- (void)loginWithCompletionHandler:(sessionLoginHandler)handler;
- (void)autoLoginWithCompletion:(sessionLoginHandler)handler;

@property (nonatomic,readonly) BOOL isLogined;



@end
