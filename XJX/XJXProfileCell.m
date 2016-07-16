//
//  XJXProfileCell.m
//  XJX
//
//  Created by Cai8 on 16/1/29.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProfileCell.h"

@interface XJXProfileCell()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UILabel *emTextLb;

@end

@implementation XJXProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layout{
    [super layout];
    [_iconView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_iconView verticalCenteredOnView:self.contentView];
    
    [_titleLb recalculateSize];
    [_titleLb setX:[_iconView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_titleLb verticalCenteredOnView:self.contentView];
    
    [_emTextLb recalculateSizeWithConstraintSize:CGSizeMake([self.accessoryView getMinX] - 5 * 2 - [self.titleLb getMaxX], [_emTextLb getSingleLineHeight])];
    [_emTextLb setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2 - [_emTextLb getW]];
    [_emTextLb verticalCenteredOnView:self.contentView];
}

- (void)initUI{
    [super initUI];
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LIST_ICON_SIZE, LIST_ICON_SIZE)];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentLeft];
    
    _emTextLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].subTitleFont];
    _emTextLb.numberOfLines = 1;
    
    [self.contentView addSubview:_titleLb];
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_emTextLb];
    
    self.accessoryEnabled = YES;
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _iconView.image = icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = title;
    [self layout];
}

- (void)setEmText:(NSString *)emText{
    _emText = emText;
    _emTextLb.text = _emText;
    [self layout];
}

@end
