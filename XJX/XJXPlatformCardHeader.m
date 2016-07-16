//
//  XJXPlatformCardHeader.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXPlatformCardHeader.h"

@interface XJXPlatformCardHeader()

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *descLb;

@property (nonatomic,strong) UIView *borderView;

@property (nonatomic,strong) UIButton *actionButton;

@property (nonatomic,copy) onActionButtonTouched actionTouchedHandler;

@end

@implementation XJXPlatformCardHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    if(_checkable){
        if(!_checkableView){
            [self initCheckableView];
        }
        
        [_checkableView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [_checkableView setY:0];
        [_checkableView setH:[self getH]];
        [_editor verticalCenteredOnView:_checkableView];
        [_editor horizontalCenteredOnView:_checkableView];
    }
    else{
        [_checkableView removeFromSuperview];
        self.checkableView = nil;
    }
    if(_logo_url){
        [_icon setX:[_checkableView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [_icon verticalCenteredOnView:self];
    }
    
    [_titleLb setX:_logo_url ? [_icon getMaxX] + 5 : [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_titleLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - [_titleLb getMinX], [self getH] - 2 * 5)];
    [_titleLb verticalCenteredOnView:self];
    
    if(_descLb){
        [_descLb setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_descLb getW]];
        [_descLb verticalCenteredOnView:self];
    }
    
    if(_actionButton){
        [_actionButton setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_actionButton getW]];
        [_actionButton verticalCenteredOnView:self];
    }
    
    [_borderView setW:[self getW]];
    [_borderView setY:[self getH] - 1];
    
}

- (void)setEditorOnCheck:(onEditorCheckStatusChanged)editorChangedHandler{
    _editor.statusChangedHandler = editorChangedHandler;
}

- (void)initCheckableView{
    _editor = [[CheckEditor alloc] init];
    _editor.sender = self;
    _checkableView = [[UIView alloc] initWithFrame:CGRectMake(-[_editor getW], 0, [_editor getW], 0)];
    [_checkableView addSubview:_editor];
    [self addSubview:_checkableView];
}

- (void)initUI{
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = WhiteColor(1, 1);
    bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundView = bgView;
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].normalTextFont];
    _titleLb.numberOfLines = 1;
    
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getH] - 1, [self getW], 1)];
    _borderView.backgroundColor = WhiteColor(0, .07);
    
    [self addSubview:_titleLb];
    [self addSubview:_borderView];
}

- (void)setCheckable:(BOOL)checkable{
    _checkable = checkable;
    [self layout];
}

- (void)setPlatform_name:(NSString *)platform_name{
    _platform_name = platform_name;
    _titleLb.text = _platform_name;
    [self setNeedsLayout];
}

- (void)setLogo_url:(NSString *)logo_url{
    _logo_url = logo_url;
    
    if(_logo_url){
        if(!_icon){
            _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
            _icon.layer.borderColor = [[Theme defaultTheme].lightColor colorWithAlphaComponent:.6].CGColor;
            _icon.layer.borderWidth = 1;
            _icon.layer.cornerRadius = 0.5 * [_icon getH];
            [self addSubview:_icon];
        }
        [_icon lazyWithUrl:_logo_url];
    }
    else{
        [_icon removeFromSuperview];
        self.icon = nil;
    }
}

- (void)setDesc:(NSAttributedString *)desc{
    _desc = desc;
    if(!_descLb){
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
        _descLb = [UIControlsUtils labelWithAttributeTitle:str textAlignment:NSTextAlignmentRight];
        _descLb.numberOfLines = 0;
        [self addSubview:_descLb];
    }
    
    [_actionButton removeFromSuperview];
    self.actionButton = nil;
    
    CGSize size = [desc size];
    [self.descLb setW:size.width];
    [self.descLb setH:size.height];
    self.descLb.attributedText = desc;
    [self layout];
}

- (void)setActionButtonWithTitle:(NSString *)title action:(onActionButtonTouched)actionHandler{
    if(!_actionButton){
        _actionButton = [UIControlsUtils buttonWithTitle:title background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(actionClick:) padding:UIEdgeInsetsMake(5, 15, 5, 15) frame:CGRectZero];
        [_actionButton setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
        [_actionButton setBackgroundColor:[Theme defaultTheme].highlightTextColor];
        _actionButton.layer.cornerRadius = 0.5 * [_actionButton getH];
        [self addSubview:_actionButton];
    }
    
    [_descLb removeFromSuperview];
    self.descLb = nil;
    
    [_actionButton setTitle:title forState:UIControlStateNormal];
    self.actionTouchedHandler = actionHandler;
    
    [self layout];
}

- (void)setEditing:(BOOL)editing{
    _editing = editing;
    if(editing){
        self.checkable = NO;
    }
    else{
        self.checkable = YES;
    }
    [self layout];
}

- (void)actionClick:(id)sender{
    if(self.actionTouchedHandler){
        self.actionTouchedHandler(self);
    }
}

@end
