//
//  NetworkingHelper.m
//  Deal
//
//  Created by Barton on 14-6-8.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import "NetworkingHelper.h"
#import "NetworkingDataModel.h"

@implementation NetworkingHelper

+ (MKNetworkEngine *)defaultEngine
{
    static MKNetworkEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    });
    return engine;
}

+ (MKNetworkOperation *)requestFromAPI:(NSString *)apiPath method:(NSString *)method params:(NSDictionary *)param postData:(NSArray *)data completion:(MKNKResponseBlock)completion progress:(MKNKProgressBlock)progressHandler error:(MKNKResponseErrorBlock)error
{
    MKNetworkOperation *op = [[self defaultEngine] operationWithURLString:apiPath params:param httpMethod:method];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completion(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *_error) {
        error(completedOperation,_error);
    }];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NetworkingDataModel *dataModel = (NetworkingDataModel *)obj;
        if(dataModel.isFilePath)
        {
            [op addFile:dataModel.filename forKey:dataModel.name];
        }
        else
        {
            [op addData:dataModel.data forKey:dataModel.name];
        }
    }];
    [[self defaultEngine] enqueueOperation:op];
    return op;
}

@end
