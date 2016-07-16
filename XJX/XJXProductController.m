//
//  XJXProductController.m
//  XJX
//
//  Created by Cai8 on 16/1/10.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProductController.h"
#import "ShopAPI.h"
#import "PageAPI.h"
#import "XJXSlide.h"
#import "XJXCrowdFundingToolbar.h"

#import "XJXProductActionSheet.h"

#define IMAGE_HEIGHT SCREEN_WIDTH

@interface XJXProductController ()<YSLTransitionAnimatorDataSource>

@property (nonatomic,strong) XJXProductActionSheet *actionSheet;

@end

@implementation XJXProductController{
    UIScrollView *baseView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
}

- (UIImageView *)pushTransitionImageView{
    return nil;
}

- (UIImageView *)popTransitionImageView{
    return [(XJXSlide *)[[self baseView] viewWithTag:999] coverView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    //[self.navBar setBarTintColor:WhiteColor(1, 0)];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[Utils getImageFromColor:WhiteColor(1, 0)] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    UIButton *btnCart = [UIControlsUtils buttonWithTitle:nil background:WhiteColor(1, 1) backroundImage:[UIImage imageNamed:@"购物车"] target:self selector:@selector(goCart:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    btnCart.layer.cornerRadius = 0.5 * NAVBAR_ICON_SIZE;
    UIBarButtonItem *itemCart = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
    
//
//    btnScan.layer.cornerRadius = 0.5 * NAVBAR_ICON_SIZE;
//    
//    UIButton *btnMessage = [UIControlsUtils buttonWithTitle:nil background:[Theme defaultTheme].naviButtonColor backroundImage:[UIImage imageNamed:@"message"] target:self selector:@selector(message:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
//    btnMessage.layer.cornerRadius = 0.5 * NAVBAR_ICON_SIZE;
    
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
//    UIBarButtonItem *itemScan = [[UIBarButtonItem alloc] initWithCustomView:btnScan];
//    UIBarButtonItem *itemMessage = [[UIBarButtonItem alloc] initWithCustomView:btnMessage];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setLeftBarButtonItem:itemBack];
    [item setRightBarButtonItem:itemCart];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)goCart:(id)sender{
    NSString *link = @"hnh://shopping.cart";
    [[XJXLinkageRouter defaultRouter] routeToLink:link];
}

- (void)message:(id)sender{
    
}

- (void)loadDataWithCompletion:(onActionDone)done{
    id product_id = [self getValueFromParamKey:@"product_id"];
    if(product_id){
        [ShopAPI requestProductWithId:product_id completion:^(id res, NSString *err) {
            if(!err){
                self.data = [@{@"product" : res} mutableCopy];
                [PageAPI requestPageFromUrl:PRODUCT_HTML_URL_WRAPPER(res[@"serialno"]) completion:^(id _res, NSString *_err) {
                    if(!_err){
                        [self.data setObject:_res forKey:@"html"];
                        done();
                    }
                    else{
                        [self onError];
                    }
                }];
            }
            else{
                [self onError];
            }
        }];
    }
    else{
        id product = [[[self getValueFromParamKey:@"product"] fromBase64] fromJson];
        if(product){
            self.data = [@{@"product" : product} mutableCopy];
            [PageAPI requestPageFromUrl:PRODUCT_HTML_URL_WRAPPER(product[@"serialno"]) completion:^(id _res, NSString *_err) {
                if(!_err){
                    [self.data setObject:_res forKey:@"html"];
                    done();
                }
                else{
                    NSLog(_err);
                }
            }];
        }
        else{
            [self onError];
        }
    }
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

- (void)onError{
    [[self.view viewWithTag:12] removeFromSuperview];
    UIButton *errBtn = [UIControlsUtils buttonWithTitle:@"获取商品数据失败或该商品已下架" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(setup) padding:UIEdgeInsetsMake(5, 12, 5, 12) frame:CGRectZero];
    [errBtn setX:(self.view.bounds.size.width - errBtn.bounds.size.width) / 2];
    [errBtn setY:(self.view.bounds.size.height - errBtn.bounds.size.height) / 2];
    errBtn.tag = 12;
    [self.view addSubview:errBtn];
}

- (void)initParams{
}

- (void)registerEvents{
    [[self baseView] addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        CGPoint offset = [self baseView].contentOffset;
        CGFloat threashold = 200;
        [self.navBar setBackgroundImage:[Utils getImageFromColor:WhiteColor(1, offset.y / threashold)] forBarMetrics:UIBarMetricsDefault];
        
    }
}

- (void)initUI{
    
    id product = self.data[@"product"];
    id htmlcode = self.data[@"html"];
    
    CGFloat y_offset = 0.0;
    
    XJXSlide *slide = [[XJXSlide alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT)];
    [slide loadImageFromUrl:SERVER_FILE_WRAPPER(product[@"image"][@"big_thumb_image_url"])];
    slide.tag = 999;
    [[self baseView] addSubview:slide];
    
    y_offset += slide.bounds.size.height + 8;
    
    UILabel *titleLb = [UIControlsUtils labelWithTitle:product[@"name"] color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentJustified];
    [titleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [titleLb setY:y_offset];
    [[self baseView] addSubview:titleLb];
    
    y_offset += titleLb.bounds.size.height + 8;
    
    UILabel *priceLb = [UIControlsUtils labelWithPrice:([product[@"price"] floatValue] / 100.0)];
    [priceLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [priceLb setY:y_offset];
    
    y_offset += priceLb.bounds.size.height + 24;
    
    UILabel *descLb = [UIControlsUtils labelWithTitle:product[@"desc"] color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentJustified];
    [descLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [descLb setY:y_offset];
    
    y_offset += descLb.bounds.size.height + 20;
    
    [[self baseView] addSubview:titleLb];
    [[self baseView] addSubview:priceLb];
    [[self baseView] addSubview:descLb];
    
    UIView *sectionTitle = [UIControlsUtils addSectionHeaderOnPoint:CGPointMake(0, y_offset) text:@"图文详情" onView:[self baseView]];
    
    y_offset += sectionTitle.bounds.size.height;
    
    XJXTextImageBrowser *browser = [[XJXTextImageBrowser alloc] initWithFrame:CGRectMake(0, y_offset, SCREEN_WIDTH, 0)];
    [browser setOnHeightChanged:^(XJXTextImageBrowser *sender){
        [[self baseView] setContentSize:CGSizeMake([self baseView].bounds.size.width, [browser getMaxY] + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI)];
    }];
    [browser loadHTMLContent:htmlcode autoresizing:YES];
    [[self baseView] addSubview:browser];
    
    
    //Toolbar
    XJXCrowdFundingToolbar *toolbar = [[XJXCrowdFundingToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - XJX_TOOLBAR_HEIGHT, SCREEN_WIDTH, XJX_TOOLBAR_HEIGHT)];
    [toolbar setOnFavHandler:^(){
        NSLog(@"faved");
    }];
    [toolbar setOnAppendWishlistHandler:^(){
        //NSLog(@"appended");
        if([product[@"models"] count] > 0){
            _actionSheet = [XJXProductActionSheet showWithModels:product[@"models"] title:product[@"name"] price:([product[@"price"] floatValue] / 100.0) imageUrl:SERVER_FILE_WRAPPER(product[@"image"][@"tiny_thumb_image_url"]) identifier:@"wishlist" selectedModel:nil amount:1 onSheetDone:^{
                @try {
                    id data = [_actionSheet.content getSelectedModelAndAmount];
                    [self crowdFundingWithAmount:[data[@"amount"] intValue] model:data[@"tags"]];
                }
                @catch (NSException *exception) {
                    NSLog([exception reason]);
                }
            }];
        }
    }];
    [toolbar setOnBuyHandler:^(){
        //NSLog(@"appended");
        if([product[@"models"] count] > 0){
            _actionSheet = [XJXProductActionSheet showWithModels:product[@"models"] title:product[@"name"] price:([product[@"price"] floatValue] / 100.0) imageUrl:SERVER_FILE_WRAPPER(product[@"image"][@"tiny_thumb_image_url"]) identifier:@"buy" selectedModel:nil amount:1 onSheetDone:^{
                @try {
                    id data = [_actionSheet.content getSelectedModelAndAmount];
                    [self buy:[data[@"amount"] intValue] model:data[@"tags"]];
                }
                @catch (NSException *exception) {
                    NSLog([exception reason]);
                }
            }];
        }
    }];
    [self addSubview:toolbar];
    
    [[self baseView] setContentSize:CGSizeMake(SCREEN_WIDTH, [toolbar getMaxY] + XJX_TOOLBAR_HEIGHT)];
}

- (void)crowdFundingWithAmount:(int)amount model:(NSArray *)model{
    [FundingAPI addItemToWishlistWithProductId:[self.data[@"product"][@"ID"] integerValue] amount:amount model:[model stringByJoinProperty:^NSString *(id item) {
        return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
    } delimiter:@"|"] completion:^(id res, NSString *err) {
        if(!err){
            [[NotificationView sharedView].imageView lazyWithUrl:SERVER_FILE_WRAPPER(self.data[@"product"][@"image"][@"tiny_thumb_image_url"])];
            [NotificationView sharedView].titleLabel.text = [NSString stringWithFormat:@"%@ 已添加至心愿单",self.data[@"product"][@"name"]];
            [[NotificationView sharedView] show];
            
            [NotificationRegistrator callNoti:NOTI_WISH_NEED_UPDATE object:nil];
        }
        else{
            
        }
        [_actionSheet close];
    }];
}

- (void)buy:(int)amount model:(NSArray *)model{
    [ShopAPI addItemToCartWithProductId:[self.data[@"product"][@"ID"] integerValue] amount:amount model:[model stringByJoinProperty:^NSString *(id item) {
        return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
    } delimiter:@"|"] completion:^(id res, NSString *err) {
        if(!err){
            [[NotificationView sharedView].imageView lazyWithUrl:SERVER_FILE_WRAPPER(self.data[@"product"][@"image"][@"tiny_thumb_image_url"])];
            [NotificationView sharedView].titleLabel.text = [NSString stringWithFormat:@"%@ 已添加至购物车",self.data[@"product"][@"name"]];
            [[NotificationView sharedView] show];
            
            [NotificationRegistrator callNoti:NOTI_CART_NEED_UPDATE object:nil];
        }
        else{
            
        }
        [_actionSheet close];
    }];
}

- (void)dealloc{
    self.actionSheet = nil;
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
