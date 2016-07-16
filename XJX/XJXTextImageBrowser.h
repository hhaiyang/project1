//
//  XJXTextImageBrowser.h
//  XJX
//
//  Created by Cai8 on 16/1/11.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Webkit/Webkit.h>

typedef void (^onScrollingHeightChanged)(id sender);

@interface XJXTextImageBrowser : UIView

- (void)loadHTMLContent:(NSString *)htmlContent autoresizing:(BOOL)autoresizing;
- (void)loadUrl:(NSURL *)url autoresizing:(BOOL)autoresizing;

@property (nonatomic,copy) onScrollingHeightChanged onHeightChanged;

@end
