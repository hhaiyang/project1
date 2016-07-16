//
//  MoneyBagAPI.h
//  XJX
//
//  Created by Cai8 on 16/2/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyBagAPI : NSObject

+ (MKNetworkOperation *)requestMyMoneyOnCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)withDrawRequestWithMoney:(CGFloat)money completion:(onAPIRequestDone)handler;

@end
