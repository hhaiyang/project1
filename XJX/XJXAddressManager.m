//
//  XJXAddressManager.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXAddressManager.h"

@implementation XJXAddressManager{
    NSMutableDictionary *cache;
}

+ (instancetype)sharedManager{
    static XJXAddressManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XJXAddressManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if(self = [super init]){
        cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary *)loadAeraJs{
    return [[NSString readFromFile:@"areas" type:@"json"] fromJson];
}

NSInteger pinyinSort(NSString *str1,NSString *str2,void *context){
    return  [str1 localizedCompare:str2];
}

- (NSArray *)getProvince{
    NSMutableArray *array = cache[@"provinces"];
    if(!array){
        array = [NSMutableArray array];
        [[self loadAeraJs] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [array addObject:key];
        }];
        array = [[array sortedArrayUsingFunction:pinyinSort context:NULL] mutableCopy];
        [cache setObject:array forKey:@"provinces"];
    }
    return array;
}

- (NSArray *)getCitiesInProvince:(NSString *)province{
    NSMutableArray *array = cache[[NSString stringWithFormat:@"city_%@",province]];
    if(!array){
        array = [NSMutableArray array];
        id provinceObj = [self loadAeraJs][province];
        [provinceObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [array addObject:key];
        }];
        array = [[array sortedArrayUsingFunction:pinyinSort context:NULL] mutableCopy];
        [cache setObject:array forKey:[NSString stringWithFormat:@"city_%@",province]];
    }
    return array;
}

- (NSArray *)getRegionsInCity:(NSString *)city province:(NSString *)province{
    NSArray *array = cache[[NSString stringWithFormat:@"region_%@_%@",province,city]];
    if(!array){
        array = [[self loadAeraJs][province][city] sortedArrayUsingFunction:pinyinSort context:NULL];
        [cache setObject:array forKey:[NSString stringWithFormat:@"region_%@_%@",province,city]];
    }
    return array;
}

@end
