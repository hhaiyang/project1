//
//  XJXBrandMatchingController.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBrandMatchingController.h"
#import "XJXBrandCell.h"

@interface XJXBrandMatchingController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XJXBrandMatchingController

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
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"广告匹配" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
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
    if(self.stepDoneHandler){
        self.stepDoneHandler(self,self.data[@"brands"],NO);
    }
}

- (void)loadDataWithCompletion:(onActionDone)done{
    id param = [self getValueFromParamKey:@(0)];
    NSMutableDictionary *submit = [NSMutableDictionary dictionary];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if(![key isEqualToString:@"time"]){
            [submit setObject:obj forKey:key];
        }
    }];
    [CommonAPI matchingBrandWithForm:submit completion:^(id res, NSString *err) {
        if(!err){
            [self.data setObject:res forKey:@"brands"];
            done();
        }
        else{
            [self onError];
        }
    }];
}

- (void)initParams{
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [self.view getH] - [self.navBar getMaxY]) style:UITableViewStyleGrouped];
    [_tableView registerClass:[XJXBrandCell class] forCellReuseIdentifier:@"brand"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    self.view.backgroundColor = WhiteColor(.95, 1);
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data[@"brands"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100 + WHITE_SPACING;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id brand = self.data[@"brands"][indexPath.row];
    XJXBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brand" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = brand[@"name"];
    cell.subTitle = brand[@"desc"];
    cell.image_url = SERVER_FILE_WRAPPER(brand[@"logo"][@"tiny_thumb_image_url"]);
    return cell;
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
