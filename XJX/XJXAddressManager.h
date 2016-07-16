//
//  XJXAddressManager.h
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXAddressManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)getProvince;

- (NSArray *)getCitiesInProvince:(NSString *)province;

- (NSArray *)getRegionsInCity:(NSString *)city province:(NSString *)province;

@end
