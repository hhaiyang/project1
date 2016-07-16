//
//  XJXTextFieldCell.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTextFieldCell.h"

@interface XJXTextFieldCell()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;

@end

@implementation XJXTextFieldCell

- (void)layout{
    [super layout];
    
    CGFloat rightspacing = 0.0;
    if(_rightView){
        [_rightView setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_rightView getW]];
        [_rightView verticalCenteredOnView:self.contentView];
        rightspacing = [_rightView getW] + 5;
    }
    
    [_textField setX:LEFT_SPACING];
    [_textField setW:[self getW] - LEFT_SPACING - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - rightspacing];
    [_textField setH:[self getH]];
    [_textField setEnabled:_enabled];
    _textField.placeholder = _placeholder;
}

- (void)initUI{
    [super initUI];
    _enabled = YES;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [Theme defaultTheme].normalTextFont;
    _textField.textColor = [Theme defaultTheme].schemeColor;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self layout];
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    [self layout];
}

- (void)setText:(NSString *)text{
    _textField.text = text;
}

- (NSString *)text{
    return _textField.text;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _textField.keyboardType = keyboardType;
}

#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(_onTextChangedHandler){
        _onTextChangedHandler(textField.text);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(_onTextChangedHandler){
        _onTextChangedHandler(textField.text);
    }
}

- (void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    if(!_rightView.superview){
        [self.contentView addSubview:_rightView];
    }
    [self layout];
}

@end
