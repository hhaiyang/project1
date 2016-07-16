//
//  IconButton.m
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "IconButton.h"

@implementation IconButton{
    UIImageView *iconView;
    UILabel *titleLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if(self = [super init]){
        [self initParams];
    }
    return self;
}

- (void)initParams{
    _status = kIconButtonStatusInActive;
    _title = @"";
    
    _settings = [@{
                  @"activeColor" : [UIColor blackColor],
                  @"color" : [UIColor blackColor],
                  @"activeIcon" : [UIImage new],
                  @"icon" : [UIImage new],
                  @"activeTitle" : @"",
                  @"title" : @""
                  } mutableCopy];
    _font = [Theme defaultTheme].titleFont;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tap];
}

- (void)relayout{
    [self setH:MAX(titleLb ? titleLb.bounds.size.height + _titlePadding.top + _titlePadding.bottom : 0, iconView ? iconView.bounds.size.height + _imagePadding.top + _imagePadding.bottom : 0) + _contentPadding.top + _contentPadding.bottom];
    
    CGFloat x_offset = _contentPadding.left;
    if(iconView){
        [iconView setY:(self.bounds.size.height - iconView.bounds.size.height) / 2.0];
        [iconView setX:self.contentPadding.left + self.imagePadding.left];
        x_offset += iconView.bounds.size.width + _imagePadding.left + _imagePadding.right;
    }
    if(titleLb){
        x_offset += _titlePadding.left;
        
        //Recalculate size
        CGSize size = [titleLb.text sizeWithFont:_font];
        titleLb.font = _font;
        titleLb.textColor = _currentStatus == kIconButtonStatusInActive ? _settings[@"color"] : _settings[@"activeColor"];
        [titleLb setW:size.width + _titlePadding.left + _titlePadding.right];
        [titleLb setH:size.height + _titlePadding.top + _titlePadding.bottom];
        [titleLb setX:x_offset];
        [titleLb verticalCenteredOnView:self];
    }
    
    [self setW:[titleLb getMaxX] + _titlePadding.right + _contentPadding.right];
}

- (void)setTitle:(NSString *)title forState:(IconButtonStatus)status{
    if(status == kIconButtonStatusInActive){
        [_settings setObject:title forKey:@"title"];
    }
    else if(status == KIconButtonStatusActive){
        [_settings setObject:title forKey:@"activeTitle"];
    }
    if(!titleLb){
        titleLb = [UIControlsUtils labelWithTitle:title color:status == KIconButtonStatusActive ? _settings[@"activeColor"] : _settings[@"color"] font:_font];
        [self addSubview:titleLb];
    }
    [self relayout];
}

- (void)setIcon:(UIImage *)icon forState:(IconButtonStatus)status{
    if(status == kIconButtonStatusInActive){
        [_settings setObject:icon forKey:@"icon"];
    }
    else if(status == KIconButtonStatusActive){
        [_settings setObject:icon forKey:@"activeIcon"];
    }
    
    if(!iconView){
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MIN(44,icon.size.width), MIN(44,icon.size.height))];
        iconView.image = icon;
        [self addSubview:iconView];
    }
    
    [self relayout];
}

- (void)setTitleColor:(UIColor *)titleColor forState:(IconButtonStatus)status{
    if(status == kIconButtonStatusInActive){
        [_settings setObject:titleColor forKey:@"color"];
    }
    else if(status == KIconButtonStatusActive){
        [_settings setObject:titleColor forKey:@"activeColor"];
    }
    [self relayout];
}

- (void)toggle{
    _status = (_status == kIconButtonStatusInActive) ? KIconButtonStatusActive : kIconButtonStatusInActive;
    [self relayout];
}

- (void)click:(UIGestureRecognizer *)gesture{
    if(_onClickHandler){
        _onClickHandler(self);
    }
}

@end
