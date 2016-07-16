//
//  FundingAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "FundingAPI.h"

#define API_WISHLIST [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxwishlist"]
#define API_REMOVE_ITEM_FROM_WISHLIST [NSString stringWithFormat:@"%@/%@",BASE_URL,@"wishlist/delete"]
#define API_END_FUNDING_ITEMS [NSString stringWithFormat:@"%@/%@",BASE_URL,@"wishlist/endfund"]
#define API_ADD_CUSTOM_ITEM_FROM_WISHLIST [NSString stringWithFormat:@"%@/%@",BASE_URL,@"wishlist/addcustom"]
#define API_SHARE_WISHITEMS [NSString stringWithFormat:@"%@/%@",BASE_URL,@"wedding/invitation/share"]
#define API_GET_FUNDING_ITEMS [NSString stringWithFormat:@"%@/%@",BASE_URL,@"wedding/fundingitems"]

@implementation FundingAPI

+ (MKNetworkOperation *)requestProductInWishlistOnCompletion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_WISHLIST method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)addItemToWishlistWithProductId:(NSUInteger)product_id amount:(int)amount model:(NSString *)model completion:(onAPIRequestDone)handler{
    id param = @{
                 @"product_id" : @(product_id),
                 @"amount" : @(amount),
                 @"requester" : @([Session current].ID),
                 @"model" : model
                 };
    return [NetworkingHelper requestFromAPI:API_WISHLIST method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)addCustomItemToWishlist:(XJXCustomWishItem *)item completion:(onAPIRequestDone)handler{
    id param = @{
                 @"item" : [item getDictionary],
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_ADD_CUSTOM_ITEM_FROM_WISHLIST method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)deleteItemFromWishlistWithWishItemId:(NSString *)wishitem_ids customIds:(NSString *)custom_ids completion:(onAPIRequestDone)handler{
    id param = @{
                 @"wishitem_ids" : wishitem_ids,
                 @"custom_wishitem_ids" : custom_ids,
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_REMOVE_ITEM_FROM_WISHLIST method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)shareItems:(id)post completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_SHARE_WISHITEMS method:@"POST" params:post postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)requestFundingItemsOnCompletion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_GET_FUNDING_ITEMS method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)endItemFundingWithItemId:(NSUInteger)wishitem_id itemType:(NSString *)wishitem_type completion:(onAPIRequestDone)handler{
    id param = @{
                 @"wishitem_id" : @(wishitem_id),
                 @"wishitem_type": wishitem_type,
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_END_FUNDING_ITEMS method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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
