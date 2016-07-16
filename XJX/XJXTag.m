//
//  XJXTag.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTag.h"

@implementation XJXTag{
    UIButton *btn;
}

- (UIView *)render{
    if(!btn){
        btn = [UIControlsUtils buttonWithTitle:_title background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(doSelect:) padding:self.padding frame:CGRectZero];
        btn.layer.borderColor = [Theme defaultTheme].schemeColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 0.5 * btn.bounds.size.height;
    }
    return btn;
}

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    UIView *renderView = [self render];
    [renderView setX:point.x];
    [renderView setY:point.y];
    [view addSubview:renderView];
}

- (void)doSelect:(id)sender{
    if(_touchedHandler){
        _touchedHandler(self);
    }
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    
    if(_selected){
        [btn setBackgroundColor:[Theme defaultTheme].highlightTextColor];
        [btn setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    }
    else{
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[Theme defaultTheme].textColor forState:UIControlStateNormal];
    }
}

- (CGSize)sizeForTag{
    return [self render].bounds.size;
}

@end
