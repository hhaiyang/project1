//
//  XJXTagGroup.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTagGroup.h"

@implementation XJXTagGroup

- (instancetype)init{
    if(self = [super init]){
        _tags = [NSMutableArray array];
    }
    return self;
}

- (void)addTag:(XJXTag *)tag{
    [tag setTouchedHandler:^(XJXTag *tag){
        [self selectTag:tag];
    }];
    [_tags addObject:tag];
}

- (void)selectTag:(XJXTag *)tag{
    [_tags enumerateObjectsUsingBlock:^(XJXTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.title isEqualToString:tag.title]){
            obj.selected = YES;
        }
        else{
            obj.selected = NO;
        }
    }];
}

@end
