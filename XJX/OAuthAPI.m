//
//  OAuthAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "OAuthAPI.h"

#define WEIXIN_OAUTH [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/weixinoauth"]

@implementation OAuthAPI

+ (MKNetworkOperation *)authWithCode:(NSString *)code state:(NSString *)state completion:(onAPIRequestDone)handler{
    id param = @{
                 @"code" : code,
                 @"state" : state,
                 @"client" : @"app_ios"
                 };
    return [NetworkingHelper requestFromAPI:WEIXIN_OAUTH method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
