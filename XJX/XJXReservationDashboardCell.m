//
//  XJXReservationDashboardCell.m
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationDashboardCell.h"
#import "ProgressView.h"

#define WHITE_SPACING 10

@interface XJXReservationDashboardCell()

@property (nonatomic,strong) UIView *container;

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subtitleLb;

@property (nonatomic,strong) ProgressView *progressView;
 
@end

@implementation XJXReservationDashboardCell

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
    
    [_progressView setX:[self.container getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_progressView getW]];
    [_progressView verticalCenteredOnView:self.container];
}

- (void)initUI{
    WS(_self);
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    self.container.backgroundColor = WhiteColor(1, 1);
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 60, 60)];
    self.iconView.layer.cornerRadius = 0.5 * [_iconView getH];
    self.iconView.layer.masksToBounds = YES;
    
    self.titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].subTitleFont];
    NSAttributedString *emtyStr = [[NSAttributedString alloc] initWithString:@""];
    self.subtitleLb = [UIControlsUtils labelWithAttributeTitle:emtyStr textAlignment:NSTextAlignmentCenter];
    
    self.progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.progressView.trackColor = [Theme defaultTheme].lightColor;
    self.progressView.lineColor = [Theme defaultTheme].highlightTextColor;
    self.progressView.progressingHandler = ^(NSArray *currentValues){
        [_self updateProgressingWithNumber:[currentValues[1] intValue]];
    };
    
    [self.container addSubview:_iconView];
    [self.container addSubview:_titleLb];
    [self.container addSubview:_subtitleLb];
    [self.container addSubview:_progressView];
    
    [self.contentView addSubview:self.container];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    self.iconView.image = icon;
}

- (void)setNumber:(int)number{
    CGFloat progress = 0.0;
    if(_total != 0)
        progress = (_number * 1.0 / (_total * 1.0));
    [self.progressView setProgress:progress customParamsFrom:@[@(_number),@(_total)] customParamsTo:@[@(number),@(_total)]];
    _number = number;
}

- (void)setTotal:(int)total{
    CGFloat progress = 0.0;
    if(total != 0)
        progress = (_number * 1.0 / (total * 1.0));
    [self.progressView setProgress:progress customParamsFrom:@[@(_number),@(_total)] customParamsTo:@[@(_number),@(total)]];
    _total = total;
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
}

- (void)updateProgressingWithNumber:(int)number{
    id numberAttribute = @{
                           NSFontAttributeName : [Theme defaultTheme].h1Font,
                           NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor
                           };
    NSString *str = [NSString stringWithFormat:@"%d/%d%@",number,_total,self.unit];
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
