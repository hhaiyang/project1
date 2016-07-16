//
//  XJXCities.h
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXCities : NSObject

+ (instancetype)manager;

- (void)requestCitiesWithCompletion:(void (^)(NSArray *cities))handler;

@end
