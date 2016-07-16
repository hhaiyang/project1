//
//  XJXArticleController.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXArticleController.h"

@implementation XJXArticleController
{
    UIScrollView *baseView;
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
    
    UIButton *btnFav = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"collect"] target:self selector:@selector(fav:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIButton *btnShare = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"share"] target:self selector:@selector(share:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"专题详情" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *itemFav = [[UIBarButtonItem alloc] initWithCustomView:btnFav];
    UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.externalParams[@"title"]];
    [item setTitleView:naviTitleLb];
    [item setRightBarButtonItems:@[itemShare,itemFav]];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)share:(id)sender{
    
}

- (void)fav:(id)sender{
    
}

- (UIScrollView *)baseView{
    if(!baseView){
        baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        if(self.navBar)
            [self.view insertSubview:baseView belowSubview:self.navBar];
        else{
            [self.view addSubview:baseView];
        }
    }
    return baseView;
}

- (void)loadDataWithCompletion:(onActionDone)done{
    id article = [self getValueFromParamKey:@"article"];
    if(!article){
        id article_id = [self getValueFromParamKey:@"article_id"];
        if(article_id){
            
        }
        else{
            [self onError];
        }
    }
    else{
        @try {
            article = [[article fromBase64] fromJson];
            [PageAPI requestPageFromUrl:ARTICLE_HTML_URL_WRAPPER(article[@"serialno"]) completion:^(id _res, NSString *_err) {
                if(!_err){
                    [self.data setObject:_res forKey:@"html"];
                    done();
                }
                else{
                    NSLog(_err);
                }
            }];
        }
        @catch (NSException *exception) {
            [self onError];
        }
    }
}

- (void)initParams{
    
}

- (void)initUI{
    NSString *html = self.data[@"html"];
    XJXTextImageBrowser *browser = [[XJXTextImageBrowser alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [self.navBar getMaxY])];
    
    [browser loadHTMLContent:html autoresizing:NO];
    [[self baseView] addSubview:browser];
}

@end
