//
//  XJXMyCrowdFundingController.m
//  XJX
//
//  Created by Cai8 on 16/2/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMyCrowdFundingController.h"
#import "XJXCrowdFundingCell.h"

@interface XJXMyCrowdFundingController()<UITableViewDataSource,UITableViewDelegate,XJXCrowdFundingCellDelegate>

@property (nonatomic,strong) NSMutableDictionary *collapseCards;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) LMPullToBounceWrapper *pullToRefreshWrapper;

@end

@implementation XJXMyCrowdFundingController

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
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"我的众筹" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [[self.view viewWithTag:999] removeFromSuperview];
    [FundingAPI requestFundingItemsOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"items"];
            done();
        }
        else{
            [Utils showAlert:err title:@"警告"];
        }
    }];
}


- (void)onEmpty{
    if([self.view viewWithTag:999]){
        return;
    }
    UIImageView *emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [emptyImage setContentMode:UIViewContentModeScaleAspectFit];
    [emptyImage setImage:[UIImage imageNamed:@"funding_empty"]];
    [emptyImage verticalCenteredOnView:self.view];
    [emptyImage horizontalCenteredOnView:self.view];
    emptyImage.tag = 999;
    [self addSubview:emptyImage];
}

- (void)emptyDetect{
    if([self.data[@"items"] count] == 0){
        [self onEmpty];
    }
    else{
        [[self.view viewWithTag:999] removeFromSuperview];
    }
}

- (void)initParams{
    self.collapseCards = [NSMutableDictionary dictionary];
}

- (void)initUI{
    [self initTB];
    [self emptyDetect];
}

- (void)initTB{
    WS(_self);
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, SCREEN_HEIGHT - [self.navBar getMaxY])];
    _tableView = [[UITableView alloc] initWithFrame:container.bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXCrowdFundingCell class] forCellReuseIdentifier:NSStringFromClass([XJXCrowdFundingCell class])];
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
    [[self.view viewWithTag:999] removeFromSuperview];
    [FundingAPI requestFundingItemsOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"items"];
            [_tableView reloadData];
            [self emptyDetect];
        }
        else{
            [Utils showAlert:err title:@"警告"];
        }
        [_pullToRefreshWrapper stopLoadingAnimation];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data[@"items"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XJXCrowdFundingCell heightOfFundingCellWithCollapse:self.collapseCards[indexPath] == nil fcounts:[self.data[@"items"][indexPath.section][@"funders"] count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXCrowdFundingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXCrowdFundingCell class]) forIndexPath:indexPath];
    id wishitem = self.data[@"items"][indexPath.section];
    cell.image_url = SERVER_FILE_WRAPPER(wishitem[@"product"][@"image"][@"medium_thumb_image_url"]);
    cell.isCustom = [wishitem[@"isCustom"] boolValue];
    cell.title = wishitem[@"product"][@"name"];
    cell.price = [wishitem[@"amount"] floatValue] * [wishitem[@"product"][@"price"] floatValue] / 100;
    cell.fundedMoney = [wishitem[@"totalFund"] floatValue] / 100;
    cell.funders = wishitem[@"funders"];
    cell.collapse = self.collapseCards[indexPath] == nil;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id wishitem = self.data[@"items"][indexPath.section];
    id product = wishitem[@"product"];
    NSString *url = [NSString stringWithFormat:@"hnh://product?product=%@",[[product toJson] toBase64]];
    [[XJXLinkageRouter defaultRouter] routeToLink:url];
}

#pragma mark - xjxcfcelldelegate
- (void)didCollapseStatusChange:(XJXCrowdFundingCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(_collapseCards[indexPath]){
        [_collapseCards removeObjectForKey:indexPath];
    }
    else{
        [_collapseCards setObject:@(YES) forKey:indexPath];
    }
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didTerminateCFPressed:(XJXCrowdFundingCell *)cell{
    NSIndexPath *_indexPath = [_tableView indexPathForCell:cell];
    id wishitem = self.data[@"items"][_indexPath.section];
    [Utils comfirmWithPromt:[NSString stringWithFormat:@"是否要取消%@的众筹",wishitem[@"product"][@"name"]] title:@"警告" comfirm:^{
        [FundingAPI endItemFundingWithItemId:[wishitem[@"ID"] integerValue] itemType:[wishitem[@"isCustom"] boolValue] ? @"custom" : @"origin" completion:^(id res, NSString *err) {
            if(!err){
                [Utils showAlert:@"成功取消" title:@"信息"];
                [self reload];
            }
            else{
                [Utils showAlert:err title:@"警告"];
            }
        }];
    }];
}

@end
