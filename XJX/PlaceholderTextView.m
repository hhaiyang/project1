//
//  PlaceholderTextView.m
//  XJX
//
//  Created by Cai8 on 16/1/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *backgroundTextView;

@property (nonatomic,strong) UITextView *mainTextView;

@end

@implementation PlaceholderTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _padding = UIEdgeInsetsZero;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _backgroundTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.padding.left, self.padding.top, [self getW] - (self.padding.left + self.padding.right), [self getH] - (self.padding.top + self.padding.bottom))];
    _mainTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.padding.left, self.padding.top, [self getW] - (self.padding.left + self.padding.right), [self getH] - (self.padding.top + self.padding.bottom))];
    _mainTextView.backgroundColor = [UIColor clearColor];
    _backgroundTextView.delegate = _mainTextView.delegate = self;
    
    self.textColor = [Theme defaultTheme].schemeColor;
    self.placeholderColor = [[Theme defaultTheme].lightColor colorWithAlphaComponent:.8];
    
    [self addSubview:_backgroundTextView];
    [self addSubview:_mainTextView];
}

- (void)setPadding:(UIEdgeInsets)padding{
    _padding = padding;
    CGRect rect = CGRectMake(self.padding.left, self.padding.top, [self getW] - (self.padding.left + self.padding.right), [self getH] - (self.padding.top + self.padding.bottom));
    _backgroundTextView.frame = rect;
    _mainTextView.frame = rect;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _backgroundTextView.text = placeholder;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    _mainTextView.font = _backgroundTextView.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _mainTextView.textColor = textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _backgroundTextView.textColor = placeholderColor;
}

- (void)setText:(NSString *)text{
    _mainTextView.text = text;
    _backgroundTextView.hidden = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0;
}

- (NSString *)text{
    return _mainTextView.text;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.mainTextView.backgroundColor = backgroundColor;
}

//通过判断表层TextView的内容来实现底层TextView的显示于隐藏
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""])
    {
        [_backgroundTextView setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [_backgroundTextView setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
