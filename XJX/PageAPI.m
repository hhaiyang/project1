//
//  PageAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/11.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "PageAPI.h"

@implementation PageAPI

+ (MKNetworkOperation *)requestPageFromUrl:(NSString *)url completion:(onAPIRequestDone)done{
    return [NetworkingHelper requestFromAPI:url method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseString;
        if(![response hasPrefix:@"<html>"]){
            NSString *template = [NSString readFromFile:@"template" type:@"html"];
            response = [template stringByReplacingOccurrencesOfString:@"#htmlcontent" withString:response];
        }
        done(response,nil);
    } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
        done(nil,[error description]);
    }];
}

@end
