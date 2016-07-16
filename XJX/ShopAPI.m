//
//  ShopAPI.m
//  XJX
//
//  Created by Cai8 on 16/1/9.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ShopAPI.h"

#define API_GET_POPULAR_PRODUCTS [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxproduct"]
#define API_GET_CATEGORIES [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxcategory"]
#define API_GET_ARTICLES [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxarticle"]
#define API_GET_SHOP_DATA [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxshop"]
#define API_SHOP_CART [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxshoppingcart"]
#define API_REMOVE_ITEM_FROM_SHOP_CART [NSString stringWithFormat:@"%@/%@",BASE_URL,@"cart/delete"]
#define API_UPDATE_ITEM_FROM_SHOP_CART [NSString stringWithFormat:@"%@/%@",BASE_URL,@"cart/update"]

#define API_GET_PRODUCT_DETAIL [NSString stringWithFormat:@"%@/%@",BASE_URL,@"api/xjxproduct"]

@implementation ShopAPI

+ (MKNetworkOperation *)requestPopularProductsWithPage:(NSUInteger)page length:(NSUInteger)length completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_GET_POPULAR_PRODUCTS method:@"GET"
                                     params:@{@"page" : [NSNumber numberWithInteger:page],
                                              @"length" : [NSNumber numberWithInteger:length]}
                                   postData:nil
                                 completion:^(MKNetworkOperation *completedOperation) {
                                     id response = completedOperation.responseJSON;
                                     if([response[@"isProcessSuccess"] boolValue]){
                                         handler(response[@"userinfo"],nil);
                                     }
                                     else{
                                         handler(nil,response[@"errMsg"]);
                                     }
                                 }
                                   progress:nil
                                      error:^(MKNetworkOperation *completedOperation, NSError *error){
                                          handler(nil,[error description]);
                                      }];
}

+ (MKNetworkOperation *)requestCategoriesWithCompletion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_GET_CATEGORIES method:@"GET"
                                     params:nil
                                   postData:nil
                                 completion:^(MKNetworkOperation *completedOperation) {
                                     id response = completedOperation.responseJSON;
                                     if([response[@"isProcessSuccess"] boolValue]){
                                         handler(response[@"userinfo"],nil);
                                     }
                                     else{
                                         handler(nil,response[@"errMsg"]);
                                     }
                                 }
                                   progress:nil
                                      error:^(MKNetworkOperation *completedOperation, NSError *error){
                                          handler(nil,[error description]);
                                      }];
}

+ (MKNetworkOperation *)requestArticlesWithCompletion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_GET_ARTICLES method:@"GET"
                                     params:nil
                                   postData:nil
                                 completion:^(MKNetworkOperation *completedOperation) {
                                     id response = completedOperation.responseJSON;
                                     if([response[@"isProcessSuccess"] boolValue]){
                                         handler(response[@"userinfo"],nil);
                                     }
                                     else{
                                         handler(nil,response[@"errMsg"]);
                                     }
                                 }
                                   progress:nil
                                      error:^(MKNetworkOperation *completedOperation, NSError *error){
                                          handler(nil,[error description]);
                                      }];
}

+ (MKNetworkOperation *)requestShopDetailWithCompletion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_GET_SHOP_DATA method:@"GET" params:nil postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)requestProductWithId:(NSString *)productId completion:(onAPIRequestDone)handler{
    return [NetworkingHelper requestFromAPI:API_GET_PRODUCT_DETAIL method:@"GET" params:@{@"product_id" : productId} postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)requestProductInShoppingCartOnCompletion:(onAPIRequestDone)handler{
    id param = @{
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_SHOP_CART method:@"GET" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
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

+ (MKNetworkOperation *)addItemToCartWithProductId:(NSUInteger)product_id amount:(int)amount model:(NSString *)model completion:(onAPIRequestDone)handler{
    id param = @{
                 @"product_id" : @(product_id),
                 @"amount" : @(amount),
                 @"requester" : @([Session current].ID),
                 @"model" : model
                 };
    return [NetworkingHelper requestFromAPI:API_SHOP_CART method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseJSON;
        if(response[@"isProcessSuccess"]){
            handler(response[@"userinfo"],nil);
        }
        else{
            handler(nil,response[@"errMsg"]);
        }
    } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
        handler(nil,[error description]);
    }];
}

+ (MKNetworkOperation *)deleteItemFromCartWithCartItemId:(NSUInteger)cartitem_id completion:(onAPIRequestDone)handler{
    id param = @{
                 @"cartitem_id" : @(cartitem_id),
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_REMOVE_ITEM_FROM_SHOP_CART method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseJSON;
        if(response[@"isProcessSuccess"]){
            handler(response[@"userinfo"],nil);
        }
        else{
            handler(nil,response[@"errMsg"]);
        }
    } progress:nil error:^(MKNetworkOperation *completedOperation, NSError *error) {
        handler(nil,[error description]);
    }];
}

+ (MKNetworkOperation *)updateCartItemWithAmount:(int)amount model:(NSArray *)model cart_id:(NSUInteger)cart_id product_id:(NSUInteger)product_id completion:(onAPIRequestDone)handler{
    id param = @{
                 @"cart_id" : @(cart_id),
                 @"amount" : @(amount),
                 @"model" : [model stringByJoinProperty:^NSString *(id item) {
                     return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
                 } delimiter:@"|"],
                 @"product_id" : @(product_id),
                 @"requester" : @([Session current].ID)
                 };
    return [NetworkingHelper requestFromAPI:API_UPDATE_ITEM_FROM_SHOP_CART method:@"POST" params:param postData:nil completion:^(MKNetworkOperation *completedOperation) {
        id response = completedOperation.responseJSON;
        if(response[@"isProcessSuccess"]){
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
