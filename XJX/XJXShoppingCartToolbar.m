//
//  XJXShoppingCartToolbar.m
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShoppingCartToolbar.h"

@interface XJXShoppingCartToolbar()

@property (nonatomic,strong) UIButton *btnOrder;
@property (nonatomic,strong) UILabel *totalLb;
@property (nonatomic,strong) UILabel *totalPriceLb;

@end

@implementation XJXShoppingCartToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    __weak XJXShoppingCartToolbar *_self = self;
    [self enableBluredEffect];
    
    _btnOrder = [UIControlsUtils buttonWithTitle:@"结算" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(order:) padding:UIEdgeInsetsMake(8, 25, 8, 25) frame:CGRectZero];
    [_btnOrder setX:[self getW] - [_btnOrder getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_btnOrder verticalCenteredOnView:self];
    
    [_btnOrder setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    _btnOrder.layer.cornerRadius = 0.5 * [_btnOrder getH];
    
    _editor = [[CheckEditor alloc] init];
    [_editor setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_editor verticalCenteredOnView:self];
    [_editor setSender:self];
    [_editor setStatusChangedHandler:^(CheckEditor *editor,id sender){
        if(_self.onSelectAllHandler){
            _self.onSelectAllHandler(editor.checked);
        }
    }];
    
    UILabel *allSelectLb = [UIControlsUtils labelWithTitle:@"全选" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].normalTextFont];
    [allSelectLb setX:[_editor getMaxX] + 5];
    [allSelectLb verticalCenteredOnView:self];
    
    _totalLb = [UIControlsUtils labelWithTitle:@"合计: " color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].subTitleFont];
    [_totalLb setX:[allSelectLb getMaxX] + 60];
    [_totalLb verticalCenteredOnView:self];
    
    _totalPriceLb = [UIControlsUtils labelWithTitle:[NSString stringWithFormat:@"%.2lf",999.0] color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].titleFont];
    [_totalPriceLb setX:[_totalLb getMaxX] + 5];
    [_totalPriceLb verticalCenteredOnView:self];
    
    [self addSubview:_btnOrder];
    [self addSubview:_editor];
    [self addSubview:allSelectLb];
    [self addSubview:_totalLb];
    [self addSubview:_totalPriceLb];
}

- (void)order:(id)sender{
    if(self.onOrderHandler){
        self.onOrderHandler();
    }
}

- (void)setTotalPrice:(CGFloat)totalPrice{
    _totalPrice = totalPrice;
    _totalPriceLb.text = [NSString stringWithFormat:@"%.2lf",totalPrice];
    [_totalPriceLb recalculateSize];
}

- (void)reset{
    [self.editor setNoHandlerChecked:NO];
    self.totalPrice = 0;
}

@end
