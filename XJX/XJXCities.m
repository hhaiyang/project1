//
//  XJXCities.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCities.h"

@interface XJXCities()

@property (nonatomic,strong) NSArray *cities;

@end

@implementation XJXCities

+ (instancetype)manager{
    static XJXCities *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJXCities alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        _cities = [NSMutableArray array];
    }
    return self;
}

- (void)requestCitiesWithCompletion:(void (^)(NSArray *))handler{
    if(_cities.count == 0){
        [CommonAPI requestCitiesWithCompletion:^(id res, NSString *err) {
            if(!err){
                _cities = res;
                handler(_cities);
            }
            else{
                NSLog(err);
            }
        }];
    }
    else{
        handler(_cities);
    }
}

@end
