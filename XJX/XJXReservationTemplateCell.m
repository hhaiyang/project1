//
//  XJXReservationTemplateCell.m
//  XJX
//
//  Created by Cai8 on 16/1/26.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationTemplateCell.h"

#define WHITE_SPACING 15

@interface XJXReservationTemplateCell()

@end

@implementation XJXReservationTemplateCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layout{
    [_container setY:0];
    [_container setW:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2];
    [_container setH:[_container getHeight]];
    [_container horizontalCenteredOnView:self.contentView];
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    _container = [[TemplateContainer alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_container];
}

- (void)setGalleryTemplate:(id)galleryTemplate{
    [_container loadTemplate:galleryTemplate];
}

+ (CGFloat)heightForTemplate:(id)galleryTemplate{
    CGFloat containerWidth = (SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    __block CGFloat height = IMAGE_SPACING;
    NSArray *images = galleryTemplate[@"images"];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        height += ([obj[@"size"] CGSizeValue].height / [obj[@"size"] CGSizeValue].width) * (containerWidth - 2 * IMAGE_SPACING) + IMAGE_SPACING;
    }];
    height += WHITE_SPACING;
    NSLog(@"cell height : %lf",height);
    return height;
}

@end
