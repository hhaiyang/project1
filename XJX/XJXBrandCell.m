//
//  XJXBrandCell.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBrandCell.h"

@interface XJXBrandCell()

@property (nonatomic,strong) UIView *container;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subTitleLb;

@property (nonatomic,strong) UIView *line;

@end

@implementation XJXBrandCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layout{
    [self.container setW:[self.contentView getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [self.container horizontalCenteredOnView:self.contentView];
    [self.container setH:[self.contentView getH] - WHITE_SPACING];
    
    [self.imgView setX:0];
    [self.imgView setY:0];
    [self.imgView setW:[self.container getH]];
    [self.imgView setH:[self.container getH]];
    
    [self.titleLb recalculateSize];
    [self.titleLb setX:[self.imgView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [self.titleLb setY:[self.imgView getMinY] + 30];
    
    [self.subTitleLb setX:[self.imgView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [self.subTitleLb setY:[self.titleLb getMaxY] + 10];
    [self.subTitleLb recalculateSizeWithConstraintSize:CGSizeMake([self.container getW] - [self.subTitleLb getMinX] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI,[self.container getH] - [self.subTitleLb getMinY])];
    
    [self.line setX:[self.imgView getMaxX]];
    [self.line setW:1];
    [self.line setH:[self.container getH] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    [self.line verticalCenteredOnView:self.container];
}

- (void)initUI{
    
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].h3Font];
    self.subTitleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].subTitleColor font:[Theme defaultTheme].subTitleFont];
    
    self.titleLb.numberOfLines = 1;
    self.titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subTitleLb.numberOfLines = 2;
    self.subTitleLb.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.line.backgroundColor = WhiteColor(0, .08);
    
    [self.contentView addSubview:self.container];
    
    [self.container addSubview:self.imgView];
    [self.container addSubview:self.titleLb];
    [self.container addSubview:self.subTitleLb];
    [self.container addSubview:self.line];
    
    self.container.backgroundColor = WhiteColor(1, 1);
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = [_title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLb.text = [_subTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)setImage_url:(NSString *)image_url{
    _image_url = image_url;
    [self.imgView lazyWithUrl:_image_url];
}

@end
