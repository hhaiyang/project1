//
//  XJXComfirmOrderController.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXComfirmOrderController.h"

#import "XJXShippingCell.h"
#import "XJXShoppingCard.h"
#import "XJXLabelCell.h"
#import "XJXTextFieldCell.h"
#import "XJXCreditCell.h"
#import "XJXSwitcherCell.h"
#import "XJXPlatformCardHeader.h"
#import "XJXConfirmOrderToolbar.h"
#import "XJXShippingEditController.h"
#import "XJXShippingPickerController.h"

#define CELL_SHIPPING_ADDR_ID @"shipping_cell"
#define CELL_ID @"cellid"
#define CELL_EXTRA_LB @"extra_cell_lb"
#define CELL_EXTRA_FIELD @"extra_cell_field"
#define CELL_CREDIT @"credit_cell"
#define CELL_SWITCHER @"switcher_cell"

@interface XJXComfirmOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) XJXConfirmOrderToolbar *toolbar;

@property (nonatomic,strong) NSMutableArray *creditSelection;

@end

@implementation XJXComfirmOrderController{
    NSMutableDictionary *_order;
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
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"确认订单" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    id order = [self getValueFromParamKey:@"order"];
    if(!order){
        status = @"normal";
        [OrderAPI requestOrderingInfoOnCompletion:^(id res, NSString *err) {
            if(!err){
                [self.data setObject:res[@"hasDefaultAddress"] forKey:@"hasDefaultAddress"];
                [self.data setObject:res[@"defaultAddress"] forKey:@"defaultAddress"];
                [self.data setObject:res[@"credits"] forKey:@"credits"];
                [self.data setObject:res[@"moneybag"] forKey:@"moneybag"];
                
                done();
            }
            else{
                [self onError];
            }
        }];
    }
    else{
        status = @"reorder";
        [self.data setObject:order forKey:@"order"];
        done();
    }
}

- (void)initShippingInfo{
    if([self.data[@"hasDefaultAddress"] boolValue]){
        [_order setObject:self.data[@"defaultAddress"][@"ID"] forKey:@"shipping_id"];
    }
}

- (void)initParams{
    if([status isEqualToString:@"normal"]){
        _order = [NSMutableDictionary dictionary];
        _creditSelection = [NSMutableArray array];
        
        [_order setObject:@"" forKey:@"custom_need"];
        [_order setObject:@(NO) forKey:@"using_moneybag"];
        
        [self initShippingInfo];
        
        [self.data[@"credits"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_creditSelection addObject:@(NO)];
        }];
        
        id items = [[[self getValueFromParamKey:@"orderitems"] fromBase64] fromJson];
        if(items){
            [self.data setObject:items forKey:@"sections"];
        }
        else{
            @throw [NSException exceptionWithName:@"InvalidOrderParams" reason:@"参数非法" userInfo:nil];
        }
    }
    else{
        id order = self.data[@"order"];
        NSMutableArray *sections = [NSMutableArray array];
        [order[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [sections indexOfObjectPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                return [_obj[@"platform"] isEqualToString:obj[@"product"][@"platform"][@"name"]];
            }];
            if(index != NSNotFound){
                [sections[index][@"items"] addObject:obj];
            }
            else{
                id dic = [@{
                            @"platform" : obj[@"product"][@"platform"][@"name"],
                            @"platform_logo_url" : obj[@"product"][@"platform"][@"logo_url"],
                            @"items" : [@[obj] mutableCopy]
                                } mutableCopy];
                [sections addObject:dic];
            }
        }];
        [self.data setObject:sections forKey:@"sections"];
    }
}

- (void)initUI{
    WS(_self);
    _toolbar = [[XJXConfirmOrderToolbar alloc] initWithFrame:CGRectMake(0, [self.view getH] - 50, SCREEN_WIDTH, 50)];
    _toolbar.onOrderHandler = ^(){
        [_self order];
    };
    _toolbar.totalPrice = [self getTotalPrice] / 100.0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY],SCREEN_WIDTH, [self.view getH] -  [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXShippingCell class] forCellReuseIdentifier:CELL_SHIPPING_ADDR_ID];
    [_tableView registerClass:[XJXShoppingCard class] forCellReuseIdentifier:CELL_ID];
    [_tableView registerClass:[XJXLabelCell class] forCellReuseIdentifier:CELL_EXTRA_LB];
    [_tableView registerClass:[XJXTextFieldCell class] forCellReuseIdentifier:CELL_EXTRA_FIELD];
    [_tableView registerClass:[XJXCreditCell class] forCellReuseIdentifier:CELL_CREDIT];
    [_tableView registerClass:[XJXSwitcherCell class] forCellReuseIdentifier:CELL_SWITCHER];
    [_tableView registerClass:[XJXPlatformCardHeader class] forHeaderFooterViewReuseIdentifier:@"header"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_tableView];
    [self addSubview:_toolbar];
    [_tableView setContentSize:CGSizeMake(SCREEN_WIDTH, _tableView.contentSize.height + [_toolbar getH])];
}

- (void)order{
    NSString *desc = [NSString stringWithFormat:@"%@ 的购物订单",[Session current].wechat_name];
    CGFloat price = [self getTotalPrice];
    
    if([status isEqualToString:@"normal"]){
        
        id orderSerial = self.data[@"order_serial"];
        if(orderSerial){
            [self payWithMoney:price description:desc];
            return;
        }
        
        NSMutableArray *cart_ids = [NSMutableArray array];
        [self.data[@"sections"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *items = obj[@"items"];
            for(id item in items){
                [cart_ids addObject:item[@"ID"]];
            }
        }];
        if(cart_ids.count == 0){
            [Utils showAlert:@"参数错误" title:@"警告"];
            return;
        }
        [_order setObject:cart_ids forKey:@"cart_ids"];
        
        NSUInteger index = [_creditSelection indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj boolValue];
        }];
        if(index != NSNotFound){
            [_order setObject:self.data[@"credits"][index][@"ID"] forKey:@"coupon_id"];
        }
        else{
            [_order setObject:@"-1" forKey:@"coupon_id"];
        }
        [_order setObject:@([Session current].ID) forKey:@"requester"];
        [OrderAPI addOrder:_order completion:^(id res, NSString *err) {
            if(!err){
                [NotificationRegistrator callNoti:NOTI_CART_NEED_UPDATE object:nil];
                
                [self.data setObject:res[@"serialno"] forKey:@"order_serial"];
                int cash_pay_amount = [res[@"cash_pay_amount"] intValue];
                [self payWithMoney:cash_pay_amount description:desc];
            }
            else{
                NSLog(err);
            }
        }];
    }
    else{
        id order = self.data[@"order"];
        [self.data setObject:order[@"serialno"] forKey:@"order_serial"];
        [self payWithMoney:price description:desc];
    }
}

- (void)payWithMoney:(int)money description:(NSString *)desc{
    NSString *trade_no = self.data[@"order_serial"];
    if(trade_no){
        [[WechatAgent defaultAgent] payWithMoney:money trade_no:trade_no behavior:@"shop" desc:desc completion:^(NSString *errMsg,BOOL canceled) {
            if(!errMsg){
                [NSTimer schedule:2 handler:^(CFRunLoopTimerRef ref) {
                    NSString *link_myorder = @"hnh://order.me";
                    [[XJXLinkageRouter defaultRouter] routeToLink:link_myorder];
                    [Utils showAlert:@"支付成功" title:@"信息"];
                }];
            }
            else{
                NSLog(errMsg);
                if(canceled){
                    [NSTimer schedule:2 handler:^(CFRunLoopTimerRef ref) {
                        NSString *link_myorder = @"hnh://order.me?tabindex=1";
                        [[XJXLinkageRouter defaultRouter] routeToLink:link_myorder];
                        [Utils showAlert:@"支付取消" title:@"警告"];
                    }];
                }
            }
        }];
    }
}

- (CGFloat)getTotalPrice{
    if([status isEqualToString:@"normal"]){
        __block CGFloat price = 0.0;
        [self.data[@"sections"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                price += [_obj[@"amount"] intValue] * [_obj[@"product"][@"price"] floatValue];
            }];
        }];
        NSIndexSet *sets = [self.creditSelection indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj boolValue];
        }];
        NSArray *checkedCoupon = [self.data[@"credits"] objectsAtIndexes:sets];
        __block CGFloat discount = 0.0;
        [checkedCoupon enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            discount += [obj[@"money"] floatValue];
        }];
        price -= discount;
        
        int money = [self.data[@"moneybag"] intValue];
        if([_order[@"using_moneybag"] boolValue]){
            price -= money;
        }
        
        return price;
    }
    else{
        id order = self.data[@"order"];
        __block CGFloat price = 0.0;
        [order[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            price += [obj[@"amount"] intValue] * [obj[@"product"][@"price"] floatValue];
        }];
        if([order[@"coupon"][@"ID"] intValue] != -1){
            price -= [order[@"coupon"][@"money"] floatValue];
        }
        int money = [self.data[@"order"][@"using_amount"] intValue];
        price -= money;
        return price;
    }
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + [self.data[@"sections"] count] + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if(section == 0){
        count = 1;
    }
    else if(section == [self numberOfSectionsInTableView:tableView] - 2){
        count = 3;
    }
    else if(section == [self numberOfSectionsInTableView:tableView] - 3){
        count = 1;
    }
    else if(section == [self numberOfSectionsInTableView:tableView] - 1){
        if([status isEqualToString:@"normal"]){
            count = [self.data[@"credits"] count];
        }
        else{
            count = [self.data[@"order"][@"coupon"][@"ID"] integerValue] == -1 ? 0 : 1;
        }
    }
    else{
        count = [self.data[@"sections"][section - 1][@"items"] count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(![self.data[@"hasDefaultAddress"] boolValue] && [status isEqualToString:@"normal"]){
            return 50;
        }
        else{
            return 80;
        }
    }
    else if(indexPath.section == [self numberOfSectionsInTableView:_tableView] - 3){
        return 44;
    }
    else if(indexPath.section == [self numberOfSectionsInTableView:_tableView] - 2){
        return 44;
    }
    else if(indexPath.section == [self numberOfSectionsInTableView:_tableView] - 1){
        return 44;
    }
    else{
        return 140;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section != 0 && section != [self numberOfSectionsInTableView:tableView] - 1 && section != [self numberOfSectionsInTableView:tableView] - 2 &&
        section != [self numberOfSectionsInTableView:tableView] - 3){
        if([self.data[@"sections"] count] > 0)
            return 50;
        else
            return 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0 && section != [self numberOfSectionsInTableView:tableView] - 1 && section != [self numberOfSectionsInTableView:tableView] - 2 &&
        section != [self numberOfSectionsInTableView:tableView] - 3){
        if([self.data[@"sections"] count] > 0){
            XJXPlatformCardHeader *view = (XJXPlatformCardHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
            view.checkable = NO;
            id cartSection = self.data[@"sections"][section - 1];
            view.platform_name = cartSection[@"platform"];
            view.logo_url = cartSection[@"platform_logo_url"];
            [view layout];
            return view;
        }
        return nil;
    }
    else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXBaseCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_SHIPPING_ADDR_ID forIndexPath:indexPath];
        if(!cell){
            cell = [[XJXShippingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_SHIPPING_ADDR_ID];
        }
        [self configShippingCell:(XJXShippingCell *)cell atIndexPath:indexPath];
    }
    else if (indexPath.section == [self numberOfSectionsInTableView:tableView] - 3){
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_SWITCHER forIndexPath:indexPath];
        [self configMoneyBagCell:(XJXSwitcherCell *)cell];
    }
    else if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 2){
        if(indexPath.row == 0 || indexPath.row == 2){
            cell =  [tableView dequeueReusableCellWithIdentifier:CELL_EXTRA_LB forIndexPath:indexPath];
            if(!cell)
                cell = [[XJXLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_EXTRA_LB];
        }
        else if(indexPath.row == 1){
            cell =  [tableView dequeueReusableCellWithIdentifier:CELL_EXTRA_FIELD forIndexPath:indexPath];
            if(!cell)
                cell = [[XJXTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_EXTRA_FIELD];
        }
        
        [self configExtraCell:(XJXFormFieldCell *)cell atIndexPath:indexPath];
    }
    else if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 1){
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_CREDIT forIndexPath:indexPath];
        if(!cell){
            cell = [[XJXCreditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_CREDIT];
        }
        [self configCreditCell:(XJXCreditCell *)cell atIndexPath:indexPath];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
        if(!cell){
            cell = [[XJXShoppingCard alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        }
        [self configItemCell:(XJXShoppingCard *)cell atIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - cell config
- (void)configShippingCell:(XJXShippingCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if([status isEqualToString:@"normal"]){
        cell.isEmpty = ![self.data[@"hasDefaultAddress"] boolValue];
        if(!cell.isEmpty){
            id shipping = self.data[@"defaultAddress"];
            cell.name = shipping[@"name"];
            cell.tele = shipping[@"tele"];
            cell.address = shipping[@"address"];
        }
    }
    else{
        cell.isEmpty = NO;
        cell.name = self.data[@"order"][@"shipping"][@"name"];
        cell.address = self.data[@"order"][@"shipping"][@"address"];
        cell.tele = self.data[@"order"][@"shipping"][@"tele"];
    }
    cell.accessoryEnabled = YES;
}

- (void)configItemCell:(XJXShoppingCard *)card atIndexPath:(NSIndexPath *)indexPath{
    id section = self.data[@"sections"][indexPath.section - 1];
    id cartitem = section[@"items"][indexPath.row];
    card.checkable = NO;
    card.title = cartitem[@"product"][@"name"];
    card.price = [cartitem[@"product"][@"price"] floatValue] / 100.0;
    card.model = [cartitem[@"model"] stringByJoinProperty:^NSString *(id item) {
        return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
    } delimiter:@";"];
    card.image_url = SERVER_FILE_WRAPPER(cartitem[@"product"][@"image"][@"tiny_thumb_image_url"]);
    card.amount = [cartitem[@"amount"] intValue];
}

- (void)configExtraCell:(XJXFormFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        cell.field_title = @"配送方式";
        [(XJXLabelCell *)cell setDetail_text:@"快递 免费"];
        cell.accessoryEnabled = YES;
    }
    else if(indexPath.row == 1){
        cell.field_title = @"买家留言";
        cell.text = [status isEqualToString:@"normal"] ? _order[@"custom_need"] : self.data[@"order"][@"custom_needs"];
        [(XJXTextFieldCell *)cell setEnabled:[status isEqualToString:@"normal"] ? YES : NO];
        [(XJXTextFieldCell *)cell setPlaceholder:@"选填，填写您的私人要求"];
        [(XJXTextFieldCell *)cell setOnTextChangedHandler:^(NSString *text){
            [_order setObject:text forKey:@"custom_need"];
        }];
    }
    else if(indexPath.row == 2){
        cell.field_title = @"支付方式";
        [(XJXLabelCell *)cell setDetail_text:@"微信支付"];
        cell.accessoryEnabled = YES;
    }
}

- (void)configMoneyBagCell:(XJXSwitcherCell *)cell{
    if([status isEqualToString:@"normal"]){
        CGFloat money = [self.data[@"moneybag"] floatValue] / 100.0;
        cell.field_title = [NSString stringWithFormat:@"使用钱包"];
        if(money > 1){
            cell.desc = [NSString stringWithFormat:@"余额: %.2lf",money];
            cell.on = [_order[@"using_moneybag"] boolValue];
            cell.stateChangedHandler = ^(BOOL on){
                [_order setObject:@(on) forKey:@"using_moneybag"];
                _toolbar.totalPrice = [self getTotalPrice] / 100.0;
            };
        }
        else{
            cell.desc = @"余额不足一元,无法使用";
            cell.enabled = NO;
            cell.on = NO;
        }
    }
    else{
        cell.enabled = NO;
        cell.on = [self.data[@"order"][@"using_moneybag"] boolValue];
        cell.field_title = @"使用钱包";
        cell.desc = [NSString stringWithFormat:@"金额: %.2lf",[self.data[@"order"][@"using_amount"] floatValue] / 100];
    }
}

- (void)configCreditCell:(XJXCreditCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if([status isEqualToString:@"normal"]){
        NSArray *credits = self.data[@"credits"];
        cell.field_title = credits[indexPath.row][@"name"];
        cell.detail_text = [NSString stringWithFormat:@"￥%.2lf",[credits[indexPath.row][@"money"] floatValue]];
        [cell.accessoryEditor setStatusChangedHandler:^(CheckEditor *editor,XJXCreditCell *sender){
            NSIndexPath *_indexPath = [_tableView indexPathForCell:sender];
            [_creditSelection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(idx != _indexPath.row){
                    _creditSelection[idx] = @(NO);
                }
                else{
                    _creditSelection[idx] = @(editor.checked);
                }
                _toolbar.totalPrice = [self getTotalPrice] / 100.0;
            }];
        }];
    }
    else{
        if([self.data[@"order"][@"coupon"][@"ID"] integerValue] != -1){
            cell.field_title = self.data[@"order"][@"coupon"][@"name"];
            cell.detail_text = [NSString stringWithFormat:@"￥%.2lf",[self.data[@"order"][@"coupon"][@"money"] floatValue]];
            cell.accessoryEditor.checked = YES;
            cell.accessoryEditor.enabled = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([status isEqualToString:@"normal"]){
        XJXBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(indexPath.section == 0){
            [ShippingAPI requestShippingInfosOnCompletion:^(id res, NSString *err) {
                if(!err){
                    if([res count] > 0){
                        XJXShippingPickerController *vc = [[XJXShippingPickerController alloc] initWithExternalParams:@{@"infos" : [[res toJson] toBase64]}];
                        vc.didPickShippingInfoHandler = ^(BOOL needReload){
                            if(needReload){
                                [self loadDataWithCompletion:^{
                                    [self initShippingInfo];
                                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                }];
                            }
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        XJXShippingEditController *vc = [[XJXShippingEditController alloc] init];
                        vc.onEditingDoneHandler = ^(){
                            [self loadDataWithCompletion:^{
                                [self initShippingInfo];
                                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                            }];
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                else{
                    NSLog(err);
                }
            }];
        }
        else if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 2){
            if(indexPath.row == 0){
                
            }
        }
        else if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 1){
            [[(XJXCreditCell *)cell accessoryEditor] setChecked:![_creditSelection[indexPath.row] boolValue]];
        }
        else{
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
