//
//  BaseController.h
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onActionDone)();

@interface BaseController : UIViewController

@property (nonatomic,strong) NSException *exception;

@property (nonatomic,strong) id externalParams;

@property (nonatomic,strong) id data;
@property (nonatomic,strong) UINavigationBar *navBar;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,assign) BOOL isInit;

- (UIImage *)tabImage;
- (UIImage *)selectedTabImage;
- (NSString *)tabTitle;
- (void)tabbarDetect;
- (id)initWithNavigationEnabled:(BOOL)navigatable barHidden:(BOOL)hidden;
- (instancetype)initWithExternalParams:(id)params;
- (void)back:(id)sender;
- (void)setup;
- (void)loadDataWithCompletion:(onActionDone)done;
- (void)initParams;
- (void)initBG;
- (void)initNav;
- (void)initUI;
- (void)registerEvents;
- (void)registerNotifications;
- (void)onError;
- (void)onEmpty;
- (id)getValueFromParamKey:(id)key;

- (void)update;

- (void)hideTabBar:(BOOL)hide animated:(BOOL)animated;
- (void)pushController:(id)controller;

@end
