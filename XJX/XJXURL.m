//
//  XJXURL.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXURL.h"

@implementation XJXURL

+ (XJXURL *)urlWithString:(NSString *)url{
    XJXURL *_url = [[XJXURL alloc] initWithUrl:url];
    return _url;
}

- (instancetype)initWithUrl:(NSString *)url{
    if(self = [super init]){
        _absoluteURL = url;
        _scheme = [url stringToString:@"://"];
        _host = [url stringFromString:@"://" to:@"?" or:@"/"];
        _urlParams = [NSMutableDictionary dictionary];
        [self parseUrlParams:url];
    }
    return self;
}

- (void)parseUrlParams:(NSString *)url{
    NSString *paramsStr = [url stringFromString:@"?"];
    NSArray *tmpArr = [paramsStr componentsSeparatedByString:@"&"];
    @try {
        [tmpArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_urlParams setObject:[obj stringFromString:@"="] forKey:[obj stringToString:@"="]];
        }];
    }
    @catch (NSException *exception) {
        _urlParams = [@{} mutableCopy];
    }
}

@end
