//
//  XJXCartSwiperView.m
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCartSwiperView.h"

@implementation XJXCartSwiperView
{
    NSMutableArray *views;
}

- (instancetype)init{
    if(self = [super init]){
        views = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews{
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setH:[self getH]];
        [Utils printFrame:[obj frame]];
    }];
}

- (void)addButtonWithTitle:(NSString *)title background:(UIColor *)background bg:(UIImage *)bg padding:(UIEdgeInsets)padding{
    UIButton *btn = [UIControlsUtils buttonWithTitle:title background:background backroundImage:bg target:self selector:@selector(buttonAction:) padding:padding frame:CGRectZero];
    [btn setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    [btn setY:0];
    [btn setX:[self getWidth]];
    [self addSubview:btn];
    [views addObject:btn];
    
    [self setW:[self getWidth]];
}

- (CGFloat)getWidth{
    __block CGFloat width = 0.0;
    [views enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        width += [obj getW];
    }];
    return width;
}

- (void)buttonAction:(id)sender{
    NSUInteger index = [views indexOfObject:sender];
    if(_buttonClicked){
        _buttonClicked(_sender,index);
    }
}

@end
