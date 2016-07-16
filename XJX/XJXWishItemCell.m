//
//  XJXWishItemCell.m
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXWishItemCell.h"

@interface XJXWishItemCell()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subTitleLb;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *amountLb;

@property (nonatomic,strong) UIView *seperator;

@end

@implementation XJXWishItemCell

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
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_seperator setY:_imageView.bounds.size.height - 1];
    [_titleLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID, 36)];
    [_titleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_titleLb setY:[_imageView getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
    
    [_priceLb recalculateSizeWithPrice:_price font:[Theme defaultTheme].h3Font symbolFont:[Theme defaultTheme].normalTextFont];
    
    [_priceLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_priceLb setY:[self getH] - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID - [_priceLb getH]];
    
    [_amountLb recalculateSize];
    [_amountLb setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID - [_amountLb getW]];
    [_amountLb setY:([_subTitleLb getMaxY] + 12 + MAX(([_priceLb getH] - [_amountLb getH]) / 2.0,0))];
    
    [_subTitleLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID, [_priceLb getMinY] - ([_titleLb getMinY] + 36 + 5))];
    [_subTitleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_subTitleLb setY:[_titleLb getMinY] + 36 + 5];
    
    
    if(_editing){
        [_editor setX:[self.contentView getW] - [_editor getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
        [_editor setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
        [self.contentView bringSubviewToFront:_editor];
    }
    _editor.hidden = !_editing;
}

- (void)initUI{
    self.backgroundColor = WhiteColor(1, 1);
    self.layer.borderColor = WhiteColor(0, .07).CGColor;
    self.layer.borderWidth = 1;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    
    _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.bounds.size.height, _imageView.bounds.size.width, 1)];
    _seperator.backgroundColor = WhiteColor(0, .07);
    _seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_imageView addSubview:_seperator];
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentLeft];
    _subTitleLb = [UIControlsUtils labelWithTitle:@"我" color:[Theme defaultTheme].subTitleColor font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentLeft];
    
    _amountLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont];
    
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_titleLb];
    [self.contentView addSubview:_subTitleLb];
    [self.contentView addSubview:_amountLb];
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

- (void)setEditing:(BOOL)editing{
    _editing = editing;
    if(!_editor){
        _editor = [[CheckEditor alloc] init];
        _editor.sender = self;
        [self.contentView addSubview:_editor];
    }
    
    [self layout];
}

- (void)setAmount:(int)amount{
    _amount = amount;
    _amountLb.text = [NSString stringWithFormat:@"数量: %d",_amount];
    [self layout];
}

- (void)loadImageFromURL:(NSString *)url{
    self.imageView.image = nil;
    [self.imageView lazyWithUrl:url];
}

@end
