//
//  OrderAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "OrderAPI.h"

#define API_ORDER [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxorder"]
#define API_MY_ORDER [NSString stringWithFormat:@"%@/%@",BASE_URL,@"order/get"]
#define API_CANCEL_ORDER [NSString stringWithFormat:@"%@/%@",BASE_URL,@"order/cancel"]

@implementation OrderAPI

+ (MKNetworkOperation *)requestOrderingInfoOnCompletion:(onAPIRequestDone)handler{
    id param = @{@"requester" : @([Session current].ID)};
    return [NetworkingHelper requestFromAPI:API_ORDER method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)addOrder:(id)order completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_ORDER method:@"POST" params:order postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)requestMyOrdersWithStatus:(NSString *)status page:(int)page pageSize:(int)pageSize completion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID),
                 @"order_status" : status,
                 @"start" : @(page * pageSize),
                 @"length" : @(pageSize)
                 };
    return [NetworkingHelper requestFromAPI:API_MY_ORDER method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)cancelOrderWithSerial:(NSString *)serial completion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID),
                 @"serialno" : serial,
                 @"role" : @"client"
                 };
    return [NetworkingHelper requestFromAPI:API_CANCEL_ORDER method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
