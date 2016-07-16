//
//  CommonAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAPI : NSObject

+ (MKNetworkOperation *)requestCitiesWithCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)matchingBrandWithForm:(id)form completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)bindPhone:(NSString *)phone completion:(onAPIRequestDone)completion;

@end
