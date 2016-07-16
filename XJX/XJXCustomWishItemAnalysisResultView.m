//
//  XJXCustomWishItemAnalysisResultView.m
//  XJX
//
//  Created by Cai8 on 16/1/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCustomWishItemAnalysisResultView.h"
#import "XJXNumberTicker.h"
#import "PlaceholderTextView.h"

@interface XJXCustomWishItemAnalysisResultView()

@property (nonatomic,strong) XJXCustomWishItem *item;

@property (nonatomic,copy) onItemAdd addHandler;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) XJXNumberTicker *ticker;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIView *bar;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) UITextField *priceField;

@property (nonatomic,strong) PlaceholderTextView *textView;

@end

@implementation XJXCustomWishItemAnalysisResultView

+ (void)showResultViewWithTitle:(NSString *)title desc:(NSString *)desc price:(NSString *)price imageUrl:(NSString *)image_url url:(NSString *)url onAdded:(onItemAdd)addHandler{
    XJXCustomWishItemAnalysisResultView *view = [[XJXCustomWishItemAnalysisResultView alloc] init];
    view.item.title = title;
    view.item.image_url = image_url;
    view.item.url = url;
    view.item.price = [price floatValue];
    view.item.desc = desc;
    view.addHandler = addHandler;
    [view initUI];
    [view show];
}

- (instancetype)init{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        _item = [[XJXCustomWishItem alloc] init];
        self.backgroundColor = WhiteColor(0, .4);
    }
    return self;
}

- (void)initTopBar{
    _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getW], 44)];
    
    UILabel *lb = [UIControlsUtils labelWithTitle:@"外链商品" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentCenter constrainSize:CGSizeMake(150, 44)];
    [lb horizontalCenteredOnView:_bar];
    [lb verticalCenteredOnView:_bar];
    [_bar addSubview:lb];
    
    UIButton *btnClose = [UIControlsUtils buttonWithTitle:@"" background:nil backroundImage:[UIImage imageNamed:@"close"] target:self selector:@selector(close) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    [btnClose setX:SCREEN_WIDTH - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2 - [btnClose getW]];
    [btnClose verticalCenteredOnView:_bar];
    [_bar addSubview:btnClose];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, [_bar getH] - 1, SCREEN_WIDTH, 1)];
    seperator.backgroundColor = WhiteColor(.95, 1);
    [_bar addSubview:seperator];
    
    [_containerView addSubview:_bar];
}

- (void)initHeader{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, [_bar getMaxY], SCREEN_WIDTH, 0)];
    UILabel *infoLb = [UIControlsUtils labelWithTitle:@"*外链商品只能提现，但是会收取5%的手续费" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentLeft];
    
    [infoLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [infoLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [infoLb getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, 90, 90)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;

    [_headerView setH:[imgView getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    UILabel *titleLb = [UIControlsUtils labelWithTitle:_item.title color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentLeft constrainSize:CGSizeMake([self getW] - [imgView getMaxX] - 5 - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 40)];
    [titleLb setX:[imgView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [titleLb setY:[imgView getMinY] + 5];
    
    _ticker = [[XJXNumberTicker alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_ticker setX:[imgView getMaxX] + [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_ticker setY:[imgView getMaxY] - [_ticker getH] - 5];
    
    [_headerView addSubview:infoLb];
    [_headerView addSubview:imgView];
    [_headerView addSubview:titleLb];
    [_headerView addSubview:_ticker];
    [self addSubview:_headerView];
    
    [imgView lazyWithUrl:_item.image_url];
    [_containerView addSubview:_headerView];
    
    [Utils printFrame:_headerView.frame];
}

- (void)initContent{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [_headerView getMaxY], SCREEN_WIDTH, 0)];
    _contentView.backgroundColor = WhiteColor(.95, 1);
    UILabel *priceTitleLb = [UIControlsUtils labelWithTitle:@"价格" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont];
    [priceTitleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [priceTitleLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    _priceField = [[UITextField alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [priceTitleLb getMaxY] + 5, SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 30)];
    _priceField.borderStyle = UITextBorderStyleNone;
    _priceField.backgroundColor = [UIColor clearColor];
    _priceField.placeholder = @"在此输入产品价格";
    _priceField.font = [Theme defaultTheme].subTitleFont;
    _priceField.textColor = [Theme defaultTheme].schemeColor;
    _priceField.layer.borderColor = WhiteColor(.96, 1).CGColor;
    _priceField.layer.borderWidth = 1;
    _priceField.text = [NSString stringWithFormat:@"%.2lf",_item.price];
    
    UIView *seperatorPrice = [[UIView alloc] initWithFrame:CGRectMake(0, [_priceField getH], [_priceField getW], 1)];
    seperatorPrice.backgroundColor = WhiteColor(.98, 1);
    [_priceField addSubview:seperatorPrice];
    
    UILabel *descTitleLb = [UIControlsUtils labelWithTitle:@"产品描述" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont];
    [descTitleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    
    [descTitleLb setY:[_priceField getMaxY] + 5];
    
    _textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI,[descTitleLb getMaxY] + 5, [self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 150)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [Theme defaultTheme].subTitleFont;
    _textView.layer.borderColor = WhiteColor(.96, 1).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.placeholder = @"输入产品描述";
    _textView.text = _item.desc;
    
    [_contentView setH:[_textView getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    [_contentView addSubview:priceTitleLb];
    [_contentView addSubview:_priceField];
    [_contentView addSubview:descTitleLb];
    [_contentView addSubview:_textView];
    
    [_containerView addSubview:_contentView];
    
    [Utils printFrame:_contentView.frame];
}

- (void)initFooter{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, [_contentView getMaxY], SCREEN_WIDTH, 44)];
    UIButton *btnOK = [UIControlsUtils buttonWithTitle:@"立即添加" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(add:) padding:UIEdgeInsetsZero frame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI,0,[self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI,40)];
    [btnOK verticalCenteredOnView:_footerView];
    btnOK.layer.cornerRadius = 0.5 * [btnOK getH];
    [btnOK setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    
    [_footerView addSubview:btnOK];
    [_containerView addSubview:_footerView];
    
    [Utils printFrame:_footerView.frame];
}

- (void)initUI{
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [self getHeight])];
    _containerView.backgroundColor = WhiteColor(1, 1);
    
    [self initTopBar];
    [self initHeader];
    [self initContent];
    [self initFooter];
    [_containerView setH:[self getHeight]];
    [self addSubview:_containerView];
}

- (BOOL)isValid{
    BOOL ok = YES;
    ok = [_priceField.text isEmpty] || ![Validator isValid:IdentifierTypeNumber value:_priceField.text];

    return ok;
}

- (void)add:(id)sender{
    if([self isValid]){
        _item.desc = _textView.text;
        _item.price = [_priceField.text floatValue];
        _item.amount = _ticker.value;
        if(_addHandler){
            _addHandler(_item);
        }
        [self close];
    }
}

- (void)close{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@([self.containerView getMinY])];
    anim.toValue = @[@(SCREEN_HEIGHT)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
    };
    [anim setCompletionBlock:^(POPAnimation *ani, BOOL finished) {
        if(finished){
            [self.containerView.superview removeFromSuperview];
            self.containerView = nil;
        }
    }];
    [self.containerView pop_addAnimation:anim forKey:@"custom"];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@(SCREEN_HEIGHT)];
    anim.toValue = @[@(SCREEN_HEIGHT - [self getHeight])];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
    };
    [self.containerView pop_addAnimation:anim forKey:@"custom"];

}

- (CGFloat)getHeight{
    return [_footerView getMaxY];
}

@end
