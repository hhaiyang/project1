//
//  XJXShippingPickerController.m
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShippingPickerController.h"
#import "XJXShippingEditController.h"

@interface XJXShippingPickerController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSUInteger defaultIndex;

@property (nonatomic,assign) NSUInteger selectedIndex;

@end

@implementation XJXShippingPickerController

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
    
    UIButton *btnSave = [UIControlsUtils buttonWithTitle:@"保存" background:nil backroundImage:nil target:self selector:@selector(save:) padding:UIEdgeInsetsZero frame:CGRectZero];
    
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"选择收货地址" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [item setRightBarButtonItems:@[itemSave]];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [self.view getH] - [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = WhiteColor(0, .08);
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)initParams{
    id shippingInfos = [[[self getValueFromParamKey:@"infos"] fromBase64] fromJson];
    if(shippingInfos){
        [self.data setObject:shippingInfos forKey:@"shippingInfos"];
        _defaultIndex = _selectedIndex = [self getDefaultIndex];
    }
}

- (NSUInteger)getDefaultIndex{
    NSUInteger index = [self.data[@"shippingInfos"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj[@"isDefault"] boolValue];
    }];
    if(index == NSNotFound){
        index = -1;
    }
    return index;
}

- (void)save:(id)sender{
    if(_defaultIndex != _selectedIndex){
        [ShippingAPI setShippingDefaultWithId:[self.data[@"shippingInfos"][_selectedIndex][@"ID"] integerValue] completion:^(id res, NSString *err) {
            if(!err){
                if(self.didPickShippingInfoHandler){
                    self.didPickShippingInfoHandler(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSLog(err);
            }
        }];
    }
    else{
        if(self.didPickShippingInfoHandler){
            self.didPickShippingInfoHandler(NO);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)delete:(id)sender{
    
}

- (void)edit:(id)sender{
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [self.data[@"shippingInfos"] count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.textLabel.font = [Theme defaultTheme].titleFont;
        cell.detailTextLabel.font = [Theme defaultTheme].subTitleFont;
        
        cell.textLabel.textColor = [Theme defaultTheme].titleColor;
        cell.detailTextLabel.textColor = [Theme defaultTheme].subTitleColor;
        cell.tintColor = [Theme defaultTheme].schemeColor;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if(indexPath.section == 0){
        id info = self.data[@"shippingInfos"][indexPath.row];
        cell.textLabel.text = info[@"name"];
        cell.detailTextLabel.text = info[@"address"];
        if(indexPath.row == _selectedIndex){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
        UIButton *btnDelete = [UIControlsUtils buttonWithTitle:@"删除" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(delete:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, 60, 60)];
        [btnDelete setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
        
        UIButton *btnEdit = [UIControlsUtils buttonWithTitle:@"编辑" background:[Theme defaultTheme].schemeColor backroundImage:nil target:self selector:@selector(edit:) padding:UIEdgeInsetsZero frame:CGRectMake(60, 0, 60, 60)];
        [btnEdit setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
        
        [container addSubview:btnDelete];
        [container addSubview:btnEdit];
        [cell addLeftView:container];
    }
    else{
        cell.textLabel.text = @"添加新地址";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if(indexPath.section == 0){
        _selectedIndex = indexPath.row;
        [tableView reloadData];
    }
    else{
        XJXShippingEditController *vc = [[XJXShippingEditController alloc] init];
        vc.onEditingDoneHandler = ^(NSDictionary *info){
            [self reloadShippings];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)reloadShippings{
    [ShippingAPI requestShippingInfosOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"shippingInfos"];
            _selectedIndex = [self getDefaultIndex];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            NSLog(err);
        }
    }];
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
