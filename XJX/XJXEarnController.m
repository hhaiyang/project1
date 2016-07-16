//
//  XJXEarnController.m
//  XJX
//
//  Created by Cai8 on 16/4/1.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXEarnController.h"
#import <NYSegmentedControl/NYSegmentedControl.h>
#import "XJXEarnView.h"

@interface XJXEarnController()

@property (nonatomic,strong) NYSegmentedControl *segment;

@property (nonatomic,strong) UIView *readmeView;
@property (nonatomic,strong) XJXEarnView *earnView;

@end

@implementation XJXEarnController
@synthesize segment;

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLb = [UIControlsUtils labelWithTitle:@"赚钱" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].h3Font];
    
    UIButton *btnSave = [UIControlsUtils buttonWithTitle:@"保存" background:nil backroundImage:nil target:self selector:@selector(save) padding:UIEdgeInsetsZero frame:CGRectZero];
    
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.titleView = titleLb;
    item.rightBarButtonItem = itemSave;
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [ReservationAPI requestWeddingInfoWithCompletion:^(id res, NSString *err) {
        if(!err){
            if([res isKindOfClass:[NSNull class]]){
                [Utils showAlert:@"您还未注册婚礼，请在喜讯页面注册" title:@"警告"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self.data setObject:res forKey:@"weddingInfo"];
                done();
            }
        }
        else{
            [self onError];
        }
    }];
}

- (void)initParams{
    
}

- (void)initUI{
    segment = [[NYSegmentedControl alloc] initWithItems:@[@"说明", @"赚钱"]];
    segment.titleTextColor = WhiteColor(1, 1);
    segment.selectedTitleTextColor = [UIColor whiteColor];
    segment.selectedTitleFont = [Theme defaultTheme].normalTextFont;
    segment.segmentIndicatorBackgroundColor = [Theme defaultTheme].highlightTextColor;
    segment.titleFont = [Theme defaultTheme].normalTextFont;
    segment.titleTextColor = [Theme defaultTheme].highlightTextColor;
    segment.backgroundColor = WhiteColor(1, 1);
    segment.borderWidth = 1.0f;
    segment.borderColor = [Theme defaultTheme].highlightTextColor;
    segment.segmentIndicatorBorderWidth = 1.0f;
    segment.segmentIndicatorInset = 0.0f;
    segment.segmentIndicatorBorderColor = [Theme defaultTheme].highlightTextColor;
    [segment sizeToFit];
    [segment setH:40];
    segment.cornerRadius = CGRectGetHeight(segment.frame) / 2.0f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    segment.usesSpringAnimations = YES;
#endif
    [segment horizontalCenteredOnView:self.view];
    [segment setY:[self.navBar getMaxY] + 10];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segment];
    
    [self showReadme];
}

- (void)segmentChanged:(NYSegmentedControl *)segmentControl{
    if(segmentControl.selectedSegmentIndex == 0){
        [self showReadme];
    }
    else if(segmentControl.selectedSegmentIndex == 1){
        [self showEarn];
    }
}

- (void)showReadme{
    if(!_readmeView){
        _readmeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [segment getMaxY] + 10, SCREEN_WIDTH, [self.view getH] - ([segment getMaxY] + 10))];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageWithFile:@"profile" type:@"jpg"];
        imageView.layer.masksToBounds = YES;
        
        UILabel *readmeTitleLb = [UIControlsUtils labelWithTitle:@"模式说明" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].h2Font];
        [readmeTitleLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [readmeTitleLb setY:[imageView getMaxY] + 15];
        
        UILabel *readmeLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentLeft constrainSize:CGSizeMake(SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, MAXFLOAT)];
        readmeLb.attributedText = [NSAttributedString attributeStringWithString:@"\t一生就这么一次，谈一场以结婚为目的的恋爱吧.不再固执而轻言分手。最后坚信她一次，一直走，就可以到白头到老相互以来的恋爱.好不好？然后就那样与相守。再来往的流沙，浪漫的爱情。一生就那么一次。再来往的流沙，浪漫的爱情。一生就那么一次.一生就这么一次，谈一场以结婚为目的的恋爱吧.不再固执而轻言分手。最后坚信她一次，一直走，就可以到白头到老相互以来的恋爱.好不好？然后就那样与相守。再来往的流沙，浪漫的爱情。一生就那么一次。再来往的流沙，浪漫的爱情。一生就那么一次" font:[Theme defaultTheme].normalTextFont textColor:[[Theme defaultTheme].schemeColor colorWithAlphaComponent:0.6] lineHeight:6];
        [readmeLb recalculateSizeWithConstraintSize:CGSizeMake(SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, MAXFLOAT)];
        
        [readmeLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
        [readmeLb setY:[readmeTitleLb getMaxY] + 10];
        
        [_readmeView addSubview:imageView];
        [_readmeView addSubview:readmeTitleLb];
        [_readmeView addSubview:readmeLb];
        [(UIScrollView *)_readmeView setContentSize:CGSizeMake(SCREEN_WIDTH, [readmeLb getMaxY])];
    }
    if(!_readmeView.superview){
        [_earnView removeFromSuperview];
        [self addSubview:_readmeView];
    }
}

- (void)showEarn{
    if(!_earnView){
        _earnView = [[XJXEarnView alloc] initWithFrame:CGRectMake(0, [segment getMaxY] + 10, SCREEN_WIDTH, [self.view getH] - ([segment getMaxY] + 10))];
    }
    if(!_earnView.superview){
        [_readmeView removeFromSuperview];
        [self addSubview:_earnView];
    }
}

- (void)save{
    if(!self.earnView.submitForm){
        [Utils showAlert:@"请填写预约表格" title:@"警告"];
        return;
    }
    id post = @{
                @"wedding_id" : self.data[@"weddingInfo"][@"ID"],
                @"cover" : @"-1",
                @"bridename" : self.data[@"weddingInfo"][@"bridename"],
                @"groomname" : self.data[@"weddingInfo"][@"groomname"],
                @"city" : self.earnView.submitForm[@"requiredForm"][@"city"],
                @"address" : self.data[@"weddingInfo"][@"address"],
                @"time" : self.earnView.submitForm[@"requiredForm"][@"time"],
                @"guimo" : self.earnView.submitForm[@"requiredForm"][@"guimo"],
                @"venuetype" : self.earnView.submitForm[@"requiredForm"][@"venue_type"],
                @"consume" : self.earnView.submitForm[@"requiredForm"][@"consume"],
                @"brand_ids" : self.earnView.submitForm[@"brands"],
                @"requester" : @([Session current].ID)
                };
    [ReservationAPI updateWeddingInfo:post completion:^(id res, NSString *err) {
        if(!err){
            [self back:nil];
            [Utils showAlert:@"预订成功" title:@"信息"];
        }
        else{
            [Utils showAlert:err title:@"警告"];
        }
    }];
}

@end
