//
//  WechatAgent.m
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import "WechatAgent.h"


#define MAX_THUMB_BYTES_LENGTH 32 * 1000
#define BUFFER_SIZE 1024 * 100

@implementation WechatShareContent

@end

@interface WechatAgent()<WXApiDelegate>
{
    WechatShareContent *currentShareContent;
}

@property (nonatomic,copy) onWechatPayDone payHandler;

@end

@implementation WechatAgent

+ (instancetype)defaultAgent{
    static WechatAgent *agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[WechatAgent alloc] init];
    });
    return agent;
}

- (instancetype)init{
    if(self = [super init]){
        [WXApi registerApp:WX_APP_ID withDescription:@"HNHWEDDING"];
    }
    return self;
}

- (void)wechatLogin{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"STATE";
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp *)resp;
        if(self.onWechatLogined){
            self.onWechatLogined(response);
        }
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        if(response.errCode == 0){//微信分享成功
            if(self.onWechatShared){
                self.onWechatShared(currentShareContent,nil);
            }
            currentShareContent = nil;
        }
        else{
            if(self.onWechatShared){
                self.onWechatShared(currentShareContent,response.errStr);
            }
            currentShareContent = nil;
        }
    }
    else if([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        if(response.errCode == 0){
            if(self.payHandler){
                self.payHandler(nil,NO);
            }
        }
        else{
            if(self.payHandler){
                self.payHandler(@"支付未完成",YES);
            }
        }
    }
}

- (void)onReq:(BaseReq *)req{
    if([req isKindOfClass:[SendMessageToWXReq class]]){
        
    }
    else if([req isKindOfClass:[SendAuthReq class]]){
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]]){
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        NSString *link = obj.url;
        [[XJXLinkageRouter defaultRouter] routeToLink:link];
    }
}

- (void)doShareContent:(WechatShareContent *)content{
    if(![content.image_url isEmpty] && content.image_url){
        [NetworkingHelper requestFromAPI:content.image_url method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *completedOperation) {
            UIImage *image = completedOperation.responseImage;
            image = [image resizedImageToFitInSize:CGSizeMake(50, 50)];
            content.shared_image = image;
            [self shareContent:content];
        } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
            if(self.onWechatShared){
                self.onWechatShared(content,@"网络错误");
            }
        }];
    }
    else{
        if(content.shared_image){
            UIImage *thumbImg = [content.shared_image resizedImageToFitInSize:CGSizeMake(50, 50)];
            content.shared_image = thumbImg;
        }
        [self shareContent:content];
    }
}

- (void)shareContent:(WechatShareContent *)content{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = content.title;
    message.description = content.desc;
    [message setThumbImage:content.shared_image];
    
    if(![content.redirect_url isEmpty]){
        WXWebpageObject *web = [[WXWebpageObject alloc] init];
        web.webpageUrl = content.redirect_url;
        message.mediaObject = web;
    }
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = content.scene == kWechatShareSceneSession ? WXSceneSession : WXSceneTimeline;
    [WXApi sendReq:req];
}

- (BOOL)handleOpenUrl:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (NSString *)getAuthUrl:(NSString *)url{
    NSString *authUrl = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=%@&redirect_uri=%@&response_type=code&scope=snsapi_userinfo&state=%@#wechat_redirect",WX_H5_APP_ID,[url urlEncodedString],@"STATE"];
    return authUrl;
}

- (void)payWithMoney:(int)money trade_no:(NSString *)trade_no behavior:(NSString *)behavior desc:(NSString *)desc completion:(onWechatPayDone)completion{
    _payHandler = completion;
    [PayAPI GetWXSignWithWord:desc trade_no:trade_no behavior:behavior money:money completion:^(id res, NSString *err) {
        if(!err){
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = WX_MCH_ID;
            req.prepayId = res[@"prepayid"];
            req.nonceStr = res[@"noncestr"];
            req.package = res[@"package"];
            req.timeStamp = [res[@"timestamp"] unsignedIntValue];
            req.sign = res[@"paysign"];
            req.openID = [Session current].openid;
            [WXApi sendReq:req];
        }
        else{
            completion(err,NO);
        }
    }];
}

@end
