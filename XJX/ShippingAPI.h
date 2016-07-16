//
//  ShippingAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingAPI : NSObject

+ (MKNetworkOperation *)requestShippingInfosOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)addShipping:(NSDictionary *)shippingInfo completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)setShippingDefaultWithId:(NSUInteger)shipping_id completion:(onAPIRequestDone)handler;

+ (void)requestShippingInfoWithShippingNo:(NSString *)no completion:(onAPIRequestDone)handler;

@end
