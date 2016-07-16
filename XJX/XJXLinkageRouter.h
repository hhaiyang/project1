//
//  XJXLinkageRouter.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJXLinkageRouteRule.h"

@class XJXURL;

typedef void (^onDefaultRouteMatchedHandler)(XJXURL *link);

@interface XJXLinkageRouter : NSObject

+ (instancetype)defaultRouter;

- (void)registerRoute:(NSString *)name pattern:(NSString *)pattern onMatched:(onRouteMatchedHandler)handler;

- (void)registerRouteRule:(XJXLinkageRouteRule *)rule;

- (void)onDefaultRouteMatched:(onDefaultRouteMatchedHandler)handler;

- (void)routeToLink:(NSString *)link;

@property (nonatomic,weak) BaseController *activityController;

@end
