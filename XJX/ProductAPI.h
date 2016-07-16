//
//  ProductAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductAPI : NSObject

+ (MKNetworkOperation *)requestProductsInCategory:(NSInteger)categoryId page:(int)page pageSize:(int)pageSize completion:(onAPIRequestDone)handler;

@end
