//
//  XJXReservationBlockCell.h
//  XJX
//
//  Created by Cai8 on 16/4/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

#define CELL_MARGIN 30

@class XJXReservationBlockCell;

@protocol XJXReservationBlockCellDelegate <NSObject>

- (void)didTemplateOnTouched:(UIImageView *)imageView onCell:(XJXReservationBlockCell *)cell;

@end

@interface XJXReservationBlockCell : XJXBaseCell

@property (nonatomic,assign) BOOL accessoryForeground;
@property (nonatomic,strong) UIImage *accessoryImage;
@property (nonatomic,assign) CGPoint coord_offsets;
@property (nonatomic,assign) CGSize imageViewSize;

@property (nonatomic,assign) id<XJXReservationBlockCellDelegate> delegate;

- (UIImageView *)coverImageView;

@end
