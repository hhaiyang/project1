//
//  XJXBindPhoneController.m
//  XJX
//
//  Created by Cai8 on 16/1/29.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBindPhoneController.h"
#import "XJXTextFieldCell.h"

@interface XJXBindPhoneController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XJXBindPhoneController
{
    NSUInteger countdown;
}

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
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY] - 1, SCREEN_WIDTH, 1)];
    borderView.backgroundColor = WhiteColor(0, .07);
    [self.navBar addSubview:borderView];
    
    UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"手机绑定" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UIButton *btnSave = [UIControlsUtils buttonWithTitle:@"保存" background:nil backroundImage:nil target:self selector:@selector(save:) padding:UIEdgeInsetsZero frame:CGRectZero];
    
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setLeftBarButtonItem:itemBack];
    [item setRightBarButtonItem:itemSave];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)save:(id)sender{
    XJXTextFieldCell *phoneCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XJXTextFieldCell *codeCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *phone = phoneCell.text;
    NSString *code = codeCell.text;
    [CIA verifySecurityCode:code callback:^(NSInteger code, NSString *msg, NSString *transId, NSError *err) {
        if(code == CIA_VERIFICATION_SUCCESS){
            [CommonAPI bindPhone:phone completion:^(id res, NSString *err) {
                if(!err){
                    [Session current].phone = phone;
                    [self back:nil];
                }
                else{
                    [Utils showAlert:err title:@"警告"];
                }
            }];
        }
        else{
            [Utils showAlert:msg title:@"警告"];
        }
    }];
}

- (void)initParams{
    countdown = 120;
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [self.view getH] - [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XJXTextFieldCell class] forCellReuseIdentifier:@"field"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"field";
    XJXTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.keyboardType = UIKeyboardTypePhonePad;
        cell.field_title = @"手机号";
        cell.placeholder = @"11位手机号";
    }
    else if(indexPath.row == 1){
        cell.keyboardType = UIKeyboardTypePhonePad;
        cell.field_title = @"验证码";
        cell.placeholder = @"请输入来电后四位号码";
        if(!cell.rightView){
            UIButton *btn = [UIControlsUtils buttonWithTitle:@"获取验证码" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(verifyCode:) padding:UIEdgeInsetsMake(8, 15, 8, 15) frame:CGRectZero];
            btn.layer.cornerRadius = 0.5 * [btn getH];
            [btn setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
            cell.rightView = btn;
        }
    }
    return cell;
}

- (void)countDown{
    XJXTextFieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if(countdown == 0){
        countdown = 120;
        [(UIButton *)cell.rightView setTitle:@"获取验证码" forState:UIControlStateNormal];
        [(UIButton *)cell.rightView setEnabled:YES];
    }
    else{
        [(UIButton *)cell.rightView setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)countdown] forState:UIControlStateNormal];
        
        [(UIButton *)cell.rightView setEnabled:NO]; 
        countdown--;
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }
}

- (void)verifyCode:(id)sender{
    XJXTextFieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *phone = cell.text;
    if([Validator isValid:IdentifierTypePhone value:phone]){
        [CIA startVerificationWithPhoneNumber:phone callback:^(NSInteger code, NSString *msg, NSError *err) {
            if(code == CIA_SECURITY_CODE_MODE){
                [self countDown];
            }
            else{
                [Utils showAlert:msg title:@"警告"];
            }
        }];
    }
    else{
        [Utils showAlert:@"请输入正确的电话号码" title:@"警告"];
    }
}

@end
