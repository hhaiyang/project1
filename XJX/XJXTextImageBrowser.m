//
//  XJXTextImageBrowser.m
//  XJX
//
//  Created by Cai8 on 16/1/11.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTextImageBrowser.h"

@interface XJXTextImageBrowser()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,assign) BOOL autoresizing;

@end

@implementation XJXTextImageBrowser

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    self.webview.frame = self.bounds;
    if(_onHeightChanged){
        _onHeightChanged(self);
    }
}

- (void)setup{
    [self initParams];
}

- (void)initParams{
    _autoresizing = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"scrolling"];
    _webview = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    _webview.navigationDelegate = self;
    
    [self addSubview:_webview];
    
    UILabel *loadingIndicator = [UIControlsUtils labelWithTitle:@"正在加载图文消息..." color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentCenter];
    [loadingIndicator setX:(self.bounds.size.width - loadingIndicator.bounds.size.width) / 2];
    loadingIndicator.tag = 888;
    [self addSubview:loadingIndicator];
}

- (void)loadHTMLContent:(NSString *)htmlContent autoresizing:(BOOL)autoresizing{
    _autoresizing = autoresizing;
    
    [_webview loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
}

- (void)loadUrl:(NSURL *)url autoresizing:(BOOL)autoresizing{
    _autoresizing = autoresizing;
    
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - delegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog([error description]);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if([webView showBigImage:navigationAction.request]){
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated){
        NSString *url = navigationAction.request.URL.absoluteString;
        [[XJXLinkageRouter defaultRouter] routeToLink:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [[self viewWithTag:888] removeFromSuperview];
    [webView getImageUrlByJS:webView];
    if(_autoresizing){
        [webView evaluateJavaScript:@"GetContentHeight();" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
            if(!error){
                
            }
            else{
                NSLog([error description]);
            }
        }];
        
        //[self setH:webView.scrollView.contentSize.height];
    }
}

#pragma mark - javascript 
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    id msg = message.body;
    CGFloat height = [msg[@"scrollingHeight"] floatValue];
    [self setH:height + XJX_TOOLBAR_HEIGHT];
}

@end
