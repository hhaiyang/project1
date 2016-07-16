//
//  XJXTagView.h
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJXTagGroup.h"
#import "XJXTag.h"

@interface XJXTagView : UIView

+ (CGSize)sizeForTagGroups:(NSArray *)groups padding:(UIEdgeInsets)padding;

- (instancetype)initWithTagGroups:(NSArray *)groups selectedTags:(NSArray *)tags padding:(UIEdgeInsets)padding;

- (NSArray *)getSelectedTags;

@end
