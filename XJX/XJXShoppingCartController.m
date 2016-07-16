//
//  XJXShoppingCartController.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShoppingCartController.h"
#import "XJXShoppingCard.h"
#import "XJXPlatformCardHeader.h"
#import "XJXShoppingCartToolbar.h"
#import "XJXProductActionSheet.h"

@interface XJXShoppingCartController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) XJXShoppingCartToolbar *toolbar;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) LMPullToBounceWrapper *pullToRefreshWrapper;

@property (nonatomic,assign) BOOL editing;

@property (nonatomic,strong) UIButton *btnEdit;

@property (nonatomic,assign) BOOL needUpdate;

@end

@implementation XJXShoppingCartController

- (UIImage *)tabImage{
    return [UIImage imageNamed:@"购物车"];
}

- (UIImage *)selectedTabImage{
    return [UIImage imageNamed:@"购物车-selected"];
}

- (NSString *)tabTitle{
    return @"购物车";
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [[self.view viewWithTag:999] removeFromSuperview];
    [ShopAPI requestProductInShoppingCartOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"cartitems"];
            done();
            
            [self emptyDetect];
        }
        else{
            [self onError];
        }
    }];
}

- (void)reload{
    [[self.view viewWithTag:999] removeFromSuperview];
    [ShopAPI requestProductInShoppingCartOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"cartitems"];
            [self prepareData];
            [self.tableView reloadData];
            [self.toolbar reset];
        }
        else{
            [self onError];
        }
    }];
}

- (void)emptyDetect{
    if([self.data[@"sections"] count] == 0){
        [self onEmpty];
    }
    else{
        [[self.view viewWithTag:999] removeFromSuperview];
    }
}

- (void)initParams{
    self.needUpdate = NO;
    self.editing = NO;
    if(self.toolbar)
        [self.toolbar reset];
    [self prepareData];
}

- (void)prepareData{
    id cartitems = self.data[@"cartitems"];
    if([cartitems count] > 0){
        NSMutableArray *cartSections = [NSMutableArray array];
        [self.data[@"cartitems"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *platform = obj[@"product"][@"platform"][@"name"];
            NSUInteger index = [cartSections indexOfObjectPassingTest:^BOOL(XJXCartSection * _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                return [_obj.platform isEqualToString:platform];
            }];
            if(index != NSNotFound){
                [[(XJXCartSection *)cartSections[index] items] addObject:obj];
                [[(XJXCartSection *)cartSections[index] itemSelections] addObject:@(NO)];
            }
            else{
                XJXCartSection *section = [[XJXCartSection alloc] init];
                section.platform = obj[@"product"][@"platform"][@"name"];
                section.platform_logo_url = obj[@"product"][@"platform"][@"logo_url"];
                [section.items addObject:obj];
                [section.itemSelections addObject:@(NO)];
                [cartSections addObject:section];
            }
        }];
        [self.data setObject:cartSections forKey:@"sections"];
    }
    else{
        [self.data setObject:@[] forKey:@"sections"];
    }
}

- (void)registerNotifications{
    [NotificationRegistrator registerNotificationOnTarget:self name:NOTI_CART_NEED_UPDATE selector:@selector(shoppingCartNeedUpdate:)];
}

- (void)shoppingCartNeedUpdate:(NSNotification *)noti{
    self.needUpdate = YES;
}

- (void)update{
    if(self.needUpdate){
        [self reload];
    }
}

- (void)onError{
    [self.pullToRefreshWrapper stopLoadingAnimation];
    [Utils showAlert:[self.exception description] title:@"警告"];
}

- (void)onEmpty{
    if([self.view viewWithTag:999]){
        return;
    }
    UIImageView *emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [emptyImage setContentMode:UIViewContentModeScaleAspectFit];
    [emptyImage setImage:[UIImage imageNamed:@"cart_empty"]];
    [emptyImage verticalCenteredOnView:self.view];
    [emptyImage horizontalCenteredOnView:self.view];
    emptyImage.tag = 999;
    [self addSubview:emptyImage];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor whiteColor]];
    [self.navBar setBackgroundColor:[UIColor whiteColor]];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY] - 1, SCREEN_WIDTH, 1)];
    borderView.backgroundColor = WhiteColor(0, .07);
    [self.navBar addSubview:borderView];
    
    _btnEdit = [UIControlsUtils buttonWithTitle:@"编辑" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(edit:) padding:UIEdgeInsetsMake(10, 0, 10, 0) frame:CGRectZero];
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"购物车" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:_btnEdit];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    [item setTitleView:naviTitleLb];
    [item setRightBarButtonItem:itemEdit];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initUI{
    WS(_self);
    
    self.view.backgroundColor = [Theme defaultTheme].schemeColor;
    
    _toolbar = [[XJXShoppingCartToolbar alloc] initWithFrame:CGRectMake(0, [self.view getH] - 50, SCREEN_WIDTH, 50)];
    _toolbar.totalPrice = 0.0;
    _toolbar.onOrderHandler = ^(){
        [_self order];
    };
    _toolbar.onSelectAllHandler = ^(BOOL selected){
        [_self.data[@"sections"] enumerateObjectsUsingBlock:^(XJXCartSection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.itemSelections enumerateObjectsUsingBlock:^(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                obj.itemSelections[_idx] = @(selected);
            }];
        }];
        [_self.tableView reloadData];
        [_self calculatePrice];
    };
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [_toolbar getMaxY] - [self.navBar getMaxY])];
    _tableView = [[UITableView alloc] initWithFrame:containerView.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[XJXShoppingCard class] forCellReuseIdentifier:@"cellid"];
    [_tableView registerClass:[XJXPlatformCardHeader class] forHeaderFooterViewReuseIdentifier:@"cardheader"];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
    backgroundView.backgroundColor = WhiteColor(.98, 1);
    [_tableView setBackgroundView:backgroundView];
    
    [_tableView setContentSize:CGSizeMake(_tableView.contentSize.width, _tableView.contentSize.height + [_toolbar getH])];
    
    _pullToRefreshWrapper = [[LMPullToBounceWrapper alloc] initWithScrollView:self.tableView];
    [containerView addSubview:_pullToRefreshWrapper];
    [_pullToRefreshWrapper setDidPullTorefresh:^(){
        [_self loadDataWithCompletion:^{
            [_self initParams];
            [_self.tableView reloadData];
            [_self.pullToRefreshWrapper stopLoadingAnimation];
        }];
    }];
    [self addSubview:containerView];
    
    [self addSubview:_toolbar];
}

- (CGSize)preferredContentSize{
    return [UIScreen mainScreen].bounds.size;
}

- (void)order{
    NSArray *selectedItems = [self getSelectedItems];
    if(selectedItems.count == 0){
        [Utils showAlert:@"请选择至少一件商品" title:@"警告"];
        return;
    }
    NSString *link = [NSString stringWithFormat:@"hnh://order.comfirm?orderitems=%@",[[selectedItems toJson] toBase64]];
    [[XJXLinkageRouter defaultRouter] routeToLink:link];
}

- (NSArray *)getSelectedItems{
    NSMutableArray *sections = [NSMutableArray array];
    [self.data[@"sections"] enumerateObjectsUsingBlock:^(XJXCartSection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *items = [NSMutableArray array];
        NSIndexSet *sets = [obj.itemSelections indexesOfObjectsPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
            return [_obj boolValue];
        }];
        if(sets.count == 0)
            return;
        
        [items addObjectsFromArray:[obj.items objectsAtIndexes:sets]];
        
        XJXCartSection *section = [[XJXCartSection alloc] init];
        section.platform = obj.platform;
        section.platform_logo_url = obj.platform_logo_url;
        section.items = items;
        [sections addObject:section];
    }];
    return sections;
}

- (void)edit:(id)sender{
    self.editing = !self.editing;
}

- (void)setEditing:(BOOL)editing{
    _editing = editing;
    if(_editing){
        [_btnEdit setTitle:@"完成" forState:UIControlStateNormal];
        [self.toolbar setXAnimate:-[self.toolbar getW]];
    }
    else{
        [_btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [self.toolbar setXAnimate:0];
    }
    if(_tableView){
        [UIView animateWithDuration:.3 animations:^{
            for(int i = 0;i < [self numberOfSectionsInTableView:_tableView];i++){
                XJXPlatformCardHeader *header = (XJXPlatformCardHeader *)[_tableView headerViewForSection:i];
                if(header){
                    if(CGRectIntersectsRect(header.frame, _tableView.bounds)){
                        header.editing = _editing;
                    }
                }
            }
            [[_tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof XJXShoppingCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.editingStatus = _editing;
            }];
        }];
    }
}

- (void)calculatePrice{
    __block BOOL isAllChecked = YES;
    __block CGFloat price = 0.0;
    [self.data[@"sections"] enumerateObjectsUsingBlock:^(XJXCartSection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexSet *sets = [obj.itemSelections indexesOfObjectsPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
            return [_obj boolValue];
        }];
        if(sets.count != obj.itemSelections.count){
            isAllChecked = NO;
        }
        [sets enumerateIndexesUsingBlock:^(NSUInteger _idx, BOOL * _Nonnull _stop) {
            id cartitem = obj.items[_idx];
            price += [cartitem[@"product"][@"price"] floatValue] * [cartitem[@"amount"] intValue];
        }];
    }];
    _toolbar.totalPrice = price / 100.0;
    [_toolbar.editor setNoHandlerChecked:isAllChecked];
}

- (BOOL)isAllCheckedInSection:(NSUInteger)section{
    XJXCartSection *cartSection = self.data[@"sections"][section];
    NSUInteger index = [cartSection.itemSelections indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj boolValue] == NO;
    }];
    return index == NSNotFound;
}

#pragma mark - tableview datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data[@"sections"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(XJXCartSection *)self.data[@"sections"][section] items].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([self.data[@"sections"] count] > 0){
        XJXCartSection *cartSection = self.data[@"sections"][section];
        XJXPlatformCardHeader *view = (XJXPlatformCardHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cardheader"];
        view.checkable = YES;
        view.platform_name = [cartSection platform];
        view.logo_url = [cartSection platform_logo_url];
        [view setEditorOnCheck:^(CheckEditor *editor, XJXPlatformCardHeader *sender) {
            NSString *platform = sender.platform_name;
            NSUInteger index = [self.data[@"sections"] indexOfObjectPassingTest:^BOOL(XJXCartSection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [obj.platform isEqualToString:platform];
            }];
            if(index != NSNotFound){
                XJXCartSection *_section = self.data[@"sections"][index];
                [_section.itemSelections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    _section.itemSelections[idx] = @(editor.checked);
                    @try {
                        XJXShoppingCard *card = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:section]];
                        [card.editor setNoHandlerChecked:editor.checked];
                    }
                    @catch (NSException *exception) {
                        NSLog([exception description]);
                    }
                }];
            }
            [self calculatePrice];
        }];
        [view layout];
        
        if([self isAllCheckedInSection:section]){
            [view.editor setChecked:YES];
        }
        else{
            [view.editor setChecked:NO];
        }
        view.editing = self.editing;
        return view;
    }
    return nil;
}

- (XJXShoppingCard *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"cellid";
    XJXShoppingCard *card = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    if(!card){
        card = [[XJXShoppingCard alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    card.selectedBackgroundView = nil;
    card.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [card setSwiperViewOnTouched:^(XJXShoppingCard *sender, NSUInteger buttonTouchedIndex) {
        NSIndexPath *_indexPath = [_tableView indexPathForCell:sender];
        XJXCartSection *section = self.data[@"sections"][_indexPath.section];
        id cartitem = section.items[_indexPath.row];
        if(buttonTouchedIndex == 0){
            [FundingAPI addItemToWishlistWithProductId:[cartitem[@"product"][@"ID"] integerValue] amount:[cartitem[@"amount"] intValue] model:[cartitem[@"model"] stringByJoinProperty:^NSString *(id item) {
                return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
            } delimiter:@"|"] completion:^(id res, NSString *err) {
                if(!err){
                    [[NotificationView sharedView].imageView lazyWithUrl:SERVER_FILE_WRAPPER(cartitem[@"product"][@"image"][@"tiny_thumb_image_url"])];
                    [NotificationView sharedView].titleLabel.text = [NSString stringWithFormat:@"%@ 已添加至心愿单",cartitem[@"product"][@"name"]];
                    [[NotificationView sharedView] show];
                    
                    [NotificationRegistrator callNoti:NOTI_WISH_NEED_UPDATE object:nil];
                }
                else{
                    
                }
            }];
        }
        else if(buttonTouchedIndex == 1){
            [Utils comfirmWithPromt:@"确认删除" title:@"信息" comfirm:^{
                [ShopAPI deleteItemFromCartWithCartItemId:[cartitem[@"ID"] intValue] completion:^(id res, NSString *err) {
                    if(!err){
                        [section.items removeObjectAtIndex:_indexPath.row];
                        [section.itemSelections removeObjectAtIndex:_indexPath.row];
                        if(section.items.count == 0){
                            [self.data[@"sections"] removeObject:section];
                        }
                        [_tableView reloadData];
                        
                        [self emptyDetect];
                    }
                    else{
                        NSLog(err);
                    }
                }];
            }];
        }
    }];
    card.checkable = YES;
    XJXCartSection *section = self.data[@"sections"][indexPath.section];
    id cartitem = [section items][indexPath.row];
    card.title = cartitem[@"product"][@"name"];
    card.price = [cartitem[@"product"][@"price"] floatValue] / 100.0;
    card.model = [cartitem[@"model"] stringByJoinProperty:^NSString *(id item) {
        return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
    } delimiter:@";"];
    card.image_url = SERVER_FILE_WRAPPER(cartitem[@"product"][@"image"][@"tiny_thumb_image_url"]);
    card.amount = [cartitem[@"amount"] intValue];

    [card setCheck:[section.itemSelections[indexPath.row] boolValue]];
    [card setEditorOnCheck:^(CheckEditor *editor, XJXShoppingCard *sender) {
        NSIndexPath *_indexPath = [_tableView indexPathForCell:sender];
        XJXCartSection *_section = self.data[@"sections"][_indexPath.section];
        _section.itemSelections[_indexPath.row] = @(editor.checked);
        XJXPlatformCardHeader *header = (XJXPlatformCardHeader *)[_tableView headerViewForSection:_indexPath.section];
        if([self isAllCheckedInSection:_indexPath.section]){
            [header.editor setNoHandlerChecked:YES];
        }
        else{
            [header.editor setNoHandlerChecked:NO];
        }
        [self calculatePrice];
    }];
    card.editingStatus = self.editing;
    card.modelClickHandler = ^(XJXShoppingCard *_card){
        NSIndexPath *_indexPath = [_tableView indexPathForCell:_card];
        XJXCartSection *section = self.data[@"sections"][_indexPath.section];
        id cartitem = [section items][_indexPath.row];
        id product = cartitem[@"product"];
        __block XJXProductActionSheet *actionSheet = [XJXProductActionSheet showWithModels:product[@"models"] title:product[@"name"] price:[product[@"price"] floatValue] / 100 imageUrl:SERVER_FILE_WRAPPER(product[@"image"][@"tiny_thumb_image_url"]) identifier:@"wishlist" selectedModel:cartitem[@"model"] amount:[cartitem[@"amount"] intValue] onSheetDone:^{
            @try {
                if([actionSheet valueChanged]){
                    id data = [actionSheet.content getSelectedModelAndAmount];
                    id amount = data[@"amount"];
                    id tags = data[@"tags"];
                    [ShopAPI updateCartItemWithAmount:[amount intValue] model:tags cart_id:[cartitem[@"ID"] integerValue] product_id:[product[@"ID"] integerValue] completion:^(id res, NSString *err) {
                        if(!err){
                            [self reload];
                        }
                        else{
                            [Utils showAlert:err title:@"警告"];
                        }
                        [actionSheet close];
                    }];
                }
                else{
                    [actionSheet close];
                }
            }
            @catch (NSException *exception) {
                NSLog([exception reason]);
            }
        }];

    };
    return card;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.data[@"sections"] count] > 0)
        return 50;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.editing){
        XJXCartSection *section = self.data[@"sections"][indexPath.section];
        id cartitem = [section items][indexPath.row];
        id product = cartitem[@"product"];
        NSString *url = [NSString stringWithFormat:@"hnh://product?product=%@",[[product toJson] toBase64]];
        [[XJXLinkageRouter defaultRouter] routeToLink:url];
    }
}

@end
