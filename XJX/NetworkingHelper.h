//
//  NetworkingHelper.h
//  Deal
//
//  Created by Barton on 14-6-8.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"  
#import "NetworkingDataModel.h"

@interface NetworkingHelper : NSObject

+ (MKNetworkEngine *)defaultEngine;

+ (MKNetworkOperation *)requestFromAPI:(NSString *)apiPath method:(NSString *)method params:(NSDictionary *)param postData:(NSArray *)data completion:(MKNKResponseBlock)completion progress:(MKNKProgressBlock)progressHandler error:(MKNKResponseErrorBlock)error;

@end
