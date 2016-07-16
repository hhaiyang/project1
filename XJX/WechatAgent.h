//
//
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef enum {
    kWechatShareSceneTimeline,
    kWechatShareSceneSession
}WechatShareScene;

@interface WechatShareContent : NSObject

@property (nonatomic,strong) UIImage *shared_image;

@property (nonatomic,copy) NSString *shareId;
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *redirect_url;

@property (nonatomic,assign) WechatShareScene scene;

@end

typedef void (^onWechatLogined)(SendAuthResp *resp);
typedef void (^onWechatShared)(WechatShareContent *content, NSString *err);

typedef void (^onWechatPayDone)(NSString *errMsg,BOOL canceled);

@interface WechatAgent : NSObject

@property (nonatomic,copy) onWechatLogined onWechatLogined;
@property (nonatomic,copy) onWechatShared onWechatShared;

+ (instancetype)defaultAgent;

- (void)doShareContent:(WechatShareContent *)content;

- (void)wechatLogin;

- (BOOL)handleOpenUrl:(NSURL *)url;

- (NSString *)getAuthUrl:(NSString *)url;

- (void)payWithMoney:(int)money trade_no:(NSString *)trade_no behavior:(NSString *)behavior desc:(NSString *)desc completion:(onWechatPayDone)completion;

@end
