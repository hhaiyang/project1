//
//  ReservationAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservationAPI : NSObject

+ (MKNetworkOperation *)requestWeddingInfoWithCompletion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)updateWeddingGalleryWithPhotoId:(NSUInteger)photo_id onWeddingWithId:(NSUInteger)wedding_id atOrder:(int)order completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)updateWeddingInfo:(id)wedding completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)requestDashboardData:(NSUInteger)wedding_id completion:(onAPIRequestDone)handler;

+ (MKNetworkOperation *)enableRedpackOnWedding:(NSUInteger)wedding_id completion:(onAPIRequestDone)handler;

@end
