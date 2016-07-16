//
//  XJXMoneyWithdrawSlide.m
//  XJX
//
//  Created by Cai8 on 16/3/1.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMoneyWithdrawSlide.h"

#define LINE_MARGIN 10

@interface XJXMoneyWithdrawSlide()

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *moneyLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *statusLb;

@end

@implementation XJXMoneyWithdrawSlide

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    [_titleLb recalculateSize];
    [_moneyLb recalculateSize];
    [_timeLb recalculateSize];
    [_statusLb recalculateSize];
    
    CGFloat height = [_titleLb getH] + LINE_MARGIN + [_timeLb getH];
    
    CGFloat y_offset = ([self getH] - height) / 2.0;
    
    [_titleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_titleLb setY:y_offset];
    
    [_moneyLb setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_moneyLb getW]];
    [_moneyLb setY:[_titleLb getMaxY] - [_moneyLb getH]];
    
    [_timeLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_timeLb setY:[_titleLb getMaxY] + LINE_MARGIN];
    
    [_statusLb setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_statusLb getW]];
    [_statusLb setY:[_moneyLb getMaxY] + LINE_MARGIN];
}

- (void)initUI{
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].subTitleFont];
    _moneyLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].subTitleFont];
    
    _timeLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont];
    
    _statusLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont];
    
    [self addSubview:_timeLb];
    [self addSubview:_titleLb];
    [self addSubview:_moneyLb];
    [self addSubview:_statusLb];
}

- (void)setPrice:(float)price{
    _price = price;
    _moneyLb.attributedText = [[NSString stringWithFormat:@"%.2lf",price] priceFormatAttributeWithFont:_moneyLb.font symbolFont:[Theme defaultTheme].emFont color:[Theme defaultTheme].highlightTextColor];
    [self layout];
}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLb.text = [NSString stringWithFormat:@"申请时间: %@",time];
    [self layout];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = title;
    [self layout];
}

- (void)setStatus:(NSString *)status{
    _status = status;
    _statusLb.text = status;
    [self layout];
}

@end
