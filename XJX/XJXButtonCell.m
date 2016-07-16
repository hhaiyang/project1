//
//  XJXButtonCell.m
//  XJX
//
//  Created by Cai8 on 16/2/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXButtonCell.h"

@interface XJXButtonCell()

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *iconView;

@end

@implementation XJXButtonCell

- (void)layout{
    [_iconView setH:[self.contentView getH] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    [_iconView setW:[_iconView getH]];
    
    [_titleLb recalculateSize];
    
    [_iconView setX:([self.contentView getW] - ([_iconView getW] + [_titleLb getW] + 10)) / 2.0];
    
    [_titleLb setX:[_iconView getMaxX] + 10];
    
    [_iconView verticalCenteredOnView:self];
    [_titleLb verticalCenteredOnView:self];
}

- (void)initUI{
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLb];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
    [self layout];
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    self.iconView.image = icon;
    [self layout];
}

@end
