//
//  PayAPI.h
//  XJX
//
//  Created by Cai8 on 16/2/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayAPI : NSObject

+ (MKNetworkOperation *)GetWXSignWithWord:(NSString *)word trade_no:(NSString *)trade_no behavior:(NSString *)behavior money:(int)money completion:(onAPIRequestDone)handler;

@end
