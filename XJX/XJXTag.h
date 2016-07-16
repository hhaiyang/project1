//
//  XJXTag.h
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJXTag;

typedef void (^onTagTouched)(XJXTag *tag);

@interface XJXTag : XJXLayoutNode

@property (nonatomic,copy) onTagTouched touchedHandler;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL selected;

- (CGSize)sizeForTag;

@end
