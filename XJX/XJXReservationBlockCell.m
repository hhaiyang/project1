//
//  XJXReservationBlockCell.m
//  XJX
//
//  Created by Cai8 on 16/4/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationBlockCell.h"

@interface XJXReservationBlockCell()

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIImageView *accessoryImageView;
@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation XJXReservationBlockCell

- (void)layout{
    if(self.accessoryForeground)
        [self.containerView bringSubviewToFront:self.accessoryImageView];
    else
        [self.containerView sendSubviewToBack:self.accessoryImageView];
    
    self.containerView.frame = CGRectMake(0, 0, [self.contentView getW], [self.contentView getH] - CELL_MARGIN);
    
    self.accessoryImageView.frame = self.containerView.bounds;
}

- (void)initUI{
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.backgroundColor = WhiteColor(1, 1);
    
    self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    self.accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imgView.layer.masksToBounds =
    self.accessoryImageView.layer.masksToBounds = YES;
    
    [self.containerView addSubview:_accessoryImageView];
    [self.containerView addSubview:_imgView];
    
    [self.contentView addSubview:self.containerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.containerView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [self.delegate didTemplateOnTouched:self.imgView onCell:self];
}

- (void)setAccessoryImage:(UIImage *)accessoryImage{
    _accessoryImage = accessoryImage;
    self.accessoryImageView.image = _accessoryImage;
    [self layout];
}

- (void)setImageViewSize:(CGSize)imageViewSize{
    [_imgView setW:imageViewSize.width];
    [_imgView setH:imageViewSize.height];
    [self layout];
}

- (void)setCoord_offsets:(CGPoint)coord_offsets{
    [_imgView setX:coord_offsets.x];
    [_imgView setY:coord_offsets.y];
}

- (void)setAccessoryForeground:(BOOL)accessoryForeground{
    _accessoryForeground = accessoryForeground;
    [self layout];
}

- (UIImageView *)coverImageView{
    return self.imgView;
}

@end
