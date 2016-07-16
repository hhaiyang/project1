//
//  XJXReservationRequirementController.m
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationRequirementController.h"

#import "XJXTextFieldCell.h"
#import "XJXLabelCell.h"

@interface XJXReservationRequirementController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *requiredForm;

@end

@implementation XJXReservationRequirementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParams{
    NSArray *form = @[@{
                                   @"title" : @"婚礼日期",
                                   @"type" : @"label",
                                   @"detail" : @"请选择婚礼日期",
                                   @"name" : @"time"
                                   },
                                 @{
                                   @"title" : @"婚礼城市",
                                   @"type" : @"label",
                                   @"detail" : @"选择您所在的城市",
                                   @"name" : @"city"
                                   },
                                @{
                                  @"title" : @"婚礼规模",
                                  @"type" : @"label",
                                  @"detail" : @"选择您婚礼的平均消费",
                                  @"name" : @"guimo"
                                  },
                                 @{
                                   @"title" : @"平均消费",
                                   @"type" : @"label",
                                   @"detail" : @"选择您婚礼的平均消费",
                                   @"name" : @"consume"
                                   },
                                 @{
                                   @"title" : @"酒店类型",
                                   @"type" : @"label",
                                   @"detail" : @"请选择酒店类型",
                                   @"name" : @"venue_type"
                                   }];
    [self.data setObject:form forKey:@"wedding_form"];
    
    id venue_array = @[
                       @"浪漫花园",
                       @"豪华酒店",
                       @"假日酒店",
                       @"海滨别墅",
                       @"世外桃源"
                       ];
    id venue_value = @[
                       @"5",
                       @"4",
                       @"3",
                       @"2",
                       @"1"
                       ];
    id guimo_array = @[
                       @"小于150人",
                       @"150 - 200人",
                       @"200 - 300人",
                       @"300人以上"
                       ];
    id guimo_value = @[
                       @"150",
                       @"185",
                       @"250",
                       @"300"
                       ];
    
    id consume_array = @[
                         @"200 - 300 RMB",
                         @"300 - 400 RMB",
                         @"500 - 600 RMB",
                         @"600 RMB 以上"
                         ];
    id consume_value = @[
                         @"250",
                         @"350",
                         @"550",
                         @"600"
                         ];
    
    [self.data setObject:@{@"array" : venue_array,@"value" : venue_value} forKey:@"venue_type"];
    [self.data setObject:@{@"array" : guimo_array,@"value" : guimo_value} forKey:@"guimo"];
    [self.data setObject:@{@"array" : consume_array,@"value" : consume_value} forKey:@"consume"];
    
    _requiredForm = [NSMutableDictionary dictionary];
    [form enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_requiredForm setObject:@"" forKey:obj[@"name"]];
    }];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"定制您的婚礼" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UIButton *btnSave = [UIControlsUtils buttonWithTitle:@"保存" background:nil backroundImage:nil target:self selector:@selector(save:) padding:UIEdgeInsetsZero frame:CGRectZero];
    
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [item setRightBarButtonItem:itemSave];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [self.view getH] - [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XJXTextFieldCell class] forCellReuseIdentifier:@"field"];
    [_tableView registerClass:[XJXLabelCell class] forCellReuseIdentifier:@"label"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)save:(id)sender{
    NSInteger index = [[_requiredForm allValues] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isEqualToString:@""];
    }];
    if(index != NSNotFound){
        [Utils showAlert:@"表格内容不能为空" title:@"警告"];
        return;
    }
    else{
        NSMutableDictionary *submitForm = [NSMutableDictionary dictionary];
        [_requiredForm enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([key isEqualToString:@"city"]){
                [submitForm setObject:obj forKey:key];
            }
            else if([key isEqualToString:@"time"]){
                [submitForm setObject:obj forKey:key];
            }
            else{
                NSArray *array = self.data[key][@"array"];
                NSArray *values = self.data[key][@"value"];
                [submitForm setObject:values[[array indexOfObject:obj]] forKey:key];
            }
        }];
        [submitForm setObject:@[] forKey:@"pis"];
        [submitForm setObject:@(MAX_BRNADS_MATCHING) forKey:@"maxiumNumberOfBrands"];
        if(self.stepDoneHandler){
            self.stepDoneHandler(self,submitForm,NO);
        }
    }
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id weddingForm = self.data[@"wedding_form"];
    return [weddingForm count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id wedding_form = self.data[@"wedding_form"][indexPath.row];
    NSString *detail = _requiredForm[wedding_form[@"name"]];
    
    XJXFormFieldCell *cell;
    NSString *cellid = wedding_form[@"type"];
    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setField_title:wedding_form[@"title"]];
    
    if([cellid isEqualToString:@"label"]){
        if(!detail){
            [(XJXLabelCell *)cell setDetail_text:wedding_form[@"detail"]];
        }
        else{
            [(XJXLabelCell *)cell setDetail_text:detail];
        }
    }
    else if([cellid isEqualToString:@"field"]){
        if(!detail){
            [(XJXTextFieldCell *)cell setPlaceholder:wedding_form[@"detail"]];
        }
        else{
            [(XJXTextFieldCell *)cell setText:detail];
        }
    }
    cell.accessoryEnabled = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id wedding_form = self.data[@"wedding_form"][indexPath.row];
    NSString *form_name = wedding_form[@"name"];
    if([form_name isEqualToString:@"time"]){
        NSString *title = @"选择婚礼开始日期";
        UIDatePickerMode mode = UIDatePickerModeDateAndTime;
        NSDate *selectDate = [NSDate date];
        NSDate *minimumDate = [NSDate date];
        NSDate *maximumDate = [[NSDate date] dateByAddingTimeInterval:1000 * 60 * 60 * 24 * 365];
        [ActionSheetDatePicker showPickerWithTitle:title datePickerMode:mode selectedDate:selectDate minimumDate:minimumDate maximumDate:maximumDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            [_requiredForm setObject:[Utils stringFromDate:selectedDate formatter:@"yyyy年 MM月 dd日 HH:mm"] forKey:wedding_form[@"name"]];
            [_tableView reloadData];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:self.view];
    }
    else if([form_name isEqualToString:@"city"]){
        [[XJXCities manager] requestCitiesWithCompletion:^(NSArray *cities) {
            [ActionSheetStringPicker showPickerWithTitle:@"选择城市" rows:cities initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                [_requiredForm setObject:selectedValue forKey:@"city"];
                [_tableView reloadData];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }];
    }
    else if([form_name isEqualToString:@"guimo"]){
        id array = self.data[@"guimo"][@"array"];
        [ActionSheetStringPicker showPickerWithTitle:@"婚礼规模" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [_requiredForm setObject:selectedValue forKey:@"guimo"];
            [_tableView reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }
    else if([form_name isEqualToString:@"consume"]){
        id array = self.data[@"consume"][@"array"];
        [ActionSheetStringPicker showPickerWithTitle:@"人均消费" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [_requiredForm setObject:selectedValue forKey:@"consume"];
            [_tableView reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }
    else if([form_name isEqualToString:@"venue_type"]){
        id array = self.data[@"venue_type"][@"array"];
        [ActionSheetStringPicker showPickerWithTitle:@"场地类型" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [_requiredForm setObject:selectedValue forKey:@"venue_type"];
            [_tableView reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
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
