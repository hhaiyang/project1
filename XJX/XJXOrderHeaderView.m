//
//  XJXOrderHeaderView.m
//  XJX
//
//  Created by Cai8 on 16/2/9.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXOrderHeaderView.h"

@interface XJXOrderHeaderView()

@property (nonatomic,strong) UILabel *orderStatusLb;
@property (nonatomic,strong) UILabel *shippingStatusLb;

@property (nonatomic,strong) UIView *seperator;

@end

@implementation XJXOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    [_orderStatusLb recalculateSize];
    [_shippingStatusLb recalculateSize];
    
    [_orderStatusLb horizontalCenteredOnView:self];
    [_orderStatusLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    [_shippingStatusLb horizontalCenteredOnView:self];
    [_shippingStatusLb setY:[_orderStatusLb getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    [_seperator setY:[self getH] - 1];
    [_seperator setX:0];
    [_seperator setW:[self getW]];
    [_seperator setH:1];
}

- (void)initUI{
    _orderStatusLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentCenter];
    _shippingStatusLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentCenter];
    
    _seperator = [[UIView alloc] initWithFrame:CGRectZero];
    _seperator.backgroundColor = WhiteColor(0, .08);
    
    [self addSubview:_orderStatusLb];
    [self addSubview:_shippingStatusLb];
    [self addSubview:_seperator];

    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bgView.backgroundColor = WhiteColor(1, 1);
    self.backgroundView = bgView;
}

- (void)setOrder_status:(NSAttributedString *)order_status{
    _order_status = order_status;
    self.orderStatusLb.attributedText = _order_status;
    [self layout];
}

- (void)setShipping_status:(NSString *)shipping_status{
    _shipping_status = shipping_status;
    self.shippingStatusLb.text = _shipping_status;
    [self layout];
}

@end
