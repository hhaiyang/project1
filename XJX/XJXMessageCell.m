//
//  XJXMessageCell.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMessageCell.h"

@interface XJXMessageCell()

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subTitleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *badgeLb;

@property (nonatomic,strong) UIImageView *icon;

@end

@implementation XJXMessageCell

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    [_icon setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_icon verticalCenteredOnView:self.contentView];
    
    [_timeLb recalculateSizeWithConstraintSize:CGSizeMake(150, 22)];
    [_timeLb setX:self.bounds.size.width - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - _titleLb.bounds.size.width];
    
    [_titleLb setX:[_icon getMaxX] + 10];
    [_titleLb setY:_icon.frame.origin.y];
    [_titleLb recalculateSizeWithConstraintSize:CGSizeMake(_timeLb.frame.origin.x - [_icon getMaxX] - 10, 30)];
    
    [_badgeLb recalculateSize];
    [_badgeLb setW:_badgeLb.bounds.size.width + 5];
    [_badgeLb setH:_badgeLb.bounds.size.height + 5];
    
    _badgeLb.layer.cornerRadius = 0.5 * _badgeLb.bounds.size.height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentLeft];
    _subTitleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].subTitleColor  font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentLeft];
    _timeLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont textAlignment:NSTextAlignmentRight];
    _badgeLb = [UIControlsUtils labelWithTitle:@"" color:WhiteColor(1, 1) font:[Theme defaultTheme].emFont textAlignment:NSTextAlignmentCenter];
    
    _badgeLb.backgroundColor = [Theme defaultTheme].highlightTextColor;
    
    _titleLb.numberOfLines = 1;
    _subTitleLb.numberOfLines = 2;
    _timeLb.numberOfLines = 1;
    _badgeLb.numberOfLines = 1;
    
    [self.contentView addSubview:_icon];
    [self.contentView addSubview:_titleLb];
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_badgeLb];
}

- (void)setMessageType:(XJXMessageCellType)messageType{
    UIImage *image = nil;
    switch (messageType) {
        case kMessageCellTypeMessage:{
            image = [UIImage imageNamed:@"message"];
        }
            break;
        case kMessageCellTypeCreditsChanged:{
            image = [UIImage imageNamed:@"credits"];
        }
            break;
        case kMessageCellTypeCrowdFundingMessage:{
            image = [UIImage imageNamed:@"funding"];
        }
            break;
        case kMessageCellTypeShippingStatusChange:{
            image = [UIImage imageNamed:@"shipping"];
        }
            break;
        default:
            break;
    }
    self.icon.image = image;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = title;
    [self layout];
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    _subTitleLb.text = subTitle;
    [self layout];
}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLb.text = time;
    [self layout];
}

- (void)setBadge:(int)badge{
    _badge = badge;
    _badgeLb.text = [NSString stringWithFormat:@"%d",MIN(badge, 99)];
    [self layout];
}

@end
