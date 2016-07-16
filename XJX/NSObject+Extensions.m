//
//  NSObject+Extensions.m
//  Deal
//
//  Created by Barton on 14-6-9.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import "NSObject+Extensions.h"
#import <objc/runtime.h>

@implementation NSObject (Extensions)

- (id)getJsonObj{
    id container;
    if([self isKindOfClass:[NSArray class]]){
        container = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [container addObject:[obj getJsonObj]];
        }];
    }
    else if([self isKindOfClass:[NSDictionary class]]){
        container = [NSMutableDictionary dictionary];
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [container setObject:[obj getJsonObj] forKey:key];
        }];
    }
    else if([self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSValue class]] || [self isKindOfClass:[NSString class]]){
        container = self;
    }
    else{
        container = [self getDictionary];
    }
    return container;
}

- (NSDictionary *)getDictionary
{
    //创建可变字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if([self isKindOfClass:[NSDictionary class]]){
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [dict setObject:[obj getJsonObj] forKey:key];
        }];
    }
    else{
        unsigned int outCount;
        objc_property_t *props = class_copyPropertyList([self class], &outCount);
        for(int i=0;i<outCount;i++){
            objc_property_t prop = props[i];
            NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
            id propValue = [self valueForKey:propName];
            if(propValue){
                if([propValue isKindOfClass:[NSNumber class]] || [propValue isKindOfClass:[NSValue class]] || [propValue isKindOfClass:[NSString class]])
                    [dict setObject:propValue forKey:propName];
                else if([propValue isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *array = [NSMutableArray array];
                    [propValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [array addObject:[obj getDictionary]];
                    }];
                    [dict setObject:array forKey:propName];
                }
                else if([propValue isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
                        [dic setObject:[obj getDictionary] forKey:key];
                    }];
                    [dict setObject:dic forKey:propName];
                }
                else
                {
                    [dict setObject:[propValue getDictionary] forKey:propName];
                }
            }
            else
            {
                [dict setObject:[NSNull null] forKey:propName];
            }
        }
        free(props);
    }
    return dict;
}

- (NSString *)toJson
{
    NSString *jsonString = nil;
    id jsonObj = [self getJsonObj];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:nil];
    jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
