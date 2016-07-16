//
//  OrderAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderAPI : NSObject

+ (MKNetworkOperation *)requestOrderingInfoOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)addOrder:(id)order completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestMyOrdersWithStatus:(NSString *)status page:(int)page pageSize:(int)pageSize completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)cancelOrderWithSerial:(NSString *)serial completion:(onAPIRequestDone)handler;

@end
