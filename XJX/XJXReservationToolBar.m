//
//  XJXReservationToolBar.m
//  XJX
//
//  Created by Cai8 on 16/2/2.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationToolBar.h"

@interface XJXReservationToolBar()

@property (nonatomic,strong) UIButton *btnPublish;

@end

@implementation XJXReservationToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = WhiteColor(1, 1);
    
    UIView *border_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    border_top.backgroundColor = [Theme defaultTheme].lightColor;
    
    _btnPublish = [UIControlsUtils buttonWithTitle:@"发布喜讯" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(publish) padding:UIEdgeInsetsZero frame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI,5,[self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI,[self getH] - 2 * 5)];
    
    [_btnPublish setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    [_btnPublish verticalCenteredOnView:self];
    [_btnPublish horizontalCenteredOnView:self];
    
    _btnPublish.layer.cornerRadius = 0.5 * [_btnPublish getH];
    
    [self addSubview:_btnPublish];
}

- (void)publish{
    if(self.publishHandler){
        self.publishHandler();
    }
}

@end
