//
//  XJXLinkageRouter.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXLinkageRouter.h"
#import "XJXURL.h"

@interface XJXLinkageRouter()

@property (nonatomic,strong) NSMutableArray *routes;
@property (nonatomic,copy) onDefaultRouteMatchedHandler defaultRouteMatchedHandler;

@end

@implementation XJXLinkageRouter

+ (instancetype)defaultRouter{
    static XJXLinkageRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[XJXLinkageRouter alloc] init];
    });
    return router;
}

- (instancetype)init{
    if(self = [super init]){
        _routes = [NSMutableArray array];
    }
    return self;
}

- (void)onDefaultRouteMatched:(onDefaultRouteMatchedHandler)handler{
    _defaultRouteMatchedHandler = handler;
}

- (void)registerRoute:(NSString *)name pattern:(NSString *)pattern onMatched:(onRouteMatchedHandler)handler{
    XJXLinkageRouteRule *rule = [[XJXLinkageRouteRule alloc] init];
    rule.routePageName = name;
    rule.routeLinkagePattern = pattern;
    rule.onMatched = handler;
    [self registerRouteRule:rule];
}

- (void)registerRouteRule:(XJXLinkageRouteRule *)rule{
    NSUInteger index = [_routes indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [[obj routePageName] isEqualToString:rule.routePageName];
    }];
    if(index == NSNotFound){
        [_routes addObject:rule];
    }
    else{
        @throw [NSException exceptionWithName:@"Dumplicated Route Name" reason:@"路由名称冲突" userInfo:nil];
    }
}

- (void)routeToLink:(NSString *)link{
    @try {
        XJXURL *xjxurl = [XJXURL urlWithString:link];
        NSUInteger index = [_routes indexOfObjectPassingTest:^BOOL(XJXLinkageRouteRule *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XJXURL *url = [XJXURL urlWithString:obj.routeLinkagePattern];
            if([url.scheme isEqualToString:xjxurl.scheme] && [url.host isEqualToString:xjxurl.host]){
                return YES;
            }
            return NO;
        }];
        if(index != NSNotFound){
            XJXLinkageRouteRule *rule = _routes[index];
            rule.onMatched(rule.routePageName,xjxurl.urlParams);
        }
        else{
            if(_defaultRouteMatchedHandler){
                _defaultRouteMatchedHandler(xjxurl);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog([exception description]);
    }
}

- (BaseController *)activityController{
    if(!_activityController){
        return [Utils getCurrentVC];
    }
    else{
        return _activityController;
    }
}

@end
