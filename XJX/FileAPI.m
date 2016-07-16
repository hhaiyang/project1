//
//  FileAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "FileAPI.h"

#define API_ENTITY_UPLOAD [NSString stringWithFormat:@"%@/%@",BASE_URL,@"file/upload/entityback"]

@implementation FileAPI

+ (MKNetworkOperation *)uploadBase64Image:(NSString *)base64Image completion:(onAPIRequestDone)handler{
    id param = @{
                 @"filetype" : @"Base64Image",
                 @"fileidentities" : @[base64Image],
                 @"requester" : @([Session current].ID),
                 @"from_client" : @"ios_app"
                 };
    return [NetworkingHelper requestFromAPI:API_ENTITY_UPLOAD method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
