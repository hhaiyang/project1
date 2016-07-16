//
//  OAuthAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthAPI : NSObject

+ (MKNetworkOperation *)authWithCode:(NSString *)code state:(NSString *)state completion:(onAPIRequestDone)handler;

@end
