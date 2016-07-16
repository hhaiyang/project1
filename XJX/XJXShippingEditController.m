//
//  XJXShippingEditController.m
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShippingEditController.h"

#import "XJXTextFieldCell.h"
#import "XJXSwitcherCell.h"

@interface XJXShippingEditController ()<UITableViewDataSource,UITableViewDelegate,ActionSheetCustomPickerDelegate>

@property (nonatomic,strong) NSMutableDictionary *form;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XJXShippingEditController

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
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"添加收货地址" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [item setRightBarButtonItems:@[itemSave]];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initParams{
    id formFields = @[@{@"field_title" : @"收货人",@"field_name" : @"name",@"field_placeholder" : @"填写收货人信息",@"clickable":@(NO)},
                      @{@"field_title" : @"手机号",@"field_name" : @"tele",@"field_placeholder" : @"11位手机号",@"clickable":@(NO)},
                      @{@"field_title" : @"省市区",@"field_name" : @"region",@"field_placeholder" : @"所在地区",@"clickable":@(YES)},
                      @{@"field_title" : @"详细地址",@"field_name" : @"address",@"field_placeholder" : @"街道门派信息",@"clickable":@(NO)}
                      ];
    [self.data setObject:formFields forKey:@"fields"];
    
    _form = [NSMutableDictionary dictionary];
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [self.view getH] - [self.navBar getH]) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XJXTextFieldCell class] forCellReuseIdentifier:@"FIELD_CELL"];
    [_tableView registerClass:[XJXSwitcherCell class] forCellReuseIdentifier: @"SWITCH_CELL"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)save:(id)sender{
    
    [self.data[@"fields"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJXTextFieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        [_form setObject:cell.text forKey:obj[@"field_name"]];
    }];
    XJXSwitcherCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    [_form setObject:@(cell.on) forKey:@"isDefault"];
    
    if(![[_form allKeys] containsObject:@"region"]){
        [Utils showAlert:@"请选择地区" title:@"警告"];
        return;
    }
    
    if([_form[@"name"] isEmpty] || [_form[@"region"] isEmpty] || [_form[@"address"] isEmpty] || [_form[@"tele"] isEmpty]){
        [Utils showAlert:@"信息填写不完整" title:@"警告"];
        return;
    }
    if(![Validator isValid:IdentifierTypePhone value:_form[@"tele"]]){
        [Utils showAlert:@"电话号码格式不正确" title:@"警告"];
        return;
    }
    
    id submitForm = @{
                      @"name" : _form[@"name"],
                      @"address" : [NSString stringWithFormat:@"%@ %@",_form[@"region"],_form[@"address"]],
                      @"tele" : _form[@"tele"],
                      @"isDefault" : @(YES),
                      @"requester" : @([Session current].ID)
                      };
    
    [ShippingAPI addShipping:submitForm completion:^(id res, NSString *err) {
        if(!err){
            if(self.onEditingDoneHandler){
                self.onEditingDoneHandler();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(err);
        }
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 4;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJXFormFieldCell *cell;
    if(indexPath.section == 0){
        id formfields = self.data[@"fields"];
        id field = formfields[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FIELD_CELL" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(!cell){
            cell = [[XJXTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FIELD_CELL"];
        }
        cell.field_title = field[@"field_title"];
        cell.titleColor = [[Theme defaultTheme].schemeColor colorWithAlphaComponent:.8];
        [(XJXTextFieldCell *)cell setEnabled:![field[@"clickable"] boolValue]];
        [(XJXTextFieldCell *)cell setPlaceholder:field[@"field_placeholder"]];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"SWITCH_CELL" forIndexPath:indexPath];
        if(!cell){
            cell = [[XJXSwitcherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SWITCH_CELL"];
        }
        cell.field_title = @"设置为默认";
        [(XJXSwitcherCell *)cell setOn:[_form[@"isDefault"] boolValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if([self.data[@"fields"][indexPath.row][@"field_name"] isEqualToString:@"region"]){
            ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择区域位置" delegate:self showCancelButton:YES origin:tableView];
            [(UIPickerView *)picker.pickerView setTintColor:[Theme defaultTheme].schemeColor];
            [picker setTitleTextAttributes:@{NSFontAttributeName : [Theme defaultTheme].normalTextFont,NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor}];
            [picker setPickerTextAttributes:@{NSFontAttributeName : [Theme defaultTheme].normalTextFont,NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor}];
            [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:nil action:nil]];
            [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
            [picker showActionSheetPicker];
        }
    }
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)sender origin:(id)origin{
    UIPickerView *picker = (UIPickerView *)sender.pickerView;
    NSString *province = [[XJXAddressManager sharedManager] getProvince][[picker selectedRowInComponent:0]];
    NSString *city = [[XJXAddressManager sharedManager] getCitiesInProvince:province][[picker selectedRowInComponent:1]];
    NSString *region = [[XJXAddressManager sharedManager] getRegionsInCity:city province:province][[picker selectedRowInComponent:2]];
    XJXTextFieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    cell.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,region];
    
    [_form setObject:cell.text forKey:@"region"];
}

#pragma mark - actionsheet picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH / ([self numberOfComponentsInPickerView:pickerView] * 1.0);
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = @"";
    NSArray *provinces = [[XJXAddressManager sharedManager] getProvince];
    if(component == 0){
        str = provinces[row];
    }
    else if(component == 1){
        str = [[XJXAddressManager sharedManager] getCitiesInProvince:[[XJXAddressManager sharedManager] getProvince][[pickerView selectedRowInComponent:0]]][row];
    }
    else if(component == 2){
        NSString *provice = provinces[[pickerView selectedRowInComponent:0]];
        NSArray *cities = [[XJXAddressManager sharedManager] getCitiesInProvince:provice];
        NSString *city = cities[[pickerView selectedRowInComponent:1]];
        str = [[XJXAddressManager sharedManager] getRegionsInCity:city province:provice][row];
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [Theme defaultTheme].subTitleFont,
                                 NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor
                                 };
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    return attribute;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *provinces = [[XJXAddressManager sharedManager] getProvince];
    if(component == 0){
        return provinces.count;
    }
    else if(component == 1){
        return [[XJXAddressManager sharedManager] getCitiesInProvince:[[XJXAddressManager sharedManager] getProvince][[pickerView selectedRowInComponent:0]]].count;
    }
    else if(component == 2){
        NSString *provice = provinces[[pickerView selectedRowInComponent:0]];
        NSArray *cities = [[XJXAddressManager sharedManager] getCitiesInProvince:provice];
        NSString *city = cities[[pickerView selectedRowInComponent:1]];
        return [[XJXAddressManager sharedManager] getRegionsInCity:city province:provice].count;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if(component == 1){
        [pickerView reloadComponent:2];
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
