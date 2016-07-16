//
//  XJXLinkageRouteRule.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onRouteMatchedHandler)(NSString *routePageName,NSDictionary *state);

@interface XJXLinkageRouteRule : NSObject

@property (nonatomic,copy) NSString *routePageName;
@property (nonatomic,copy) NSString *routeLinkagePattern;
@property (nonatomic,copy) onRouteMatchedHandler onMatched;

@end
