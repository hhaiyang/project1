//
//  XJXWebBrowser.m
//  XJX
//
//  Created by Cai8 on 16/1/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXWebBrowser.h"

@interface XJXWebBrowser ()<WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webview;

@property (nonatomic,strong) UIView *progressView;

@end

@implementation XJXWebBrowser

+ (XJXWebBrowser *)browserWithRedirectUrl:(NSString *)url{
    XJXWebBrowser *browser = [[XJXWebBrowser alloc] init];
    [browser.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    return browser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParams{
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    [btnBack setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [btnBack setY:20 + (44 - btnBack.bounds.size.height) / 2.0];
    [self.navBar addSubview:btnBack];
    
//    UIButton *btnFav = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"collect"] target:self selector:@selector(fav:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
//    UIButton *btnShare = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"share"] target:self selector:@selector(share:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:self.externalParams[@"title"] color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h4Font textAlignment:NSTextAlignmentCenter];
    [naviTitleLb setW:150];
    [naviTitleLb setH:16];
    naviTitleLb.numberOfLines = 1;
    naviTitleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
//    UIBarButtonItem *itemFav = [[UIBarButtonItem alloc] initWithCustomView:btnFav];
//    UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.externalParams[@"title"]];
    [item setTitleView:naviTitleLb];
//    [item setRightBarButtonItems:@[itemShare,itemFav]];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)back:(id)sender{
    if(_webview.canGoBack){
        [_webview goBack];
    }
    else{
        [super back:sender];
    }
}

- (void)initUI{
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], 0, 2)];
    _progressView.backgroundColor = [Theme defaultTheme].highlightTextColor;
    
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [self.navBar getMaxY])];
    _webview.navigationDelegate = self;
    
    [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self addSubview:_webview];
    [self addSubview:_progressView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _webview) {
            self.progressView.alpha = 1;
            [self setProgress:_webview.estimatedProgress];
            
            if(self.webview.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self setProgress:0];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

- (void)setProgress:(CGFloat)progress{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.easingType = MMTweenEasingOut;
    anim.functionType = MMTweenFunctionExpo;
    anim.duration = .2;
    anim.fromValue = @[@([_progressView getW])];
    anim.toValue = @[@(progress * SCREEN_WIDTH)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIView *rView = target;
        [rView setW:[v[0] floatValue]];
    };
    [self.progressView pop_addAnimation:anim forKey:@"custom"];
}

- (void)registerEvents{
    
}

- (void)dealloc{
    [_webview removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [(UILabel *)self.navBar.items[0].titleView setText:webView.title];
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
