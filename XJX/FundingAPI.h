//
//  FundingAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJXCustomWishItem;

@interface FundingAPI : NSObject

+ (MKNetworkOperation *)deleteItemFromWishlistWithWishItemId:(NSString *)wishitem_ids customIds:(NSString *)custom_ids completion:(onAPIRequestDone)handler;
+ (MKNetworkOperation *)addItemToWishlistWithProductId:(NSUInteger)product_id amount:(int)amount model:(NSString *)model completion:(onAPIRequestDone)handler;
+ (MKNetworkOperation *)requestProductInWishlistOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)addCustomItemToWishlist:(XJXCustomWishItem *)item completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)shareItems:(id)post completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestFundingItemsOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)endItemFundingWithItemId:(NSUInteger)wishitem_id itemType:(NSString *)wishitem_type completion:(onAPIRequestDone)handler;

@end
