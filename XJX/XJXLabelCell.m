//
//  XJXLabelCell.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXLabelCell.h"

@interface XJXLabelCell()

@property (nonatomic,strong) UILabel *labelDetail;

@end

@implementation XJXLabelCell

- (void)layout{
    [super layout];
    [_labelDetail setX:LEFT_SPACING + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_labelDetail setW:[self getW] - LEFT_SPACING - RIGHT_SPACING];
    [_labelDetail setH:[self getH]];
    
    if(_detailTextColor){
        _labelDetail.textColor = _detailTextColor;
    }
}

- (void)initUI{
    [super initUI];
    _labelDetail = [UIControlsUtils labelWithTitle:@"" color:[[Theme defaultTheme].lightColor colorWithAlphaComponent:.6] font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentRight];
    _labelDetail.numberOfLines = 1;
    
    [self.contentView addSubview:_labelDetail];
}

- (void)setDetail_text:(NSString *)detail_text{
    _detail_text = detail_text;
    _labelDetail.text = _detail_text;
}

@end
