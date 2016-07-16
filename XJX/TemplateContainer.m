//
//  TemplateContainer.m
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "TemplateContainer.h"

@implementation TemplateContainer
{
    NSMutableArray *imageViews;
    id _template;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        imageViews = [NSMutableArray array];
        self.backgroundColor = WhiteColor(1, 1);
    }
    return self;
}

- (void)layoutSubviews{
    __block CGFloat y_offset = IMAGE_SPACING;
    [imageViews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id _obj = _template[@"images"][idx];
        [obj setW:[self getW] - 2 * IMAGE_SPACING];
        [obj horizontalCenteredOnView:self];
        [obj setY:y_offset];
        [obj setH:([_obj[@"size"] CGSizeValue].height / [_obj[@"size"] CGSizeValue].width) * ([self getW] - 2 * IMAGE_SPACING)];
        y_offset += [obj getH] + IMAGE_SPACING;
    }];
}

- (void)cleanup{
    [imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [imageViews removeAllObjects];
}

- (void)loadTemplate:(id)galleryTemplate{
    _template = galleryTemplate;
    [self cleanup];
    
    NSArray *images = galleryTemplate[@"images"];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = obj[@"type"];
        NSString *image = obj[@"image"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithFile:image type:@"jpg"]];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = idx;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        [imageViews addObject:imageView];
        
        id entity = obj[@"image_entity"];
        if(entity){
            [imageView lazyWithUrl:SERVER_FILE_WRAPPER(entity[@"big_thumb_image_url"])];
        }
        
        if([type isEqualToString:@"placeholderImage"]){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            
            [imageView addGestureRecognizer:tap];
        }
    }];
}

- (void)onTap:(UIGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTemplateOnTouched:imageTemplate:)]){
        [self.delegate didTemplateOnTouched:(UIImageView *)gesture.view imageTemplate:_template[@"images"][gesture.view.tag]];
    }
}

- (CGFloat)getHeight{
    __block CGFloat height = IMAGE_SPACING;
    NSArray *images = _template[@"images"];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        height += ([obj[@"size"] CGSizeValue].height / [obj[@"size"] CGSizeValue].width) * ([self getW] - 2 * IMAGE_SPACING) + IMAGE_SPACING;
    }];
    return height;
}

@end
