//
//  XJXCustomItemBrowser.m
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCustomItemBrowser.h"
#import <WebKit/Webkit.h>
#import "XJXCustomWishItemAnalysisResultView.h"

#define SCRIPT_NOTI_ANALYSIS @"script_analysis"

@interface XJXCustomItemBrowser()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) XJXCustomWishItem *analysisResult;

@property (nonatomic,copy) onAnalysisDone handler;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIButton *btnAnalysis;

@property (nonatomic,copy) NSString *currenUrl;

@end

@implementation XJXCustomItemBrowser

+ (void)analysisItemWithUrl:(NSString *)url completion:(onAnalysisDone)handler{
    XJXCustomItemBrowser *b = [[XJXCustomItemBrowser alloc] initWithExternalParams:@{@"title" : url}];
    b.handler = handler;
    [b.webView loadRequest:[NSURLRequest requestWithURL:[url normalizeNSURL]]];
    [[XJXLinkageRouter defaultRouter].activityController presentViewController:b animated:YES completion:nil];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:WhiteColor(1, 1)];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
     [btnBack setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
     [btnBack setY:20 + (44 - btnBack.bounds.size.height) / 2.0];
     [self.navBar addSubview:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:self.externalParams[@"title"] color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter constrainSize:CGSizeMake(150, 40)];
    
    _btnAnalysis = [UIControlsUtils buttonWithTitle:@"添加" background:[Theme defaultTheme].schemeColor backroundImage:nil target:self selector:@selector(analysis:) padding:UIEdgeInsetsMake(5, 15, 5, 15) frame:CGRectZero];
    [_btnAnalysis setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    _btnAnalysis.layer.cornerRadius = 0.5 * [_btnAnalysis getH];
    
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:_btnAnalysis];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setRightBarButtonItems:@[itemEdit] animated:YES];
    [self.navBar pushNavigationItem:item animated:NO];
    [self addSubview:self.navBar];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        if(_handler){
            _handler(_analysisResult);
        }
    }];
}

- (void)initUI{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:SCRIPT_NOTI_ANALYSIS];
    [config.userContentController addUserScript:[self analysisScript]];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [self.navBar getMaxY]) configuration:config];
    _webView.navigationDelegate = self;
    [self addSubview:_webView];
}

- (WKUserScript *)analysisScript{
    NSString *script = [NSString readFromFile:@"htmlanalysisinject" type:@"js"];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    return userScript;
}

- (void)analysis:(id)sender{
    [_webView evaluateJavaScript:@"getResult();" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        NSLog(@"%@",[error description]);
    }];
}

#pragma mark - webview delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated){
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if(navigationAction.navigationType == WKNavigationTypeOther){
        if([[NSURL URLWithString:_currenUrl].host isEqualToString:navigationAction.request.URL.host]){
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        if([navigationAction.request.URL.absoluteString containsString:@"taobao"])
            _currenUrl = navigationAction.request.URL.absoluteString;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if(_currenUrl){
        NSURL *url = [_currenUrl normalizeNSURL];
        if(url){
            if(![_currenUrl isEqualToString:_webView.URL.absoluteString]){
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
        }
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([message.name isEqualToString:SCRIPT_NOTI_ANALYSIS]){
        id result = message.body;
        [XJXCustomWishItemAnalysisResultView showResultViewWithTitle:result[@"title"] desc:result[@"desc"] price:result[@"price"] imageUrl:result[@"img"] url:_webView.URL.absoluteString onAdded:^(XJXCustomWishItem *item) {
            _analysisResult = item;
            [self back:nil];
        }];
    }
}

@end
