//
//  XJXProfileConrtoller.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProfileConrtoller.h"
#import "XJXProfileCell.h"
#import "XJXBindPhoneController.h"
#import "XJXMoneyBagController.h"
#import "XJXMyCrowdFundingController.h"

@interface XJXProfileView : UIView

@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) UIImageView *backgroundView;

@property (nonatomic,strong) UILabel *nicknameLb;

@end

@implementation XJXProfileView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
    
    [_headerView setY:80];
    [_headerView horizontalCenteredOnView:self];
    
    _headerView.layer.cornerRadius = 0.5 * [_headerView getH];
    _headerView.layer.masksToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    _nicknameLb = [UIControlsUtils labelWithTitle:[Session current].wechat_name color:WhiteColor(1, 1) font:[Theme defaultTheme].titleFont];
    
    [_nicknameLb setY:[_headerView getMaxY] + 10];
    [_nicknameLb horizontalCenteredOnView:self];
    
    [self addSubview:_backgroundView];
    [self addSubview:_headerView];
    [self addSubview:_nicknameLb];
}

@end

@interface XJXProfileConrtoller()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) XJXProfileView *profileView;

@end

@implementation XJXProfileConrtoller

- (UIImage *)tabImage{
    return [UIImage imageNamed:@"我"];
}

- (UIImage *)selectedTabImage{
    return [UIImage imageNamed:@"我-selected"];
}

- (NSString *)tabTitle{
    return @"我";
}

- (void)initParams{
    id form = @[@{
                @"name" : @"我的众筹",
                @"icon" : @"crowdfund",
                @"id" : @"crowdfund"
                },
                @{
                    @"name" : @"我的钱包",
                    @"icon" : @"moneybag",
                    @"id" : @"moneybag"
                    },
                @{
                    @"name" : @"我的订单",
                    @"icon" : @"order",
                    @"id" : @"order"
                    },
                @{
                    @"name" : @"绑定手机",
                    @"icon" : @"phone",
                    @"id" : @"phone"
                    },
                @{
                    @"name" : @"购物车",
                    @"icon" : @"icon-shoppingcart",
                    @"id" : @"cart"
                    },
                @{
                    @"name" : @"上传监播报告",
                    @"icon" : @"icon-upload",
                    @"id" : @"icon-upload"
                    },
                @{
                    @"name" : @"帮助",
                    @"icon" : @"help",
                    @"id" : @"help"
                    }];
    
    [self.data setObject:form forKey:@"form"];
    
    if([[Session current] isLogined]){
        [[Session current] addObserver:self forKeyPath:@"phone" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"phone"]){
        [_tableView reloadData];
    }
}

- (void)initNav{
    
}

- (void)initUI{
    _profileView = [[XJXProfileView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 325)];
    _profileView.backgroundView.image = [UIImage imageWithFile:@"profile" type:@"jpg"];
    [_profileView.headerView lazyWithUrl:[Session current].headimgUrl];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [self.view getW], [self.view getH] - [self.tabBarController.tabBar getH]) style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXProfileCell class] forCellReuseIdentifier:@"profile"];
    _tableView.parallaxHeader.view = _profileView;
    _tableView.parallaxHeader.height = [_profileView getH];
    _tableView.parallaxHeader.minimumHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else if(section == 1){
        return 3;
    }
    else if(section == 2){
        return 1;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"profile";
    id form = self.data[@"form"];
    XJXProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.icon = [UIImage imageNamed:form[0][@"icon"]];
            cell.title = form[0][@"name"];
        }
        else if(indexPath.row == 1){
            cell.icon = [UIImage imageNamed:form[1][@"icon"]];
            cell.title = form[1][@"name"];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.icon = [UIImage imageNamed:form[2][@"icon"]];
            cell.title = form[2][@"name"];
        }
        else if(indexPath.row == 1){
            cell.icon = [UIImage imageNamed:form[3][@"icon"]];
            cell.title = form[3][@"name"];
            if(![[Session current].phone isEmpty]){
                cell.emText = [Session current].phone;
            }
        }
        else if(indexPath.row == 2){
            cell.icon = [UIImage imageNamed:form[4][@"icon"]];
            cell.title = form[4][@"name"];
        }
    }
    else if(indexPath.section == 2){
        cell.icon = [UIImage imageNamed:form[5][@"icon"]];
        cell.title = form[5][@"name"];
    }
    else{
        if(indexPath.row == 0){
            cell.icon = [UIImage imageNamed:form[6][@"icon"]];
            cell.title = form[6][@"name"];
        }
        else if(indexPath.row == 1){
            cell.icon = [UIImage imageNamed:form[7][@"icon"]];
            cell.title = form[7][@"name"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            XJXMyCrowdFundingController *vc = [[XJXMyCrowdFundingController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1){
            XJXMoneyBagController *vc = [[XJXMoneyBagController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [[XJXLinkageRouter defaultRouter] routeToLink:@"hnh://order.me"];
        }
        else if(indexPath.row == 1){
            XJXBindPhoneController *vc = [[XJXBindPhoneController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 2){
            [[XJXLinkageRouter defaultRouter] routeToLink:@"hnh://shopping.cart"];
        }
    }
    else{
        if(indexPath.row == 0){
            NSString *link = ARTICLE_HTML_URL_WRAPPER(@"2016030214452115099");
            [[XJXLinkageRouter defaultRouter] routeToLink:link];
        }
        else if(indexPath.row == 1){
            NSString *link = ARTICLE_HTML_URL_WRAPPER(@"2016030214452115099");
            [[XJXLinkageRouter defaultRouter] routeToLink:link];
        }
    }

}

@end
