//
//  XJXPageControl.h
//  XJX
//
//  Created by Cai8 on 16/1/10.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXPageControl : UIView
{
    NSMutableArray *nodes;
}

@property (nonatomic,assign) UIEdgeInsets padding;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat selectedWidth;
@property (nonatomic,strong) UIColor *nodeColor;

- (instancetype)initWithPageCount:(NSUInteger)count;
- (void)setCount:(NSUInteger)count;
- (void)setCurrentIndex:(NSUInteger)index;

@end
