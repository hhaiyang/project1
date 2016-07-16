//
//  MoneyBagAPI.m
//  XJX
//
//  Created by Cai8 on 16/2/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "MoneyBagAPI.h"

#define API_MONEYBAG [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxmoneybag"]

@implementation MoneyBagAPI

+ (MKNetworkOperation *)requestMyMoneyOnCompletion:(onAPIRequestDone)handler{
    id param = @{
                 @"uid" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_MONEYBAG method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)withDrawRequestWithMoney:(CGFloat)money completion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID),
                 @"money" : @(money)
                 };
    return [NetworkingHelper requestFromAPI:API_MONEYBAG method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
