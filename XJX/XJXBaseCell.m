//
//  XJXBaseCell.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

@interface XJXBaseCell()

@end

@implementation XJXBaseCell
{
    UIImageView *accessory;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
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
    
    if(_accessoryEnabled){
        [accessory setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [accessory getW]];
        [accessory verticalCenteredOnView:self.contentView];
    }
    
    [_seperator setY:[self.contentView getH] - 1];
    [_seperator setW:[self.contentView getW]];
}

- (void)initUI{
    self.layer.masksToBounds = YES;
    
    if(!_seperator){
        _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _seperator.backgroundColor = WhiteColor(0, .08);
        [self addSubview:_seperator];
    }
}

- (void)setCheckable:(BOOL)checkable{
    _checkable = checkable;
    [self layout];
}

- (void)initCheckableView{
    _editor = [[CheckEditor alloc] init];
    _editor.sender = self;
    _checkableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [_editor getW], 0)];
    [_checkableView addSubview:_editor];
    [self.contentView addSubview:_checkableView];
}

- (void)setCheck:(BOOL)check{
    _editor.checked = check;
}

- (void)setEditorOnCheck:(onEditorCheckStatusChanged)editorChangedHandler{
    _editor.statusChangedHandler = editorChangedHandler;
}

- (void)setAccessoryEnabled:(BOOL)accessoryEnabled{
    _accessoryEnabled = accessoryEnabled;
    if(_accessoryEnabled){
        [self enableRightAccessory];
    }
    else{
        [self disableRightAccessory];
    }
    [self layout];
}

- (void)enableRightAccessory{
    if(!accessory){
        accessory = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)];
        accessory.contentMode = UIViewContentModeScaleAspectFit;
        accessory.image = [UIImage imageNamed:@"arrow"];
        accessory.layer.masksToBounds = YES;
        [self.contentView addSubview:accessory];
    }
}

- (void)disableRightAccessory{
    [accessory removeFromSuperview];
    accessory = nil;
}

@end
