//
//  XJXMessageController.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXMessageController.h"
#import "XJXMessageCell.h"

@interface XJXMessageController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *messages;

@end

@implementation XJXMessageController

- (void)loadDataWithCompletion:(onActionDone)done{
    /*[[Session current] checkSessionStatusOnCompletion:^(BOOL isValid) {
        if(isValid){
            [MessageAPI requestMessagesOnCompletion:^(id res, NSString *err) {
                if(!err){
                    [self.data setObject:res forKey:@"messages"];
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
    }];*/
}

- (void)initParams{
    _messages = [NSMutableArray array];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor whiteColor]];
    [self.navBar setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"消息" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navBar.bounds.size.height + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, SCREEN_WIDTH, SCREEN_HEIGHT - (self.navBar.bounds.size.height + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI))];
    _tableView.backgroundColor = WhiteColor(1, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cell";
    XJXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(!cell){
        cell = [[XJXMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    id message = self.messages[indexPath.row];
    cell.title = message[@"title"];
    cell.subTitle = message[@"desc"];
    cell.time = [Utils readableTime:[Utils dateFromString:message[@"timetag"] formatter:@"yyyy-MM-dd HH:mm:ss"]];
    cell.messageType = [message[@"messageType"] intValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
