//
//  AppDelegate.m
//  XJX
//
//  Created by Cai8 on 15/11/18.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import "AppDelegate.h"


#import "XJXShoppingCartController.h"
#import "XJXWishlistController.h"
#import "XJXProductCollectionController.h"

#import "XJXArticleController.h"
#import "XJXProductController.h"

#import "XJXComfirmOrderController.h"

#import "XJXMyOrderController.h"
#import "ViewController.h"

@interface AppDelegate ()<PushManagerDelegate>{
    ViewController *controller;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    controller = [[ViewController alloc] initWithNavigationEnabled:YES barHidden:YES];
    
    [self initWechat];
    [self initRouter];
    
    [PushManager sharedManager].delegate = self;
    [[PushManager sharedManager] prepareWithAppLaunchingOptions:launchOptions];
    
    [CIA initWithAppId:@"b29860b3cec049baa7507a1f038981f5" authKey:@"9544769892b54f0f851f2f035caac48e"];
    
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initWechat{
    [[WechatAgent defaultAgent] setOnWechatLogined:^(SendAuthResp *wechatResp){
        [NotificationRegistrator callNoti:NOTI_ON_WX_AUTH_SUCCESS object:wechatResp];
    }];
    
    [[WechatAgent defaultAgent] setOnWechatShared:^(WechatShareContent *content, NSString *err){
        NSLog(@"shared");
    }];
}

- (void)initRouter{
  
    [[XJXLinkageRouter defaultRouter] registerRoute:@"cart" pattern:@"hnh://shopping.cart" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXShoppingCartController *vc = [[XJXShoppingCartController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"wishlist" pattern:@"hnh://shopping.wishlist" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXWishlistController *vc = [[XJXWishlistController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"product" pattern:@"hnh://product?{params}" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXProductController *vc = [[XJXProductController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"productsInCategory" pattern:@"hnh://category?{params}" onMatched:^(NSString *routePageName, NSDictionary *state) {
        NSLog(@"routePage : %@",routePageName);
        id loader = ^(int page, int pageSize, onDataRecved recvHandler) {
            NSLog(@"loading");
            [ProductAPI requestProductsInCategory:[state[@"category_id"] intValue] page:page pageSize:pageSize completion:^(id res, NSString *err) {
                recvHandler(res,err);
            }];
        };
        id clickEvent = ^(id item){
            NSString *url = [NSString stringWithFormat:@"hnh://product?product=%@",[[item toJson] toBase64]];
            [[XJXLinkageRouter defaultRouter] routeToLink:url];
        };
        XJXProductCollectionController *vc = [[XJXProductCollectionController alloc] initWithExternalParams:@{@"dataLoader" : loader,@"clickHandler" : clickEvent,@"title" : state[@"category_name"]}];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"article" pattern:@"hnh://article?{params}" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXArticleController *vc = [[XJXArticleController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"comfirmOrder" pattern:@"hnh://order.comfirm?{params}" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXComfirmOrderController *vc = [[XJXComfirmOrderController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] registerRoute:@"myOrder" pattern:@"hnh://order.me?{params}" onMatched:^(NSString *routePageName, NSDictionary *state) {
        XJXMyOrderController *vc = [[XJXMyOrderController alloc] initWithExternalParams:state];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }];
    
    [[XJXLinkageRouter defaultRouter] onDefaultRouteMatched:^(XJXURL *link) {
        XJXWebBrowser *browser = [XJXWebBrowser browserWithRedirectUrl:link.absoluteURL];
        [[XJXLinkageRouter defaultRouter].activityController pushController:browser];
    }];
}

#pragma mark - pushing 
- (void)onRemoteMessageReceived:(NSString *)message{
    //[Utils showAlert:message title:@"In App 推送消息"];
    [NotificationView sharedView].titleLabel.text = [NSString stringWithFormat:@"推送通知 : %@",message];
    [NotificationView sharedView].imageView.image = [UIImage imageNamed:@"message"];
    [[NotificationView sharedView] show];
}

#pragma mark - notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[PushManager sharedManager] receiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[PushManager sharedManager] receiveRemoteNotification:userInfo backgroundFetch:completionHandler];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[PushManager sharedManager] registerDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[WechatAgent defaultAgent] handleOpenUrl:url];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    return [[WechatAgent defaultAgent] handleOpenUrl:url];
}

@end
