//
//  PayAPI.m
//  XJX
//
//  Created by Cai8 on 16/2/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "PayAPI.h"

#define WEIXIN_PAY_SIGN [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/wechatpay"]

@implementation PayAPI

+ (MKNetworkOperation *)GetWXSignWithWord:(NSString *)word trade_no:(NSString *)trade_no behavior:(NSString *)behavior money:(int)money completion:(onAPIRequestDone)handler{
    id param = @{
                 @"pay_desc" : word,
                 @"money" : @(money),
                 @"openid" : [Session current].openid,
                 @"trade_no" : trade_no,
                 @"behavior" : behavior,
                 @"from_client" : @"app_ios"
                 };
    return [NetworkingHelper requestFromAPI:WEIXIN_PAY_SIGN method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseJSON;
        if([response[@"isProcessSuccess"] boolValue]){
            handler(response[@"userinfo"],nil);
        }
        else{
            handler(nil,response[@"errMsg"]);
        }
    } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
        handler(nil,[error description]);
    }];
}

@end
