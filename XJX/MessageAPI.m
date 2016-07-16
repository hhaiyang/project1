//
//  MessageAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "MessageAPI.h"

#define API_MESSAGE [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxmessage"]

@implementation MessageAPI

+ (MKNetworkOperation *)requestMessagesOnCompletion:(onAPIRequestDone)handler{
    id params = @{
                  @"uid" : @([Session current].ID)
                  };
    return [NetworkingHelper requestFromAPI:API_MESSAGE method:@"GET" params:params postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
