//
//  PageAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/11.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageAPI : NSObject

+ (MKNetworkOperation *)requestPageFromUrl:(NSString *)url completion:(onAPIRequestDone)done;

@end
