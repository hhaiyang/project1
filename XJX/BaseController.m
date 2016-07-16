//
//  BaseController.m
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import "BaseController.h"

#import "XJXStoreController.h"

@interface BaseController()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseController

- (id)initWithNavigationEnabled:(BOOL)navigatable barHidden:(BOOL)hidden{
    id controller;
    if(navigatable){
        id vc = [self initWithoutSetup];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        navi.navigationBarHidden = hidden;
        navi.delegate = self;
        controller = navi;
    }
    else{
        controller = [self initWithoutSetup];
    }
    return controller;
}

- (instancetype)init{
    if(self){
        self.isInit = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.tabBarItem.image = [self tabImage];
        self.tabBarItem.selectedImage = [self selectedTabImage];
        self.tabBarItem.title = [self tabTitle];
        [self setup];
    }
    return self;
}

- (instancetype)initWithoutSetup{
    if(self){
        self.isInit = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.tabBarItem.image = [self tabImage];
        self.tabBarItem.selectedImage = [self selectedTabImage];
        self.tabBarItem.title = [self tabTitle];
    }
    return self;
}

- (instancetype)initWithExternalParams:(id)params{
    if(self = [super init]){
        self.isInit = NO;
        self.view.bounds = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor whiteColor];
        self.externalParams = params;
        [self setup];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}
- (UIImage *)tabImage{return nil;}
- (UIImage *)selectedTabImage{return nil;}
- (NSString *)tabTitle{return @"";}

- (void)back:(id)sender{
    BaseController *vc = [self.navigationController viewControllers][MAX(0, [self.navigationController viewControllers].count - 2)];
    [self.navigationController popViewControllerAnimated:YES];
    [self tabbarDetect:[vc class]];
}

- (void)viewWillAppear:(BOOL)animated{
    [XJXLinkageRouter defaultRouter].activityController = self;
    if(self.isInit){
        [self update];
    }
}

- (void)tabbarDetect:(Class)controllerClass{
    NSUInteger index = [self.tabBarController.viewControllers indexOfObjectPassingTest:^BOOL(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [[(UINavigationController *)obj viewControllers][0] class] == [controllerClass class];
    }];
    if(index != NSNotFound){
        NSLog(@"called");
        [self hideTabBar:NO animated:YES];
    }
    else{
        [self hideTabBar:YES animated:YES];
    }
}

#pragma mark - navigationController delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(BaseController *)viewController animated:(BOOL)animated{
    if(viewController.hidesBottomBarWhenPushed){
        [self hideTabBar:YES animated:YES];
    }
    else{
        [self hideTabBar:NO animated:YES];
    }
}

- (void)pushController:(id)controller{
    [controller setHidesBottomBarWhenPushed:YES];
    [[XJXLinkageRouter defaultRouter].activityController.navigationController pushViewController:controller animated:YES];
}

- (void)hideTabBar:(BOOL)hide animated:(BOOL)animated{
    if(!animated){
        self.tabBarController.tabBar.hidden = hide;
    }
    else{
        [UIView animateWithDuration:.3 animations:^{
            if(hide){
                [self.tabBarController.tabBar setY:SCREEN_HEIGHT];
                [Utils printFrame:self.tabBarController.view.frame];
            }
            else
                [self.tabBarController.tabBar setY:SCREEN_HEIGHT - self.tabBarController.tabBar.bounds.size.height];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setup{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    @try {
        [self initBG];
        if(!self.navBar)
            [self initNav];
        [self loadDataWithCompletion:^{
            [self initParams];
            [self initUI];
            [self registerEvents];
            [self registerNotifications];
            [self setIsInit:YES];
        }];
    }
    @catch (NSException *exception) {
        _exception = exception;
        [self onError];
    }
}
- (void)loadDataWithCompletion:(onActionDone)done{ done(); }
- (void)initParams{}
- (void)initNav{}
- (void)initBG{}
- (void)initUI{}
- (void)registerEvents{}
- (void)onError{}
- (void)registerNotifications{}
- (id)getValueFromParamKey:(id)key{
    if(self.externalParams){
        return self.externalParams[key];
    }
    return nil;
}

- (void)update{}

- (void)onEmpty{}

- (void)viewDidLoad{
    self.data = [NSMutableDictionary dictionary];
}

- (void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
    if(self.navigationController.viewControllers.count > 1 && self.navBar){
        UIButton *btnBack = [UIControlsUtils buttonWithTitle:@"" background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
        
        UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        
        [self.navBar.items[0] setLeftBarButtonItem:itemBack animated:YES];
    }
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
