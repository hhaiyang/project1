//
//  XJXFormFieldCell.m
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXFormFieldCell.h"

@interface XJXFormFieldCell()

@property (nonatomic,strong) UILabel *labelTitle;

@end

@implementation XJXFormFieldCell

- (void)layout{
    [super layout];
    [_labelTitle setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_labelTitle setW:LEFT_SPACING - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_labelTitle setY:0];
    [_labelTitle setH:[self getH]];
    
    if(_titleColor){
        _labelTitle.textColor = _titleColor;
    }
}

- (void)initUI{
    [super initUI];
    _labelTitle = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentLeft];
    _labelTitle.numberOfLines = 1;
    [self addSubview:_labelTitle];
}

- (void)setField_title:(NSString *)field_title{
    _field_title = field_title;
    _labelTitle.text = _field_title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _labelTitle.textColor = _titleColor;
}

@end
