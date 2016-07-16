//
//  ViewController.m
//  XJX
//
//  Created by Cai8 on 15/11/18.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import "ViewController.h"

#import "XJXReservationPortalController.h"
#import "XJXStoreController.h"
#import "XJXWishlistController.h"
#import "XJXProfileConrtoller.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

@interface ViewController ()<UITabBarControllerDelegate> {
    UITabBarController *controller;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    if(!self.isInit){
        [[Session current] autoLoginWithCompletion:^(NSString *err) {
            if(!err){
                [self go];
            }
            else{
                [Utils showAlert:@"登录失败" title:@"警告"];
            }
        }];
    }
}

- (void)go{
    controller = [[UITabBarController alloc] init];
    controller.viewControllers = [self layoutControllers];
    [self customize];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)customize{
    id attributes = @{
                      NSForegroundColorAttributeName : [Theme defaultTheme].titleColor,
                      NSFontAttributeName : [Theme defaultTheme].subTitleFont
                      };
    id attributeSelected = @{
                             NSForegroundColorAttributeName : [Theme defaultTheme].highlightTextColor,
                             NSFontAttributeName : [Theme defaultTheme].subTitleFont
                             };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributeSelected forState:UIControlStateHighlighted];
    
    controller.view.backgroundColor = WhiteColor(1, 1);
    controller.tabBar.tintColor = [Theme defaultTheme].highlightTextColor;
    controller.delegate = self;
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
}

- (NSArray *)layoutControllers{
    NSMutableArray *controllers = [NSMutableArray array];
    id c1 = [[XJXReservationPortalController alloc] initWithNavigationEnabled:YES barHidden:YES];
    id c2 = [[XJXWishlistController alloc] initWithNavigationEnabled:YES barHidden:YES];
    id c3 = [[XJXStoreController alloc] initWithNavigationEnabled:YES barHidden:YES];
    id c4 = [[XJXProfileConrtoller alloc] initWithNavigationEnabled:YES barHidden:YES];
    [controllers addObject:c1];
    [controllers addObject:c2];
    [controllers addObject:c3];
    [controllers addObject:c4];
    
    [[c1 viewControllers][0] setup];
    
    return controllers;
}

#pragma mark - tabbar delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController{
    BaseController *vc = viewController.viewControllers[0];
    if(!vc.isInit){
        [vc setup];
    }
    else{
        [vc update];
    }
}
- (void)didSelectViewController:(BaseController *)viewController{
    if(!viewController.isInit){
        [viewController setup];
    }
    else{
        [viewController update];
    }
}

@end
