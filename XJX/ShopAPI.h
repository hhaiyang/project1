//
//  ShopAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/9.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAPI : NSObject

+ (MKNetworkOperation *)requestPopularProductsWithPage:(NSUInteger)page length:(NSUInteger)length completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestCategoriesWithCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestArticlesWithCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestShopDetailWithCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestProductWithId:(NSString *)productId completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestProductInShoppingCartOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)addItemToCartWithProductId:(NSUInteger)product_id amount:(int)amount model:(NSString *)model completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)deleteItemFromCartWithCartItemId:(NSUInteger)cartitem_id completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)updateCartItemWithAmount:(int)amount model:(NSArray *)model cart_id:(NSUInteger)cart_id product_id:(NSUInteger)product_id completion:(onAPIRequestDone)handler;

@end
