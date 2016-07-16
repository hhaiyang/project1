//
//  ReservationAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ReservationAPI.h"

#define API_RESERVATION [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxreservation"]
#define API_GALLERY_UPDATE [NSString stringWithFormat:@"%@/%@",BASE_URL,@"reservation/gallery/update"]

#define API_ENABLE_REDPACK [NSString stringWithFormat:@"%@/%@",ADMIN_URL,@"Redpack/enableredpack"]

@implementation ReservationAPI

+ (MKNetworkOperation *)requestWeddingInfoWithCompletion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_RESERVATION method:@"GET" params:@{@"requester" : @([Session current].ID)} postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)updateWeddingGalleryWithPhotoId:(NSUInteger)photo_id onWeddingWithId:(NSUInteger)wedding_id atOrder:(int)order completion:(onAPIRequestDone)handler{
    id param = @{
                 @"wedding_id" : @(wedding_id),
                 @"photo_id" : @(photo_id),
                 @"order" : @(order),
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_GALLERY_UPDATE method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)updateWeddingInfo:(id)wedding completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_RESERVATION method:@"POST" params:wedding postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)requestDashboardData:(NSUInteger)wedding_id completion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID),
                 @"wedding_id" : @(wedding_id)
                 };
    return [NetworkingHelper requestFromAPI:API_RESERVATION method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)enableRedpackOnWedding:(NSUInteger)wedding_id completion:(onAPIRequestDone)handler{
    id param = @{
                 @"wid" : @(wedding_id),
                 @"wedding_redpack_status" : @(YES)
                 };
    return [NetworkingHelper requestFromAPI:API_ENABLE_REDPACK method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
