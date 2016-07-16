//
//  XJXMyOrderController.m
//  XJX
//
//  Created by Cai8 on 16/1/30.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMyOrderController.h"
#import "XJXTopMenuBar.h"
#import "XJXShoppingCard.h"
#import "XJXPlatformCardHeader.h"
#import "XJXOrderDetailController.h"
#import "XJXComfirmOrderController.h"

@interface XJXMyOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) XJXTopMenuBar *menuBar;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LMPullToBounceWrapper *pullToRefreshWrapper;

@end

@implementation XJXMyOrderController{
    int page;
    int pageSize;
    BOOL noMoreData;
    NSString *status;
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
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY] - 1, SCREEN_WIDTH, 1)];
    borderView.backgroundColor = WhiteColor(0, .07);
    [self.navBar addSubview:borderView];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"我的订单" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    status = @"all";
    done();
}

- (void)load:(BOOL)reload completion:(void (^)(id res,NSString *err))handler{
    if(reload){
        page = 0;
        pageSize = 20;
        noMoreData = NO;
        [self.data removeAllObjects];
        
        [[self.view viewWithTag:999] removeFromSuperview];
    }
    [OrderAPI requestMyOrdersWithStatus:status page:page pageSize:pageSize completion:^(id res, NSString *err) {
        if(!err){
            NSMutableArray *data = self.data[@"data"];
            if(!data){
                data = [NSMutableArray arrayWithArray:res];
                [self.data setObject:data forKey:@"data"];
            }
            else
                [data addObjectsFromArray:res];
            if([res count] < pageSize){
                noMoreData = YES;
            }
            
            [self prepareData:res];
            
            page++;
            if(handler){
                handler(res,nil);
            }
        }
        else{
            if(handler){
                handler(nil,err);
            }
        }
    }];
}

- (void)prepareData:(NSArray *)data{
    if(![status isEqualToString:@"not_paid"]){
        NSMutableArray *orders = self.data[@"orders"];
        if(!orders){
            orders = [NSMutableArray array];
        }
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                XJXOrder *order = [[XJXOrder alloc] init];
                order.ID = [obj[@"ID"] integerValue];
                order.paid = [obj[@"paid"] boolValue];
                order.serialno = obj[@"serialno"];
                order.custom_need = obj[@"custom_needs"];
                order.shipping = obj[@"shipping"];
                order.item = _obj;
                [orders addObject:order];
            }];
        }];
        [self.data setObject:orders forKey:@"orders"];
    }
}

- (void)loadMore{
    [self load:NO completion:^(id res, NSString *err) {
        if(!err){
            [_tableView reloadData];
        }
        else{
            [Utils showAlert:err title:@"警告"];
        }
    }];
}

- (void)initParams{
    id tabindex = [self getValueFromParamKey:@"tabindex"];
    if(!tabindex){
        tabindex = @(0);
    }
    [self.data setObject:tabindex forKey:@"tabindex"];
}

- (void)initUI{
    [self initTopbar];
    [self initTB];
    
    self.view.backgroundColor = WhiteColor(1, 1);
}

- (void)initTopbar{
    WS(_self);
    _menuBar = [[XJXTopMenuBar alloc] initWithMenuItems:@[@"已付款",@"待付款",@"待发货",@"待收货"] startIndex:[self.data[@"tabindex"] intValue]];
    [_menuBar setY:[self.navBar getMaxY]];
    [_menuBar setOnSelectHandler:^(NSUInteger index){
        switch (index) {
            case 0:
                status = @"all";
                break;
            case 1:
                status = @"not_paid";
                break;
            case 2:
                status = @"pending_shipping";
                break;
            case 3:
                status = @"pending_recv";
                break;
            default:
                status = @"all";
                break;
        }
        [_self load:YES completion:^(id res, NSString *err) {
            if(!err){
                [_self.tableView reloadData];
                
                [_self emptyDetect];
            }
            else{
                [Utils showAlert:err title:@"警告"];
            }
        }];
    }];
    [self addSubview:_menuBar];
}

- (void)initTB{
    WS(_self);
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, [_menuBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [_menuBar getMaxY])];
    _tableView = [[UITableView alloc] initWithFrame:container.bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXShoppingCard class] forCellReuseIdentifier:NSStringFromClass([XJXShoppingCard class])];
    [_tableView registerClass:[XJXPlatformCardHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XJXPlatformCardHeader class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _pullToRefreshWrapper = [[LMPullToBounceWrapper alloc] initWithScrollView:_tableView];
    _pullToRefreshWrapper.backgroundColor = container.backgroundColor = _tableView.backgroundColor = WhiteColor(.95, 1);
    
    [container addSubview:_pullToRefreshWrapper];
    
    [_pullToRefreshWrapper setDidPullTorefresh:^(){
        [_self reload];
    }];
    
    [self addSubview:container];
}

- (void)reload{
    WS(_self);
    [_self load:YES completion:^(id res, NSString *err) {
        [_self.tableView reloadData];
        [_self.pullToRefreshWrapper stopLoadingAnimation];
        
        [self emptyDetect];
    }];
}

- (void)emptyDetect{
    if([self.data[@"data"] count] == 0){
        [self onEmpty];
        return;
    }
}

- (void)onEmpty{
    UIImageView *emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [emptyImage setContentMode:UIViewContentModeScaleAspectFit];
    [emptyImage setImage:[UIImage imageNamed:@"order_empty"]];
    [emptyImage verticalCenteredOnView:self.view];
    [emptyImage horizontalCenteredOnView:self.view];
    emptyImage.tag = 999;
    [self addSubview:emptyImage];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([status isEqualToString:@"not_paid"]){
        return [self.data[@"data"] count];
    }
    else{
        return [self.data[@"orders"] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([status isEqualToString:@"not_paid"]){
        return [self.data[@"data"][section][@"items"] count];
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXShoppingCard *card = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXShoppingCard class]) forIndexPath:indexPath];
    card.selectedBackgroundView = nil;
    card.selectionStyle = UITableViewCellSelectionStyleNone;
    card.checkable = NO;
    id item;
    if([status isEqualToString:@"not_paid"]){
        item = self.data[@"data"][indexPath.section][@"items"][indexPath.row];
    }
    else{
        XJXOrder *order = self.data[@"orders"][indexPath.section];
        item = order.item;
    }
    card.price = [item[@"product"][@"price"] floatValue] / 100;
    card.title = item[@"product"][@"name"];
    card.model = [item[@"model"] stringByJoinProperty:^NSString *(id item) {
        return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
    } delimiter:@";"];
    card.amount = [item[@"amount"] intValue];
    card.image_url = SERVER_FILE_WRAPPER(item[@"product"][@"image"][@"tiny_thumb_image_url"]);
    return card;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.data[@"orders"] count] > 0 || [status isEqualToString:@"not_paid"])
        return 50;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([status isEqualToString:@"not_paid"])
        return 50;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([status isEqualToString:@"not_paid"]){
        XJXPlatformCardHeader *view = (XJXPlatformCardHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XJXPlatformCardHeader class])];
        view.checkable = NO;
        view.platform_name = [NSString stringWithFormat:@"订单号 : %@",self.data[@"data"][section][@"serialno"]];
        view.logo_url = nil;
        view.section = section;
        
        [view setActionButtonWithTitle:@"取消" action:^(XJXPlatformCardHeader *header) {
            [Utils comfirmWithPromt:@"是否取消订单" title:@"喜加喜" comfirm:^{
                NSUInteger _section = header.section;
                id serial = self.data[@"data"][_section][@"serialno"];
                [OrderAPI cancelOrderWithSerial:serial completion:^(id res, NSString *err) {
                    if(!err){
                        [NotificationView sharedView].imageView.image = [UIImage imageNamed:@"message"];
                        [NotificationView sharedView].titleLabel.text = @"订单已取消";
                        [[NotificationView sharedView] show];
                        [self reload];
                        
                        [NotificationRegistrator callNoti:NOTI_CART_NEED_UPDATE object:nil];
                    }
                    else{
                        NSLog(err);
                        [Utils showAlert:err title:@"警告"];
                    }
                }];
            }];
        }];
        [view layout];
        return view;
    }
    else{
        if([self.data[@"orders"] count] > 0){
            XJXOrder *order = self.data[@"orders"][section];
            XJXPlatformCardHeader *view = (XJXPlatformCardHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XJXPlatformCardHeader class])];
            view.checkable = NO;
            view.platform_name = order.item[@"product"][@"platform"][@"name"];
            view.logo_url = order.item[@"product"][@"platform"][@"logo_url"];
            view.desc = [self statusOfOrder:order];
            [view layout];
            
            return view;
        }
        else{
            return nil;
        }
    }

    return nil;
}

- (CGFloat)totalPriceOfOrder:(id)order{
    __block CGFloat price = 0.0;
    [order[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += [obj[@"amount"] intValue] * [obj[@"product"][@"price"] floatValue];
    }];
    if([order[@"coupon"][@"ID"] intValue] != -1){
        price -= [order[@"coupon"][@"money"] floatValue];
    }
    return price;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([status isEqualToString:@"not_paid"]){
        NSString *priceStr = [NSString stringWithFormat:@"%.2lf",[self totalPriceOfOrder:self.data[@"data"][section]] / 100];
        
         XJXPlatformCardHeader *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XJXPlatformCardHeader class])];
        footer.logo_url = nil;
        footer.platform_name = @"订单总价: ";
        footer.desc = [priceStr priceFormatAttributeWithFont:[Theme defaultTheme].subTitleFont symbolFont:[Theme defaultTheme].emFont color:[Theme defaultTheme].highlightTextColor];
        return footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![status isEqualToString:@"not_paid"]){
        XJXOrder *order = self.data[@"orders"][indexPath.section];
        XJXOrderDetailController *vc = [[XJXOrderDetailController alloc] initWithOrder:order];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        id order = self.data[@"data"][indexPath.section];
        XJXComfirmOrderController *vc = [[XJXComfirmOrderController alloc] initWithExternalParams:@{@"order" : order}];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSAttributedString *)statusOfOrder:(XJXOrder *)order{
    id attribute = @{
                     NSForegroundColorAttributeName : [Theme defaultTheme].highlightTextColor,
                     NSFontAttributeName : [Theme defaultTheme].subTitleFont
                     };
    if(!order.paid){
        return [[NSAttributedString alloc] initWithString:@"用户未支付" attributes:attribute];
    }
    else{
        id shipping_info = order.item[@"shipping_info"];
        if([shipping_info[@"ID"] intValue] == -1){
            return [[NSAttributedString alloc] initWithString:@"等待发货" attributes:attribute];
        }
        else{
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"已发货 - 快递号: %@",shipping_info[@"shipping_no"]] attributes:attribute];
        }
    }
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
