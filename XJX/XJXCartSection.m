//
//  XJXCartSection.m
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCartSection.h"

@implementation XJXCartSection

- (instancetype)init{
    if(self = [super init]){
        self.items = [NSMutableArray array];
        self.itemSelections = [NSMutableArray array];
    }
    return self;
}

@end
