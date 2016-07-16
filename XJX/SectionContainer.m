//
//  SectionContainer.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "SectionContainer.h"
#define VIEW_MARGIN 2

@interface SectionContainer()

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subTitleLb;

@end

@implementation SectionContainer
{
    UIView *renderView;
}

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    renderView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, [self getWidth], [self getHeight])];
    renderView.backgroundColor = _backgroundColor;
    
    _titleLb = [UIControlsUtils labelWithTitle:_title color:_titleColor font:_titleFont];
    [_titleLb setX:(SCREEN_WIDTH - _titleLb.bounds.size.width) / 2];
    [_titleLb setY:self.padding.top];
    
    _subTitleLb = [UIControlsUtils labelWithTitle:_subTitle color:_subTitleColor font:_subTitleFont];
    [_subTitleLb setX:(SCREEN_WIDTH - _subTitleLb.bounds.size.width) / 2];
    [_subTitleLb setY:[_titleLb getMaxY] + VIEW_MARGIN];
    
    [_contentView setY:[_subTitleLb getMaxY] + VIEW_MARGIN];
    
    [renderView addSubview:_titleLb];
    [renderView addSubview:_subTitleLb];
    [renderView addSubview:_contentView];
    
    [view addSubview:renderView];
}

- (void)refreshContentView:(UIView *)contentView{
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    _contentView = contentView;
    [_contentView setY:[_subTitleLb getMaxY]];
    [renderView setH:[self getHeight]];
    [renderView addSubview:_contentView];
}

- (CGFloat)getWidth{
    return SCREEN_WIDTH;
}

- (CGFloat)getHeight{
    return self.padding.top + [_title sizeWithFont:_titleFont].height + VIEW_MARGIN +
           [_subTitle sizeWithFont:_subTitleFont].height + VIEW_MARGIN +
            _contentView.bounds.size.height + self.padding.bottom;
}

@end
