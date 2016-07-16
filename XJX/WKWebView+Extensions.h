//
//  WKWebView+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/2/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Extensions)

-(BOOL)showBigImage:(NSURLRequest *)request;
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView;

@end
