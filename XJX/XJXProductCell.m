//
//  XJXProductCell.m
//  XJX
//
//  Created by Cai8 on 16/1/14.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProductCell.h"
#import "CheckEditor.h"

@interface XJXProductCell()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subTitleLb;
@property (nonatomic,strong) UILabel *priceLb;

@property (nonatomic,strong) UIView *seperator;

@end

@implementation XJXProductCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    [_seperator setY:_imageView.bounds.size.height - 1];
    
    [_titleLb setW:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID * 2];
    [_titleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_titleLb setY:[_imageView getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
    
    if(!_priceLb) return;
    
    [_priceLb recalculateSizeWithPrice:_price font:[Theme defaultTheme].h3Font symbolFont:[Theme defaultTheme].normalTextFont];
    
    [_priceLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_priceLb setY:[self getH] - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID - [_priceLb getH]];
    
    [_subTitleLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID, [_priceLb getMinY] - ([_titleLb getMaxY] + 2))];
    [_subTitleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_subTitleLb setY:[_titleLb getMaxY] + 2];

}

- (void)initUI{
    
    self.layer.borderColor = WhiteColor(0, .07).CGColor;
    self.layer.borderWidth = 1;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    
    _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.bounds.size.height, _imageView.bounds.size.width, 1)];
    _seperator.backgroundColor = WhiteColor(0, .07);
    _seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_imageView addSubview:_seperator];
    
    _titleLb = [UIControlsUtils labelWithTitle:@"我" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentLeft];
    _titleLb.numberOfLines = 1;
    _subTitleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].subTitleColor font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_imageView];
    [self addSubview:_titleLb];
    [self addSubview:_subTitleLb];
}

- (void)setTitle:(NSString *)title{
    _titleLb.text = title;
    [self layout];
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitleLb.text = subTitle;
    [self layout];
}

- (void)setPrice:(CGFloat)price{
    _price = price;
    if(!_priceLb){
        _priceLb = [UIControlsUtils labelWithPrice:price font:[Theme defaultTheme].h3Font symbolFont:[Theme defaultTheme].normalTextFont];
        [self.contentView addSubview:_priceLb];
    }
    [self layout];
}

- (void)loadImageFromURL:(NSString *)url{
    self.imageView.image = nil;
    [self.imageView lazyWithUrl:url];
}

@end
