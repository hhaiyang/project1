//
//  EditingLabel.m
//  XJX
//
//  Created by Cai8 on 16/1/25.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "EditingLabel.h"

@interface EditingLabel()<UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *container;
@property (nonatomic,strong) UITextField *textField;

@end

@implementation EditingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text{
    if(self = [self initWithFrame:CGRectZero]){
        [self setText:text];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font{
    if(self = [self initWithFrame:CGRectZero]){
        self.textLabel.font = font;
        [self setText:text];
    }
    return self;
}

- (void)layoutSubviews{
    _textLabel.frame = self.bounds;
}

- (void)initUI{
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [Theme defaultTheme].invitationFieldBigFont;
    _textLabel.textColor = [Theme defaultTheme].invitationFieldColor;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLabel.numberOfLines = 1;
    [self addSubview:_textLabel];
    
    UIView *fieldContainer = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, SCREEN_HEIGHT - 50 - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 44)];
    fieldContainer.backgroundColor = WhiteColor(1, 1);
    fieldContainer.layer.cornerRadius = 0.5 * [fieldContainer getH];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0, [fieldContainer getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [fieldContainer getH])];
    _textField.textColor = [Theme defaultTheme].schemeColor;
    _textField.font = [Theme defaultTheme].normalTextFont;
    
    _textField.delegate = self;
    
    [fieldContainer addSubview:_textField];
    
    _container = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _container.backgroundColor = WhiteColor(0, .4);
    [_container addSubview:fieldContainer];
    
    _container.alpha = 0;
    
    UITapGestureRecognizer *tapOnContainer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerTouched:)];
    [_container addGestureRecognizer:tapOnContainer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditing)];
    [self addGestureRecognizer:tap];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _textField.placeholder = placeholder;
}

- (void)onEditing{
    [[UIApplication sharedApplication].keyWindow addSubview:_container];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = .2;
    anim.fromValue = @[@(_container.alpha)];
    anim.toValue = @[@(1)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIView *rView = target;
        rView.alpha = [v[0] floatValue];
    };
    [_container pop_addAnimation:anim forKey:@"custom"];
    
    [_textField becomeFirstResponder];
}

- (void)setText:(NSString *)text{
    CGSize size = [text sizeWithFont:self.textLabel.font constrainToSize:CGSizeMake(100, 20)];
    [self setW:size.width];
    [self setH:size.height];
    _textLabel.text = text;
}

- (void)updateAndHide{
    _textLabel.text = _textField.text;
    [self hide];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didEditing:)]){
        [self.delegate didEditing:self];
    }
}

- (void)hide{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = .3;
    anim.fromValue = @[@(_container.alpha)];
    anim.toValue = @[@(0)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIView *rView = target;
        rView.alpha = [v[0] floatValue];
    };
    [anim setCompletionBlock:^(POPAnimation *ani, BOOL finished) {
        if(finished){
            _textField.text = @"";
            [_container removeFromSuperview];
            
        }
    }];
    [_container pop_addAnimation:anim forKey:@"custom"];
}

#pragma mark - textfield
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self updateAndHide];
    return YES;
}

- (void)containerTouched:(UIGestureRecognizer *)gesture{
    if(_textField.editing){
        [_textField endEditing:YES];
    }
    else{
        if(![[gesture view] isKindOfClass:[UITextField class]]){
            [self hide];
        }
    }
}

- (void)recalculateSize{
    [_textLabel recalculateSize];
    self.bounds = _textLabel.bounds;
}

@end
