//
//  XJXShippingCell.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShippingCell.h"

@interface XJXShippingCell()

@property (nonatomic,strong) UILabel *namingLb;
@property (nonatomic,strong) UILabel *teleLb;
@property (nonatomic,strong) UILabel *addressLb;

@property (nonatomic,strong) UIImageView *locationIcon;
@property (nonatomic,strong) UILabel *titleLb;

@end

@implementation XJXShippingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

- (void)layout{
    [super layout];
    if(!_isEmpty){
        [_teleLb recalculateSize];
        [_teleLb setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2 - [_teleLb getW]];
        [_teleLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
        
        [_namingLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [_namingLb recalculateSizeWithConstraintSize:CGSizeMake([_teleLb getMinX] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 32)];
        [_namingLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
        
        [_addressLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [self getH] - [_namingLb getMaxY] - 15 - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI)];
        [_addressLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [_addressLb setY:[_namingLb getMaxY] + 15];
    }
    else{
        [_locationIcon setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [_locationIcon verticalCenteredOnView:self.contentView];
        
        [_titleLb setX:[_locationIcon getMaxY] + 5];
        [_titleLb verticalCenteredOnView:self.contentView];
    }
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.needBG = YES;
}

- (void)notEmpty{
    [_titleLb removeFromSuperview];
    [_locationIcon removeFromSuperview];
    
    if(!_namingLb || !_namingLb.superview){
         _namingLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont];
        [self.contentView addSubview:_namingLb];
    }
    if(!_teleLb || !_teleLb.superview){
        _teleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont];
        [self.contentView addSubview:_teleLb];
    }
    if(!_addressLb || !_addressLb.superview){
        _addressLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].subTitleColor font:[Theme defaultTheme].subTitleFont];
        [self.contentView addSubview:_addressLb];
    }
    [self layout];
}

- (void)onEmpty{
    [_namingLb removeFromSuperview];
    [_teleLb removeFromSuperview];
    [_addressLb removeFromSuperview];
    [_locationIcon removeFromSuperview];
    [_titleLb removeFromSuperview];
    
    if(!_locationIcon || !_locationIcon.superview){
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFit;
        _locationIcon.image = [UIImage imageNamed:@"receipt address Icon"];
        _locationIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:_locationIcon];
    }
    
    if(!_titleLb || !_titleLb.superview){
        _titleLb = [UIControlsUtils labelWithTitle:@"请填写收货地址" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont];
        [self.contentView addSubview:_titleLb];
    }
    [self layout];
}

- (void)setName:(NSString *)name{
    _name = name;
    _namingLb.text = [NSString stringWithFormat:@"收货人: %@",_name];
}

- (void)setAddress:(NSString *)address{
    _address = address;
    _addressLb.text = [NSString stringWithFormat:@"收货地址: %@",_address];
}

- (void)setTele:(NSString *)tele{
    _tele = tele;
    _teleLb.text = [NSString stringWithFormat:@"电话: %@",tele];
}

- (void)setIsEmpty:(BOOL)isEmpty{
    _isEmpty = isEmpty;
    if(_isEmpty){
        [self onEmpty];
    }
    else{
        [self notEmpty];
    }
}

- (void)setNeedBG:(BOOL)needBG{
    _needBG = needBG;
    if(_needBG){
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        bgImageView.image = [UIImage imageNamed:@"shipping_bg"];
        self.backgroundView = bgImageView;
    }
    else{
        self.backgroundView = nil;
        self.backgroundColor = WhiteColor(1, 1);
    }
}

@end
