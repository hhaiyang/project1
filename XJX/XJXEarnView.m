//
//  XJXEarnView.m
//  XJX
//
//  Created by Cai8 on 16/4/26.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXEarnView.h"
#import "XJXTextFieldCell.h"
#import "XJXLabelCell.h"
#import "XJXBrandCell.h"

@interface XJXEarnView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) id data;

@property (nonatomic,strong) NSMutableDictionary *requiredForm;

@end

@implementation XJXEarnView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        [self initUI];
    }
    return self;
}

- (void)initParams{
    self.data = [NSMutableDictionary dictionary];
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

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XJXTextFieldCell class] forCellReuseIdentifier:@"field"];
    [_tableView registerClass:[XJXLabelCell class] forCellReuseIdentifier:@"label"];
    [_tableView registerClass:[XJXBrandCell class] forCellReuseIdentifier:@"brand"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        id weddingForm = self.data[@"wedding_form"];
        return [weddingForm count] + 1;
    }
    else{
        return [self.data[@"brands"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 50;
    else if(indexPath.section == 1){
        return 100 + WHITE_SPACING;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row < [self.data[@"wedding_form"] count]){
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
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comfirm"];
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comfirm"];
                UILabel *label = [UIControlsUtils labelWithTitle:@"确定" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].h3Font];
                label.frame = cell.contentView.bounds;
                label.tag = 999;
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [cell.contentView addSubview:label];
            }
            return cell;
        }
    }
    else if(indexPath.section == 1){
        id brand = self.data[@"brands"][indexPath.row];
        XJXBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brand" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = brand[@"name"];
        cell.subTitle = brand[@"desc"];
        cell.image_url = SERVER_FILE_WRAPPER(brand[@"logo"][@"tiny_thumb_image_url"]);
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row < [self.data[@"wedding_form"] count]){
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
                    
                } origin:self];
            }
            else if([form_name isEqualToString:@"city"]){
                [[XJXCities manager] requestCitiesWithCompletion:^(NSArray *cities) {
                    [ActionSheetStringPicker showPickerWithTitle:@"选择城市" rows:cities initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                        [_requiredForm setObject:selectedValue forKey:@"city"];
                        [_tableView reloadData];
                    } cancelBlock:^(ActionSheetStringPicker *picker) {
                        
                    } origin:self];
                }];
            }
            else if([form_name isEqualToString:@"guimo"]){
                id array = self.data[@"guimo"][@"array"];
                [ActionSheetStringPicker showPickerWithTitle:@"婚礼规模" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [_requiredForm setObject:selectedValue forKey:@"guimo"];
                    [_tableView reloadData];
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self];
            }
            else if([form_name isEqualToString:@"consume"]){
                id array = self.data[@"consume"][@"array"];
                [ActionSheetStringPicker showPickerWithTitle:@"人均消费" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [_requiredForm setObject:selectedValue forKey:@"consume"];
                    [_tableView reloadData];
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self];
            }
            else if([form_name isEqualToString:@"venue_type"]){
                id array = self.data[@"venue_type"][@"array"];
                [ActionSheetStringPicker showPickerWithTitle:@"场地类型" rows:array initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [_requiredForm setObject:selectedValue forKey:@"venue_type"];
                    [_tableView reloadData];
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self];
            }
        }
        else{
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
                NSMutableDictionary *submit = [NSMutableDictionary dictionary];
                [submitForm enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if(![key isEqualToString:@"time"]){
                        [submit setObject:obj forKey:key];
                    }
                }];
                [CommonAPI matchingBrandWithForm:submit completion:^(id res, NSString *err) {
                    if(!err){
                        [self.data setObject:res forKey:@"brands"];
                        [self.tableView reloadData];
                    }
                    else{
                        [Utils showAlert:err title:@"警告"];
                    }
                }];
            }

        }
    }
    else if(indexPath.section == 1){
        
    }
}

- (id)submitForm{
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
    id form = @{
             @"brands" : [[self.data[@"brands"] stringByJoinProperty:^NSString *(id item) {
                 return item[@"ID"];
             } delimiter:@","] componentsSeparatedByString:@","],
             @"requiredForm" : submitForm
             };
    NSLog([form description]);
    return form;
}

@end
