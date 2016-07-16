//
//  XJXToolbar.m
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCrowdFundingToolbar.h"
#import "IconButton.h"

#define TITLE_PADDING_HORI 10
#define TITLE_PADDING_VETI 5

#define BUTTON_MARGIN 10

#define SEPERATOR_HEIGHT 15

@implementation XJXCrowdFundingToolbar
{
    IconButton *favButton;
    IconButton *crowdfundingButton;
    IconButton *buyButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    [self initUI];
}

- (void)initUI{
    __weak XJXCrowdFundingToolbar *_self = self;
    
    UIView *border_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    border_top.backgroundColor = [Theme defaultTheme].lightColor;
    
    CGFloat x_offset = self.bounds.size.width - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI;
    favButton = [[IconButton alloc] init];
    [favButton setTitle:@"收藏" forState:kIconButtonStatusInActive];
    [favButton setTitleColor:[Theme defaultTheme].schemeColor forState:kIconButtonStatusInActive];
    [favButton setTitleColor:[Theme defaultTheme].schemeColor forState:KIconButtonStatusActive
     ];
    [favButton setFont:[Theme defaultTheme].normalTextFont];
    
    [favButton setIcon:[UIImage imageNamed:@"collect"] forState:kIconButtonStatusInActive];
    [favButton setIcon:[UIImage imageNamed:@"collect-selected"] forState:KIconButtonStatusActive];
    [favButton setOnClickHandler:^(IconButton *button){
        [button toggle];
    }];
    [favButton verticalCenteredOnView:self];
    
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(x_offset, 0, 1, SEPERATOR_HEIGHT)];
    seperator.backgroundColor = [Theme defaultTheme].lightColor;
    [seperator verticalCenteredOnView:self];
    
    crowdfundingButton = [[IconButton alloc] init];
    [crowdfundingButton setFont:[Theme defaultTheme].normalTextFont];
    [crowdfundingButton setTitlePadding:UIEdgeInsetsMake(TITLE_PADDING_VETI, TITLE_PADDING_HORI, TITLE_PADDING_VETI, TITLE_PADDING_HORI)];
    [crowdfundingButton setTitle:@"众筹" forState:kIconButtonStatusInActive];
    [crowdfundingButton setTitleColor:[Theme defaultTheme].highlightTextColor forState:kIconButtonStatusInActive];
    [crowdfundingButton.layer setBorderWidth:1];
    [crowdfundingButton.layer setBorderColor:[Theme defaultTheme].highlightTextColor.CGColor];
    [crowdfundingButton setOnClickHandler:^(IconButton *button){
        if(_self.onAppendWishlistHandler){
            _self.onAppendWishlistHandler();
        }
    }];
    [crowdfundingButton verticalCenteredOnView:self];
    
    buyButton = [[IconButton alloc] init];
    [buyButton setFont:[Theme defaultTheme].normalTextFont];
    [buyButton setTitlePadding:UIEdgeInsetsMake(TITLE_PADDING_VETI, TITLE_PADDING_HORI, TITLE_PADDING_VETI, TITLE_PADDING_HORI)];
    [buyButton setTitle:@"加入购物车" forState:kIconButtonStatusInActive];
    [buyButton setTitleColor:WhiteColor(1, 1) forState:kIconButtonStatusInActive];
    [buyButton setBackgroundColor:[Theme defaultTheme].highlightTextColor];
    [buyButton setOnClickHandler:^(IconButton *button){
        if(_self.onBuyHandler){
            _self.onBuyHandler();
        }
    }];
    [buyButton verticalCenteredOnView:self];
    [Utils printFrame:buyButton.frame];
    
    CGFloat deltaWidth = (buyButton.bounds.size.width - crowdfundingButton.bounds.size.width) / 2.0;
    crowdfundingButton.contentPadding = UIEdgeInsetsMake(0, deltaWidth, 0, deltaWidth);
    [crowdfundingButton relayout];
    
    x_offset -= buyButton.bounds.size.width;
    [buyButton setX:x_offset];
    
    x_offset -= BUTTON_MARGIN + crowdfundingButton.bounds.size.width;
    [crowdfundingButton setX:x_offset];
    
//    x_offset -= BUTTON_MARGIN + seperator.bounds.size.width;
//    [seperator setX:x_offset];
//    
//    x_offset -= BUTTON_MARGIN + favButton.bounds.size.width;
//    [favButton setX:x_offset];
    
    buyButton.layer.cornerRadius = crowdfundingButton.layer.cornerRadius = 0.5 * buyButton.bounds.size.height;
    self.backgroundColor = WhiteColor(1, 1);
    
    [self addSubview:border_top];
    //[self addSubview:favButton];
    //[self addSubview:seperator];
    [self addSubview:crowdfundingButton];
    [self addSubview:buyButton];
}

@end
