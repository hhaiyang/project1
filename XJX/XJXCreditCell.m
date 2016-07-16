//
//  XJXCreditCell.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCreditCell.h"

@interface XJXCreditCell()

@end

@implementation XJXCreditCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layout{
    [super layout];
    [_accessoryEditor setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_accessoryEditor getW]];
    [_accessoryEditor verticalCenteredOnView:self.contentView];
}

- (void)initUI{
    [super initUI];
    _accessoryEditor = [[CheckEditor alloc] init];
    [self.contentView addSubview:_accessoryEditor];
}

@end
