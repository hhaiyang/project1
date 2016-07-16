//
//  XJXWishlistToolbar.m
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXWishlistToolbar.h"

@interface XJXWishlistToolbar()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIButton *btnAdd;

@end

@implementation XJXWishlistToolbar
{
    CGRect _oriButtonRect;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self enableBluredEffect];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getW], 1)];
    seperator.backgroundColor = WhiteColor(0, .08);
    [self addSubview:seperator];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0, [self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2, 40)];
    [_containerView verticalCenteredOnView:self];
    _containerView.layer.masksToBounds = YES;
    _containerView.backgroundColor = WhiteColor(.95, 1);
    
    _btnAdd = [UIControlsUtils buttonWithTitle:@"添加" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(onAdd:) padding:UIEdgeInsetsMake(0, 25, 0, 25) frame:CGRectZero];
    [_btnAdd setH:[_containerView getH]];
    [_btnAdd setY:0];
    [_btnAdd setX:[_containerView getW] - [_btnAdd getW]];
    [_btnAdd setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = [Theme defaultTheme].normalTextFont;
    
    _oriButtonRect = _btnAdd.frame;
    
    _urlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, [_btnAdd getMinX] - 10 * 2, [_containerView getH])];
    _urlField.font = [Theme defaultTheme].subTitleFont;
    _urlField.textColor = [Theme defaultTheme].lightColor;
    _urlField.borderStyle = UITextBorderStyleNone;
    _urlField.backgroundColor = [UIColor clearColor];
    _urlField.placeholder = @"粘贴产品链接可以添加到心愿单";
    _urlField.delegate = self;
    
    _containerView.layer.cornerRadius = _btnAdd.layer.cornerRadius = 0.5 * [_containerView getH];
    
    [_containerView addSubview:_urlField];
    [_containerView addSubview:_btnAdd];
    
    [self addSubview:_containerView];
}

- (void)onAdd:(id)sender{
    if(_urlAddedHandler){
        _urlAddedHandler(_urlField.text);
    }
}

- (void)startLoadingAnimationOnCompletion:(onLoadingAnimationComplete)complete{
    _btnAdd.enabled = NO;
    _urlField.enabled = NO;
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.fromValue = @[@([_btnAdd getW]),@([_btnAdd getMinX])];
    anim.toValue = @[@([_containerView getW]),@(0)];
    anim.duration = .8;
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIButton *rView = target;
        [rView setX:[v[1] floatValue]];
        [rView setW:[v[0] floatValue]];
        [rView setTitle:@"努力加载中..." forState:UIControlStateNormal];
    };
    [anim setCompletionBlock:^(POPAnimation *an, BOOL bl) {
        if(bl){
            if(complete){
                complete(self);
            }
        }
    }];
    [_btnAdd pop_addAnimation:anim forKey:@"custom"];
}

- (void)stopAnimation{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = .8;
    anim.fromValue = @[@([_btnAdd getW]),@([_btnAdd getMinX])];
    anim.toValue = @[@(_oriButtonRect.size.width),@(_oriButtonRect.origin.x)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIButton *rView = target;
        [rView setX:[v[1] floatValue]];
        [rView setW:[v[0] floatValue]];
        [rView setTitle:@"添加" forState:UIControlStateNormal];
    };
    [anim setCompletionBlock:^(POPAnimation *an, BOOL bl) {
        if(bl){
            _btnAdd.enabled = YES;
            _urlField.enabled = YES;
            [_urlField setText:@""];
            [_btnAdd setTitle:@"添加" forState:UIControlStateNormal];
        }
    }];
    [_btnAdd pop_addAnimation:anim forKey:@"custom"];
}

@end
