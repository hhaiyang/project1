//
//  XJXReservationDashboardButtonCell.m
//  XJX
//
//  Created by Cai8 on 16/2/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#define WHITE_SPACING 10

#import "XJXReservationDashboardButtonCell.h"

@interface XJXReservationDashboardButtonCell()

@property (nonatomic,strong) UIView *container;

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subtitleLb;

@property (nonatomic,strong) UIButton *button;

@end

@implementation XJXReservationDashboardButtonCell

- (void)layout{
    [_container setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_container setY:0];
    [_container setW:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2];
    [_container setH:[self.contentView getH] - WHITE_SPACING];
    
    [_iconView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_iconView verticalCenteredOnView:self.container];
    
    [_titleLb recalculateSize];
    [_titleLb setX:[_iconView getMaxX] + 5];
    [_titleLb setY:[_iconView getMinY] + 5];
    
    [_subtitleLb recalculateSize];
    [_subtitleLb setX:[_iconView getMaxX] + 5];
    [_subtitleLb setY:[_titleLb getMaxY] + 5];
    
    [_button verticalCenteredOnView:self.container];
    [_button setX:[self.container getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_button getW]];
}

- (void)initUI{
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    self.container.backgroundColor = WhiteColor(1, 1);
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 60, 60)];
    self.iconView.layer.cornerRadius = 0.5 * [_iconView getH];
    self.iconView.layer.masksToBounds = YES;
    
    self.titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].subTitleFont];
    NSAttributedString *emtyStr = [[NSAttributedString alloc] initWithString:@""];
    self.subtitleLb = [UIControlsUtils labelWithAttributeTitle:emtyStr textAlignment:NSTextAlignmentCenter];
    
    self.button = [UIControlsUtils buttonWithTitle:@"激活" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(buttonclick:) padding:UIEdgeInsetsMake(10, 25, 10, 25) frame:CGRectZero];
    [self.button setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    self.button.layer.cornerRadius = 0.5 * [self.button getH];
    
    [self.container addSubview:_iconView];
    [self.container addSubview:_titleLb];
    [self.container addSubview:_subtitleLb];
    [self.container addSubview:_button];
    [self.contentView addSubview:self.container];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    self.iconView.image = icon;
}

- (void)buttonclick:(id)sendr{
    if(self.buttonClickHandler){
        self.buttonClickHandler(self);
    }
}

- (void)setNumber:(int)number{
    _number = number;
    [self updateProgressingWithNumber:_number];
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    [self updateProgressingWithNumber:_number];
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled{
    [_button setEnabled:enabled];
    if(enabled){
        [_button setBackgroundColor:[Theme defaultTheme].highlightTextColor];
    }
    else{
        [_button setBackgroundColor:[Theme defaultTheme].lightColor];
    }
}

- (void)updateProgressingWithNumber:(int)number{
    id numberAttribute = @{
                           NSFontAttributeName : [Theme defaultTheme].h1Font,
                           NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor
                           };
    NSString *str = [NSString stringWithFormat:@"%d%@",number,self.unit];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:numberAttribute];
    [attributeStr addAttribute:NSFontAttributeName value:[Theme defaultTheme].subTitleFont range:[str rangeOfString:[NSString stringWithFormat:@"%@",self.unit]]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[Theme defaultTheme].lightColor range:[str rangeOfString:[NSString stringWithFormat:@"%@",self.unit]]];
    self.subtitleLb.attributedText = attributeStr;
    [self layout];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
    [self layout];
}

@end
