//
//  XJXFundingController.m
//  XJX
//
//  Created by Cai8 on 16/3/31.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXFundingController.h"

@interface XJXFundingController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XJXFundingController

- (NSString *)tabTitle{
    return @"抢赞助";
}

- (UIImage *)tabImage{
    return [[UIImage imageNamed:@"抢赞助-nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)selectedTabImage{
    return [[UIImage imageNamed:@"抢赞助-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)initNav{
    
}

- (void)initUI{
    
}

- (void)initParams{
    
}



@end
