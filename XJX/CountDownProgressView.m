//
//  CountDownProgressView.m
//  XJX
//
//  Created by Cai8 on 16/1/26.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "CountDownProgressView.h"

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface CountDownProgressView()

@property (nonatomic,strong) UIImageView *backgroundImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CountDownProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        [self initUI];
    }
    return self;
}

- (void)initParams{
}

- (void)initUI{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"countdown"];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.layer.masksToBounds = YES;
    
    _titleLabel = [UIControlsUtils labelWithTitle:@"12" color:rgba(230, 213, 195, 1) font:[Theme defaultTheme].h1Font];
    [_titleLabel setX:([self getW] * 2.0 / 3.0) - 5 - [_titleLabel getW]];
    [_titleLabel setY:([self getH] * 3.0 / 5.0) - 5 - [_titleLabel getH]];

    [self addSubview:_backgroundImageView];
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    [self layout];
}

- (void)layout{
    if([_titleLabel.text intValue] > 99){
        _titleLabel.text = @"99+";
    }
    [_titleLabel recalculateSize];
    [_titleLabel setX:([self getW] * 2.0 / 3.0) - 5 - [_titleLabel getW]];
    [_titleLabel setY:([self getH] * 3.0 / 5.0) - 5 - [_titleLabel getH]];
}

@end
