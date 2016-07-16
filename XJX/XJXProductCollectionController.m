//
//  XJXProductCollectionController.m
//  XJX
//
//  Created by Cai8 on 16/1/14.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProductCollectionController.h"
#import "XJXProductCell.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>


@interface XJXProductCollectionController ()<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) loadData dataLoader;

@end

@implementation XJXProductCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    data = [NSMutableArray array];
    page = 0;
    pageSize = 20;
    noMoreData = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 1;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navBar.bounds.size.height, SCREEN_WIDTH, self.bounds.size.height - self.navBar.bounds.size.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XJXProductCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)loadDataWithCompletion:(onActionDone)done{
    if(self.externalParams){
        _dataLoader = self.externalParams[@"dataLoader"];
        if(_dataLoader){
            done();
            _dataLoader(page,pageSize,^(NSArray *res,NSString *err){
                if(!err){
                    [data addObjectsFromArray:res];
                    [[self collectionView] reloadData];
                }
                else{
                    NSLog(err);
                }
            });
        }
        else{
            [self onError];
        }
    }
}

- (void)initParams{
    data = [NSMutableArray array];
    page = 0;
    pageSize = 20;
    noMoreData = NO;
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
    [btnBack setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [btnBack setY:20 + (44 - btnBack.bounds.size.height) / 2.0];
    [self.navBar addSubview:btnBack];
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:self.externalParams[@"title"] color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.externalParams[@"title"]];
    [item setTitleView:naviTitleLb];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)initUI{
    [self addSubview:[self collectionView]];
}

#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [data count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 2) / 2.0, 90 + ((SCREEN_WIDTH - 2) / 2.0));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XJXProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.title = data[indexPath.row][@"brand"];
    cell.subTitle = data[indexPath.row][@"name"];
    cell.price = [data[indexPath.row][@"price"] floatValue] / 100.0;
    [cell loadImageFromURL:SERVER_FILE_WRAPPER(data[indexPath.row][@"image"][@"medium_thumb_image_url"])];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    onClick onClickHandler = self.externalParams[@"clickHandler"];
    if(onClickHandler){
        onClickHandler(data[indexPath.row]);
    }
}

- (void)dealloc{
    self.dataLoader = nil;
    [data removeAllObjects];
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
