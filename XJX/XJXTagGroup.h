//
//  XJXTagGroup.h
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJXTag.h"

@interface XJXTagGroup : NSObject

@property (nonatomic,copy) NSString *group_title;
@property (nonatomic,strong) NSMutableArray *tags;

- (void)addTag:(XJXTag *)tag;
- (void)selectTag:(XJXTag *)tag;

@end
