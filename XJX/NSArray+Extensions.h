//
//  NSArray+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *(^arrayEnumulator)(id item);

@interface NSArray (Extensions)

- (NSString *)stringByJoinProperty:(arrayEnumulator)enumulator delimiter:(NSString *)delimiter;

- (NSArray *)itemsWithPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

@end
