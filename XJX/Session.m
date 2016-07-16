//
//  Session.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "Session.h"
#import "XJXLoginController.h"

@interface Session()

@property (nonatomic,copy) sessionLoginHandler loginHandler;

@end

@implementation Session

+ (instancetype)current{
    static Session *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[Session alloc] init];
    });
    return session;
}

- (void)fakeInit{
    _ID = 1;
    _wechat_name = @"午夜屠猪男";
    _headimgUrl = @"http://wx.qlogo.cn/mmopen/PiajxSqBRaEINVgZudiajqLCRNStxwmniaCxc0qnTfAEmT4rz313AnkyNVEVcHk8DPvKibej0rQBAYicaTUvdtbaicpg/0";
}

- (instancetype)init{
    if(self = [super init]){
        _ID = -1;
        [self registerNotifications];
    }
    return self;
}

- (void)autoLoginWithCompletion:(sessionLoginHandler)handler{
    if([Session current].isLogined)
        return;
    
    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
    if(!openid){
        XJXLoginController *vc = [[XJXLoginController alloc] init];
        __weak XJXLoginController *_vc = vc;
        vc.onLoginSuccessHandler = ^(BOOL success){
            if(success){
                [_vc dismissViewControllerAnimated:YES completion:^{
                    if(handler){
                        handler(nil);
                    }
                }];
            }
            else{
                if(handler)
                    handler(@"登录失败");
            }
        };
        [[XJXLinkageRouter defaultRouter].activityController presentViewController:vc animated:YES completion:nil];
    }
    else{
        [self serverAuthWithCode:@"" state:openid completion:^(NSString *err) {
            if(!err){
                if(handler){
                    handler(nil);
                }
            }
            else{
                [NSTimer schedule:5 handler:^(CFRunLoopTimerRef ref) {
                    [self autoLoginWithCompletion:handler];
                }];
            }
        }];
    }
}

- (void)registerNotifications{
    [NotificationRegistrator registerNotificationOnTarget:self name:NOTI_ON_WX_AUTH_SUCCESS selector:@selector(onWechatAuthed:)];
}

- (void)onWechatAuthed:(NSNotification *)noti{
    SendAuthResp *wechatResp = noti.object;
    if(wechatResp.errCode == 0){
        NSString *code = wechatResp.code;
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
        [self serverAuthWithCode:code state:state completion:^(NSString *err) {
            if(_loginHandler){
                _loginHandler(err);
            }
        }];
    }
    else{
        if(_loginHandler){
            _loginHandler(wechatResp.errStr);
        }
    }
}

- (void)serverAuthWithCode:(NSString *)code state:(NSString *)state completion:(void (^)(NSString *err))completion{
    [OAuthAPI authWithCode:code state:state ? state : @"STATE" completion:^(id res, NSString *err) {
        if(!err){
            self.ID = [res[@"ID"] integerValue];
            self.openid = res[@"openid"];
            self.wechat_name = res[@"wechat_name"];
            self.headimgUrl = res[@"headimgUrl"];
            self.phone = res[@"phone"];
            [self cache];
            
            [[PushManager sharedManager] setTag:nil alias:self.openid];
        }
        if(completion){
            completion(err);
        }
    }];
}

- (void)cache{
    [[NSUserDefaults standardUserDefaults] setObject:self.openid forKey:@"openid"];
}

- (void)loginWithCompletionHandler:(sessionLoginHandler)handler{
    _loginHandler = handler;
    [[WechatAgent defaultAgent] wechatLogin];
}

- (BOOL)isLogined{
    return _ID != -1;
}

@end
