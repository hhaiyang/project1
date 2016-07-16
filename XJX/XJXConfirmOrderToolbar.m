//
//  XJXConfirmOrderToolbar.m
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXConfirmOrderToolbar.h"

@interface XJXConfirmOrderToolbar()

@property (nonatomic,strong) UIButton *btnOrder;
@property (nonatomic,strong) UILabel *totalLb;
@property (nonatomic,strong) UILabel *totalPriceLb;

@end

@implementation XJXConfirmOrderToolbar
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self enableBluredEffect];
    
    _btnOrder = [UIControlsUtils buttonWithTitle:@"提交订单" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(order:) padding:UIEdgeInsetsMake(8, 25, 8, 25) frame:CGRectZero];
    [_btnOrder setX:[self getW] - [_btnOrder getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_btnOrder verticalCenteredOnView:self];
    
    [_btnOrder setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    _btnOrder.layer.cornerRadius = 0.5 * [_btnOrder getH];
    
    _totalLb = [UIControlsUtils labelWithTitle:@"合计: " color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].subTitleFont];
    [_totalLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_totalLb verticalCenteredOnView:self];
    
    _totalPriceLb = [UIControlsUtils labelWithTitle:[NSString stringWithFormat:@"￥%.2lf",999.0] color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].titleFont];
    [_totalPriceLb setX:[_totalLb getMaxX] + 5];
    [_totalPriceLb verticalCenteredOnView:self];
    
    [self addSubview:_btnOrder];
    [self addSubview:_totalLb];
    [self addSubview:_totalPriceLb];
}

- (void)order:(id)sender{
    _btnOrder.enabled = NO;
    if(self.onOrderHandler){
        self.onOrderHandler();
    }
}

- (void)setTotalPrice:(CGFloat)totalPrice{
    _totalPrice = totalPrice;
    _totalPriceLb.text = [NSString stringWithFormat:@"￥%.2lf",totalPrice];
    [_totalPriceLb recalculateSize];
}

@end
