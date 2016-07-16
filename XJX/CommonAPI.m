//
//  CommonAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "CommonAPI.h"

#define API_CITIES [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxcity"]
#define API_BRANDS [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxbrand"]
#define API_USER [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxuser"]

@implementation CommonAPI

+ (MKNetworkOperation *)requestCitiesWithCompletion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_CITIES method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)matchingBrandWithForm:(id)form completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_BRANDS method:@"POST" params:form postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)bindPhone:(NSString *)phone completion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID),
                 @"phone" : phone
                 };
    return [NetworkingHelper requestFromAPI:API_USER method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
