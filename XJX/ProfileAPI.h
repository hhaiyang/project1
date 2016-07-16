//
//  ProfileAPI.h
//  XJX
//
//  Created by Cai8 on 16/2/3.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileAPI : NSObject

+ (MKNetworkOperation *)requestMyMoneyWithCompletion:(onAPIRequestDone)handler;

@end
