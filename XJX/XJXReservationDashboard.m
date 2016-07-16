//
//  XJXReservationDashboard.m
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationDashboard.h"
#import "XJXReservationDashboardCell.h"
#import "XJXReservationDashboardButtonCell.h"
#import "XJXButtonCell.h"

@interface XJXReservationDashboard()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) id form;

@property (nonatomic,strong) id data;
 
@end

@implementation XJXReservationDashboard

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self initParams];
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self horizontalCenteredOnView:self.superview];
    self.superview.backgroundColor = WhiteColor(0.95, 1);
}

- (void)initParams{
    self.form = @[@{
                  @"icon" : @"cf-people",
                  @"title" : @"众筹人数",
                  @"unit" : @"人"
                  },
                  @{
                      @"icon" : @"rd-people",
                      @"title" : @"喜讯阅读",
                      @"unit" : @"点击量"
                    },
                  @{
                      @"icon" : @"shake",
                      @"active-icon" : @"shake-active",
                      @"title" : @"摇一摇红包",
                      @"unit" : @"元"
                      }];
}

- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[XJXReservationDashboardCell class] forCellReuseIdentifier:NSStringFromClass([XJXReservationDashboardCell class])];
    [self.tableView registerClass:[XJXReservationDashboardButtonCell class] forCellReuseIdentifier:NSStringFromClass([XJXReservationDashboardButtonCell class])];
    [self.tableView registerClass:[XJXButtonCell class] forCellReuseIdentifier:NSStringFromClass([XJXButtonCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addSubview:self.tableView];
    
    [self.tableView horizontalCenteredOnView:self];
    
    self.backgroundColor = self.tableView.backgroundColor = WhiteColor(.95, 1);
}

- (void)reload{
    if(self.delegate && [self.delegate respondsToSelector:@selector(weddingIdOfDashboard:)]){
        [ReservationAPI requestDashboardData:[self.delegate weddingIdOfDashboard:self] completion:^(id res, NSString *err) {
            if(!err){
                self.data = res;
                [self.tableView reloadData];
            }
            else{
                [Utils showAlert:err title:@"警告"];
            }
        }];
    }
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.form count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section != 3)
        return 100;
    else
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXBaseCell *cell;
    if(indexPath.section == 0 || indexPath.section == 1){
         cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXReservationDashboardCell class]) forIndexPath:indexPath];
        [(XJXReservationDashboardCell *)cell setIcon:[UIImage imageNamed:self.form[indexPath.section][@"icon"]]];
        [(XJXReservationDashboardCell *)cell setTitle:self.form[indexPath.section][@"title"]];
        [(XJXReservationDashboardCell *)cell setUnit:self.form[indexPath.section][@"unit"]];
    }
    else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXReservationDashboardButtonCell class]) forIndexPath:indexPath];
        if(![self.data[@"redpack_status"] boolValue]){
            [(XJXReservationDashboardButtonCell *)cell setIcon:[UIImage imageNamed:self.form[indexPath.section][@"icon"]]];
            [(XJXReservationDashboardButtonCell *)cell setEnabled:YES];
            [(XJXReservationDashboardButtonCell *)cell setButtonTitle:@"激活"];
        }
        else{
            [(XJXReservationDashboardButtonCell *)cell setIcon:[UIImage imageNamed:self.form[indexPath.section][@"active-icon"]]];
            [(XJXReservationDashboardButtonCell *)cell setEnabled:NO];
            [(XJXReservationDashboardButtonCell *)cell setButtonTitle:@"已激活"];
        }
        [(XJXReservationDashboardButtonCell *)cell setTitle:self.form[indexPath.section][@"title"]];
        [(XJXReservationDashboardButtonCell *)cell setUnit:self.form[indexPath.section][@"unit"]];
    }
    else if(indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXButtonCell class]) forIndexPath:indexPath];
    }
    if(indexPath.section == 0){
        [(XJXReservationDashboardCell *)cell setNumber:[self.data[@"cfcount"] intValue]];
        [(XJXReservationDashboardCell *)cell setTotal:200];
    }
    else if(indexPath.section == 1){
        [(XJXReservationDashboardCell *)cell setNumber:[self.data[@"wedding_read"] intValue]];
        [(XJXReservationDashboardCell *)cell setTotal:200];
    }
    else if(indexPath.section == 2){
        [(XJXReservationDashboardButtonCell *)cell setNumber:100];
        [(XJXReservationDashboardButtonCell *)cell setButtonClickHandler:^(XJXReservationDashboardButtonCell *sender){
            [ReservationAPI enableRedpackOnWedding:[self.delegate weddingIdOfDashboard:self] completion:^(id res, NSString *err) {
                if(!err){
                    [self reload];
                }
                else{
                    [Utils showAlert:@"请先绑定婚礼" title:@"警告"];
                }
            }];
        }];
    }
    else if(indexPath.section == 3){
        [(XJXButtonCell *)cell setTitle:@"绑定另一半"];
        [(XJXButtonCell *)cell setIcon:[UIImage imageNamed:@"bind"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        [Utils showAlert:@"即将通过微信分享绑定链接" title:@"信息"];
        NSString *link = BIND_PERSON_URL_WRAPPER([self.delegate weddingIdOfDashboard:self]);
        WechatShareContent *content = [[WechatShareContent alloc] init];
        content.image_url = [self.delegate coverUrlOfDashboard:self];
        content.title = @"绑定婚礼另一半";
        content.desc = @"更好的获取婚礼进程";
        content.redirect_url = link;
        content.scene = kWechatShareSceneSession;
        [[WechatAgent defaultAgent] doShareContent:content];
    }
}

@end
