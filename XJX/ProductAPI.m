//
//  ProductAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ProductAPI.h"

#define PRODUCT_API [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxproduct"]

@implementation ProductAPI

+ (MKNetworkOperation *)requestProductsInCategory:(NSInteger)categoryId page:(int)page pageSize:(int)pageSize completion:(onAPIRequestDone)handler{
    id param = @{
                 @"category_id" :@(categoryId),
                 @"start" : @(page * pageSize),
                 @"length" : @(pageSize)
                 };
    return [NetworkingHelper requestFromAPI:PRODUCT_API method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
