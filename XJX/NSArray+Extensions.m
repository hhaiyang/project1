//
//  NSArray+Extensions.m
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (NSString *)stringByJoinProperty:(arrayEnumulator)enumulator delimiter:(NSString *)delimiter{
    NSMutableString *str = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx != self.count - 1){
            [str appendString:[NSString stringWithFormat:@"%@%@",enumulator(obj),delimiter]];
        }
        else{
            [str appendString:[NSString stringWithFormat:@"%@",enumulator(obj)]];
        }
    }];
    return str;
}

- (NSArray *)itemsWithPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate{
    NSIndexSet *sets = [self indexesOfObjectsPassingTest:predicate];
    return [self objectsAtIndexes:sets];
}

@end
