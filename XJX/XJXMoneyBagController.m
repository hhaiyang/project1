//
//  XJXMoneyBagController.m
//  XJX
//
//  Created by Cai8 on 16/2/1.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMoneyBagController.h"
#import "XJXSlider.h"
#import "XJXMoneyWithdrawSlide.h"

#define HEADER_HEIGHT 50

#define LINE_SPACING 15

@interface XJXMoneyBagController ()

@property (nonatomic,strong) UITextField *withdrawPriceTextField;
@property (nonatomic,strong) UILabel *moneybagLb;
@property (nonatomic,strong) UIButton *btnWithDrawAll;

@property (nonatomic,strong) XJXSlider *slider;

@end

@implementation XJXMoneyBagController
{
    UIScrollView *baseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"我的钱包" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [MoneyBagAPI requestMyMoneyOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"moneybag"];
            done();
        }
        else{
            [self onError];
        }
    }];
}

- (void)reload{
    [MoneyBagAPI requestMyMoneyOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"moneybag"];
            self.moneybagLb.text = [NSString stringWithFormat:@"余额 : %.2lf元",[self.data[@"moneybag"][@"money"] floatValue]];
            _withdrawPriceTextField.text = @"";
            
            [_slider reloadWithData:self.data[@"moneybag"][@"withdraws"]];
        }
        else{
            [self onError];
        }
    }];
}

- (void)initParams{
    
}

- (UIScrollView *)baseView{
    if(!baseView){
        baseView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if(self.navBar){
            [self.view insertSubview:baseView belowSubview:self.navBar];
        }
        else{
            [self addSubview:baseView];
        }
    }
    baseView.backgroundColor = WhiteColor(.95, 1);
    return baseView;
}

- (void)initUI{
    
    UIView *header = [self setupHeader];
    UIView *content = [self setupContent];
    UIView *withDraw = [self setupWithDraw];
    UIView *withDrawHistory = [self setupWithdrawHistory];
    
    [header setY:[self.navBar getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    [content setY:[header getMaxY]];
    [withDraw setY:[content getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2];
    
    header.backgroundColor = content.backgroundColor = WhiteColor(1, 1);
    
    withDraw.backgroundColor = [Theme defaultTheme].highlightTextColor;
    withDraw.layer.cornerRadius = 0.5 * withDraw.bounds.size.height;
    
    [withDrawHistory setY:[withDraw getMaxY] + 50];
    
    [[self baseView] setContentSize:CGSizeMake(SCREEN_WIDTH, [withDrawHistory getMaxY])];
}

- (UIView *)setupHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI + [self.navBar getMaxY], [self.view getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, HEADER_HEIGHT)];
    
    UILabel *lbTitle = [UIControlsUtils labelWithTitle:@"到账账户" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].normalTextFont];
    [lbTitle setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [lbTitle verticalCenteredOnView:header];
    
    UILabel *lbDesc = [UIControlsUtils labelWithTitle:@"微信账户" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont];
    [lbDesc setX:[header getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [lbDesc getW]];
    [lbDesc verticalCenteredOnView:header];
    
    [header addSubview:lbTitle];
    [header addSubview:lbDesc];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [header getH] - 1, [header getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 1)];
    seperator.backgroundColor = WhiteColor(0, .08);
    
    [header addSubview:seperator];
    
    [[self baseView] addSubview:header];
    return header;
}

- (UIView *)setupContent{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0, [self.view getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0)];
    UILabel *titleLb = [UIControlsUtils labelWithTitle:@"提现金额" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].titleFont];
    [titleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [titleLb setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI];
    
    UILabel *infoLb = [UIControlsUtils labelWithTitle:[NSString stringWithFormat:@"*未满%.2lf元不可提现,提现会收取%.0lf%%手续费",[self.data[@"moneybag"][@"nocharge_money"] floatValue] / 100,[self.data[@"moneybag"][@"charge_ratio"] floatValue] * 100] color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont];
    [infoLb setX:[titleLb getMaxX] + 5];
    [infoLb setY:[titleLb getMaxY] - [infoLb getH]];
    
    UILabel *symbolLb = [UIControlsUtils labelWithTitle:@"￥" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].titleFont];
    
    [symbolLb setY:[titleLb getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2];
    [symbolLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    
    CGSize size = [@"提现" sizeWithFont:[Theme defaultTheme].h2Font];

    _withdrawPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake([symbolLb getMaxX] + 5, [symbolLb getMinY], [content getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - ([symbolLb getMaxX] + 5), size.height)];
    _withdrawPriceTextField.borderStyle = UITextBorderStyleNone;
    _withdrawPriceTextField.backgroundColor = [UIColor clearColor];
    _withdrawPriceTextField.textColor = [Theme defaultTheme].schemeColor;
    _withdrawPriceTextField.font = [Theme defaultTheme].h2Font;
    _withdrawPriceTextField.placeholder = @"请输入提现金额";
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [_withdrawPriceTextField getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2, [content getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 1)];
    seperator.backgroundColor = WhiteColor(0, .08);
    
    UIView *content_footer = [[UIView alloc] initWithFrame:CGRectMake(0, [seperator getMaxY], [content getW], 50)];
    
    _moneybagLb = [UIControlsUtils labelWithTitle:[NSString stringWithFormat:@"余额 : %.2lf元",[self.data[@"moneybag"][@"money"] floatValue] / 100] color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].subTitleFont];
    
    [_moneybagLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_moneybagLb verticalCenteredOnView:content_footer];
    
    _btnWithDrawAll = [UIControlsUtils buttonWithTitle:@"全部提现" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(withdrawAll) padding:UIEdgeInsetsZero frame:CGRectZero];
    [_btnWithDrawAll setX:[content_footer getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_btnWithDrawAll getW]];
    [_btnWithDrawAll verticalCenteredOnView:content_footer];
    
    [content_footer addSubview:_moneybagLb];
    [content_footer addSubview:_btnWithDrawAll];
    
    [content addSubview:seperator];
    [content addSubview:titleLb];
    [content addSubview:infoLb];
    [content addSubview:symbolLb];
    [content addSubview:_withdrawPriceTextField];
    [content addSubview:content_footer];
    
    [content setH:[content_footer getMaxY]];
    
    [[self baseView] addSubview:content];
    
    return content;
}

- (UIView *)setupWithDraw{
    UIButton *btnWithDraw = [UIControlsUtils buttonWithTitle:@"提现" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(withdraw) padding:UIEdgeInsetsZero frame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0, [self.view getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2, 44)];
    [btnWithDraw setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    [[self baseView] addSubview:btnWithDraw];
    return btnWithDraw;
}

- (void)withdrawAll{
    _withdrawPriceTextField.text = [NSString stringWithFormat:@"%.2lf",[self.data[@"moneybag"][@"money"] floatValue] / 100];
}

- (UIView *)setupWithdrawHistory{
    _slider = [XJXSlider sliderWithData:self.data[@"moneybag"][@"withdraws"] frame:CGRectMake(0, 0, SCREEN_WIDTH, 120) spacing:25 onViewCreated:^XJXSlide *(NSUInteger index, id item) {
        XJXMoneyWithdrawSlide *slide = [[XJXMoneyWithdrawSlide alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 70)];
        slide.coverView.image = [UIImage imageNamed:@"withdrawbg"];
        slide.coverView.contentMode = UIViewContentModeScaleAspectFill;
        return slide;
    } onViewReused:^(XJXSlide *slide, NSUInteger index, id item) {
        XJXMoneyWithdrawSlide *s = (XJXMoneyWithdrawSlide *)slide;
        s.title = [NSString stringWithFormat:@"提现编号: %@",item[@"transaction_no"]];
        s.price = ([item[@"money"] floatValue] + [item[@"service_charge"] floatValue]) / 100.0;
        s.time = item[@"timetag"];
        s.status = [item[@"status"] intValue] == 0 ? @"待审核" : [item[@"status"] intValue] == 1 ? @"已打款" : @"拒绝";
    } onViewTouched:^(NSUInteger index, id item) {
        
    }];
    _slider.pageEnable = YES;
    _slider.enablePageIndicator = YES;
    [[self baseView] addSubview:_slider];
    return _slider;
}

- (void)withdraw{
    NSString *value = _withdrawPriceTextField.text;
    if([Validator isValid:IdentifierTypeNumber value:value]){
        if([value floatValue] * 100 < [self.data[@"moneybag"][@"nocharge_money"] floatValue]){
            [Utils showAlert:@"提现金额不得小于最低标准" title:@"警告"];
            return;
        }
        [MoneyBagAPI withDrawRequestWithMoney:[value floatValue] * 100 completion:^(id res, NSString *err) {
            if(!err){
                [Utils showAlert:@"提现已申请" title:@"信息"];
                [self reload];
            }
            else{
                [Utils showAlert:err title:@"警告"];
            }
        }];
    }
    else{
        [Utils showAlert:@"金额格式不正确" title:@"警告"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
