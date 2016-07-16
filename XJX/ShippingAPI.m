//
//  ShippingAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ShippingAPI.h"

#define API_SHIPPING [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxshipping"]

@implementation ShippingAPI

+ (MKNetworkOperation *)requestShippingInfosOnCompletion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_SHIPPING method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)addShipping:(NSDictionary *)shippingInfo completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_SHIPPING method:@"POST" params:shippingInfo postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)setShippingDefaultWithId:(NSUInteger)shipping_id completion:(onAPIRequestDone)handler{
    id param = @{
                 @"shipping_id" : @(shipping_id),
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_SHIPPING method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (void)requestShippingInfoWithShippingNo:(NSString *)no completion:(onAPIRequestDone)handler{
    NSString *check = [NSString stringWithFormat:@"http://www.kuaidi100.com/autonumber/autoComNum?text=%@",no];
    
    [NetworkingHelper requestFromAPI:check method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseJSON;
        NSString *comCode = response[@"comCode"];
        if([comCode isEmpty] && [response[@"auto"] count] > 0){
            comCode = [response[@"auto"] firstObject][@"comCode"];
            NSString *apiPath = [NSString stringWithFormat:@"http://www.kuaidi100.com/query?type=%@&postid=%@",comCode,no];
            [NetworkingHelper requestFromAPI:apiPath method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *_completedOperation) {
                id response = _completedOperation.responseJSON;
                if([response[@"status"] intValue] == 200){
                    handler(response[@"data"],nil);
                }
                else{
                    handler(nil,response[@"message"]);
                }
                
            } progress:nil error:^(MKNetworkOperation *_completedOperation, NSError *_error) {
                handler(nil,[_error description]);
            }];
        }
        else{
            handler(nil,@"未找到此快递信息");
        }
    } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
        handler(nil,[error description]);
    }];
}

@end
