//
//  XJXOrderDetailController.m
//  XJX
//
//  Created by Cai8 on 16/2/9.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXOrderDetailController.h"
#import "XJXShippingCell.h"
#import "XJXShoppingCard.h"
#import "XJXOrderHeaderView.h"

@interface XJXOrderDetailController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) XJXOrder *order;

@property (nonatomic,copy) NSString *currentShippingStatus;

@end

@implementation XJXOrderDetailController

- (instancetype)initWithOrder:(XJXOrder *)order{
    if(self = [super init]){
        self.order = order;
    }
    return self;
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

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXShoppingCard class] forCellReuseIdentifier:NSStringFromClass([XJXShoppingCard class])];
    [_tableView registerClass:[XJXShippingCell class] forCellReuseIdentifier:NSStringFromClass([XJXShippingCell class])];
    [_tableView registerClass:[XJXOrderHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XJXOrderHeaderView class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXOrder *order = self.order;
    if(indexPath.section == 1){
        XJXShoppingCard *card = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXShoppingCard class]) forIndexPath:indexPath];
        card.selectedBackgroundView = nil;
        card.selectionStyle = UITableViewCellSelectionStyleNone;
        card.checkable = NO;
        card.price = [order.item[@"product"][@"price"] floatValue];
        card.title = order.item[@"product"][@"name"];
        card.model = [order.item[@"model"] stringByJoinProperty:^NSString *(id item) {
            return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
        } delimiter:@";"];
        card.amount = [order.item[@"amount"] intValue];
        card.image_url = SERVER_FILE_WRAPPER(order.item[@"product"][@"image"][@"tiny_thumb_image_url"]);
        return card;
    }
    else if(indexPath.section == 0){
        XJXShippingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXShippingCell class]) forIndexPath:indexPath];
        cell.isEmpty = NO;
        cell.needBG = NO;
        cell.tele = order.shipping[@"tele"];
        cell.name = order.shipping[@"name"];
        cell.address = order.shipping[@"address"];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 60;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1)
        return 140;
    else
        return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        XJXOrder *order = self.order;
        XJXOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XJXOrderHeaderView class])];
        headerView.order_status = [self statusOfOrder:order];
        if(!_currentShippingStatus){
            headerView.shipping_status = [self shippingOrder:order];
        }
        else{
            headerView.shipping_status = _currentShippingStatus;
        }
        
        return headerView;
    }
    return nil;
}

- (NSString *)shippingOrder:(XJXOrder *)order{
    if(!order.paid){
        return @"等待用户支付";
    }
    else{
        id shipping_info = order.item[@"shipping_info"];
        if([shipping_info[@"ID"] intValue] == -1){
            return @"等待商家发货";
        }
        else{
            [self loadShipping:shipping_info[@"shipping_no"] platform:shipping_info[@"shipping_platform"]];
            return @"加载快递信息...";
        }
    }
}

- (void)loadShipping:(NSString *)no platform:(NSString *)platform{
    [ShippingAPI requestShippingInfoWithShippingNo:no completion:^(id res, NSString *err) {
        if(!err){
            _currentShippingStatus = res[0][@"context"];
            XJXOrderHeaderView *header = [_tableView headerViewForSection:0];
            if(header){
                header.shipping_status = _currentShippingStatus;
            }
        }
        else{
            [Utils showAlert:err title:@"警告"];
        }
    }];
}

- (NSAttributedString *)statusOfOrder:(XJXOrder *)order{
    id attribute = @{
                     NSForegroundColorAttributeName : [Theme defaultTheme].highlightTextColor,
                     NSFontAttributeName : [Theme defaultTheme].subTitleFont
                     };
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@-%lu",order.serialno,[order.item[@"product"][@"ID"] integerValue]] attributes:attribute];
    
}
@end
