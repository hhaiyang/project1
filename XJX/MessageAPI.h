//
//  MessageAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageAPI : NSObject

+ (MKNetworkOperation *)requestMessagesOnCompletion:(onAPIRequestDone)handler;

@end
