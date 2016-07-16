//
//  XJXBrick.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBrick.h"

@implementation XJXBrick

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, self.width, self.height)];
    renderView.layer.cornerRadius = self.borderRadius;
    renderView.layer.masksToBounds = YES;
    renderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:renderView.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.layer.masksToBounds = YES;
    [renderView addSubview:bg];
    
    [bg lazyWithUrl:self.image_url];
    
    UIView *maskView = [[UIView alloc] initWithFrame:renderView.bounds];
    maskView.backgroundColor = rgba(0, 0, 0, 0);
    
    [renderView addSubview:maskView];
    
    UILabel *lb = [UIControlsUtils labelWithTitle:self.title color:self.titleColor font:self.titleFont];
//    [lb setY:(renderView.bounds.size.height - lb.bounds.size.height) / 2];
//    [lb setX:(renderView.bounds.size.width - lb.bounds.size.width) / 2];
    [lb setX:[renderView getW] - [lb getW]];
    [lb setY:[renderView getH] - [lb getH]];
    [lb setBackgroundColor:WhiteColor(0, 0.2)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [renderView addGestureRecognizer:tap];
    
    [renderView addSubview:lb];
    
    [view addSubview:renderView];
}

- (void)onTap:(UITapGestureRecognizer *)tap{
    if(_touchedHandler){
        _touchedHandler(self);
    }
}

@end
