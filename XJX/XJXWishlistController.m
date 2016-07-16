//
//  XJXWishlistController.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXWishlistController.h"
#import "XJXWishItemCell.h"
#import "XJXWishlistToolbar.h"
#import "XJXCustomItemBrowser.h"
#import "XJXCustomWishItem.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface XJXWishlistController()<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) LMPullToBounceWrapper *pullToRefreshWrapper;

@property (nonatomic,strong) CHTCollectionViewWaterfallLayout *layout;

@property (nonatomic,strong) XJXWishlistToolbar *toolbar;

@property (nonatomic,strong) UIButton *btnEdit;
@property (nonatomic,strong) UIButton *btnDelete;

@property (nonatomic,assign) BOOL editing;

@property (nonatomic,assign) BOOL checkAll;

@property (nonatomic,assign) BOOL needUpdate;

@end

@implementation XJXWishlistController
{
    int page;
    int pageSize;
    BOOL noMoreData;
}

- (UIImage *)tabImage{
    return [UIImage imageNamed:@"心愿单"];
}

- (UIImage *)selectedTabImage{
    return [UIImage imageNamed:@"心愿单-selected"];
}

- (NSString *)tabTitle{
    return @"心愿单";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    page = 0;
    pageSize = 20;
    noMoreData = NO;
}

- (CHTCollectionViewWaterfallLayout *)collectionLayout {
    if (!_layout) {
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _layout.headerHeight = 0;
        _layout.footerHeight = 0;
        _layout.minimumColumnSpacing = 1;
        _layout.minimumInteritemSpacing = 5;
    }
    return _layout;
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [self load:YES completion:^(id res, NSString *err) {
        done();
    }];
}

- (void)load:(BOOL)reload completion:(onAPIRequestDone)handler{
    if(reload){
        _editing = NO;
        _checkAll = NO;
        _needUpdate = NO;
        page = 0;
        pageSize = 50;
        noMoreData = NO;
        [self.data setObject:[NSMutableArray array] forKey:@"itemSelection"];
        [self.data setObject:[NSMutableArray array] forKey:@"wishitems"];
        
        [[self.view viewWithTag:999] removeFromSuperview];
    }
    [FundingAPI requestProductInWishlistOnCompletion:^(id res, NSString *err) {
        if(!err){
            [self.data[@"wishitems"] addObjectsFromArray:res];
            [res enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.data[@"itemSelection"] addObject:@(NO)];
            }];
            [[self collectionView] reloadData];
            handler(res,nil);
            
            [self emptyDetect];
        }
        else{
            [self onError];
        }
    }];
}

- (void)emptyDetect{
    if([self.data[@"wishitems"] count] == 0){
        [self onEmpty];
    }
}

- (void)reload{
    [self load:YES completion:^(id res, NSString *err) {
        
    }];
}

- (void)initParams{
    [[self.view viewWithTag:999] removeFromSuperview];
    
    [self resetStatus];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:WhiteColor(1, 1)];
    [self.navBar setBackgroundColor:WhiteColor(1, 1)];
    /*UIButton *btnBack = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"return"] target:self selector:@selector(back:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    [btnBack setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [btnBack setY:20 + (44 - btnBack.bounds.size.height) / 2.0];
    [self.navBar addSubview:btnBack];*/
    
    UILabel *naviTitleLb = [UIControlsUtils labelWithTitle:@"心愿单" color:[Theme defaultTheme].naviTitleColor font:[Theme defaultTheme].h3Font textAlignment:NSTextAlignmentCenter];
    
    _btnEdit = [UIControlsUtils buttonWithTitle:@"编辑" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(edit:) padding:UIEdgeInsetsMake(2, 10, 2, 10) frame:CGRectZero];
    _btnDelete = [UIControlsUtils buttonWithTitle:@"删除" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(delete:) padding:UIEdgeInsetsMake(2, 10, 2, 10) frame:CGRectZero];
    
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:_btnEdit];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setTitleView:naviTitleLb];
    [item setRightBarButtonItems:@[itemEdit] animated:YES];
    [self.navBar pushNavigationItem:item animated:NO];
    [self addSubview:self.navBar];
}

- (void)edit:(id)sender{
    _editing = !_editing;
    [self resetStatus];
}

- (void)delete:(id)sender{
    NSArray *selectedItems = [self getCheckedItems];
    if(selectedItems.count > 0){
        [Utils comfirmWithPromt:@"确认删除心愿单内容" title:@"信息" comfirm:^{
            NSArray *customItems = [selectedItems itemsWithPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj[@"isCustom"] boolValue];
            }];
            NSArray *wishitems = [selectedItems itemsWithPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return ![obj[@"isCustom"] boolValue];
            }];
            NSString *wishitem_ids = [wishitems stringByJoinProperty:^NSString *(id item) {
                return item[@"ID"];
            } delimiter:@","];
            NSString *custom_wishitem_ids = [customItems stringByJoinProperty:^NSString *(id item) {
                return item[@"ID"];
            } delimiter:@","];
            [FundingAPI deleteItemFromWishlistWithWishItemId:wishitem_ids customIds:custom_wishitem_ids completion:^(id res, NSString *err) {
                if(!err){
                    NSMutableArray *indexesPathes = [NSMutableArray array];
                    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
                    NSArray *items = [self getCheckedItems];
                    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSUInteger index = [self.data[@"wishitems"] indexOfObject:obj];
                        [sets addIndex:index];
                        
                        [indexesPathes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    }];
                    [self.data[@"wishitems"] removeObjectsAtIndexes:sets];
                    [self.data[@"itemSelection"] removeObjectsAtIndexes:sets];
                    [self.collectionView deleteItemsAtIndexPaths:indexesPathes];
                    [self edit:nil];
                    
                    [self emptyDetect];
                }
                else{
                    NSLog(err);
                }
            }];
        }];
    }
    else{
        [self edit:nil];
    }
}

- (void)update{
    if(self.needUpdate){
        [self reload];
    }
}

- (void)onError{
    [Utils showAlert:[self.exception description] title:@"警告"];
    [self.pullToRefreshWrapper stopLoadingAnimation];
}

- (void)onEmpty{
    UIImageView *emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 272, 177)];
    [emptyImage setImage:[UIImage imageNamed:@"wishlist_empty"]];
    [emptyImage verticalCenteredOnView:self.view];
    [emptyImage horizontalCenteredOnView:self.view];
    emptyImage.tag = 999;
    [self addSubview:emptyImage];
}

- (void)registerNotifications{
    [NotificationRegistrator registerNotificationOnTarget:self name:NOTI_WISH_NEED_UPDATE selector:@selector(wishlistNeedUpdate:)];
}

- (void)wishlistNeedUpdate:(NSNotification *)noti{
    self.needUpdate = YES;
}

- (NSArray *)getCheckedItems{
    NSIndexSet *sets = [self.data[@"itemSelection"] indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj boolValue] == YES;
    }];
    return [self.data[@"wishitems"] objectsAtIndexes:sets];
}

- (void)resetStatus{
    if(_editing){
        [_btnEdit setTitle:@"完成" forState:UIControlStateNormal];
        UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:_btnEdit];
        UIBarButtonItem *itemDelete = [[UIBarButtonItem alloc] initWithCustomView:_btnDelete];
        [self.navBar.items[0] setRightBarButtonItems:@[itemDelete,itemEdit] animated:YES];
        
        UIButton *btnCheckAll = [UIControlsUtils buttonWithTitle:@"全选" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(checkAll:) padding:UIEdgeInsetsMake(2, 10, 2, 10) frame:CGRectZero];
        UIBarButtonItem *itemCheckAll = [[UIBarButtonItem alloc] initWithCustomView:btnCheckAll];
        [self.navBar.items[0] setLeftBarButtonItems:@[itemCheckAll] animated:YES];
        
    }
    else{
        [_btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:_btnEdit];
        [self.navBar.items[0] setLeftBarButtonItem:nil animated:YES];
        [self.navBar.items[0] setRightBarButtonItems:@[itemEdit] animated:YES];
        
        
        [self setAllSelected:NO];
    }
    [[_collectionView visibleCells] enumerateObjectsUsingBlock:^(XJXWishItemCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.editing = _editing;
    }];
    
    [_collectionView setContentSize:CGSizeMake([_collectionView getW], MAX(_collectionView.contentSize.height,SCREEN_HEIGHT))];
}

- (void)checkAll:(id)sender{
    _checkAll = !_checkAll;
    if(_checkAll){
        [(UIButton *)[self.navBar.items[0].leftBarButtonItem customView] setTitle:@"全不选" forState:UIControlStateNormal];
        [(UIButton *)[self.navBar.items[0].leftBarButtonItem customView] recalculateSize];
    }
    else{
        [(UIButton *)[self.navBar.items[0].leftBarButtonItem customView] setTitle:@"全选" forState:UIControlStateNormal];
        [(UIButton *)[self.navBar.items[0].leftBarButtonItem customView] recalculateSize];
    }
    [self setAllSelected:_checkAll];
}

- (void)setAllSelected:(BOOL)selected{
    [self.data[@"itemSelection"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.data[@"itemSelection"][idx] = @(selected);
    }];
    [[_collectionView visibleCells] enumerateObjectsUsingBlock:^(XJXWishItemCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.editor setNoHandlerChecked:selected];
    }];
}

- (void)initUI{
    WS(_self);
    self.view.backgroundColor = [Theme defaultTheme].schemeColor;

    _toolbar = [[XJXWishlistToolbar alloc] initWithFrame:CGRectMake(0, [self.view getH] - 50, SCREEN_WIDTH, 50)];
    _toolbar.backgroundColor = WhiteColor(1, 1);
    _toolbar.urlAddedHandler = ^(NSString *url){
        [_self processCustomUrl:url];
    };
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.navBar getMaxY], SCREEN_WIDTH, [_toolbar getMinY] - [self.navBar getMaxY])];

    UIScrollView *scrollerWrapper = [[UIScrollView alloc] initWithFrame:containerView.bounds];
    UIView *backgroundView = [[UIView alloc] initWithFrame:_collectionView.bounds];
    backgroundView.backgroundColor = WhiteColor(1, 1);
    _collectionView = [[UICollectionView alloc] initWithFrame:containerView.bounds collectionViewLayout:[self collectionLayout]];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundView = backgroundView;
    [_collectionView registerClass:[XJXWishItemCell class] forCellWithReuseIdentifier:@"cell"];
    [scrollerWrapper addSubview:_collectionView];
    
    _pullToRefreshWrapper = [[LMPullToBounceWrapper alloc] initWithScrollView:scrollerWrapper];
    [containerView addSubview:_pullToRefreshWrapper];
    
    [_pullToRefreshWrapper setDidPullTorefresh:^(){
        [_self loadDataWithCompletion:^{
            [_self initParams];
            [_self.collectionView reloadData];
            [_self.pullToRefreshWrapper stopLoadingAnimation];
        }];
    }];
    
    [self addSubview:containerView];
    [self addSubview:_toolbar];
    
    [_collectionView layoutIfNeeded];
    scrollerWrapper.contentSize = CGSizeMake(SCREEN_WIDTH, MAX([_collectionView getH],_collectionView.contentSize.height) + 1);
}

- (void)processCustomUrl:(NSString *)url{
    if([url isEmpty]){
        return;
    }
    @try {
        if(![url isStartWithString:@"http"])
            url = [NSString stringWithFormat:@"http%@",[url stringFromString:@"http" to:@" "]];
        _toolbar.urlField.text = url;
        NSURL *_url = [url normalizeNSURL];
        if(_url){
            //Processing
            [_toolbar startLoadingAnimationOnCompletion:^(XJXWishlistToolbar *toolbar) {
                [XJXCustomItemBrowser analysisItemWithUrl:url completion:^(XJXCustomWishItem *item) {
                    if(item.image_url && item.title && item.amount > 0){
                        [FundingAPI addCustomItemToWishlist:item completion:^(id res, NSString *err) {
                            if(!err){
                                [NotificationView sharedView].titleLabel.text = [NSString stringWithFormat:@"%@已添加至心愿单",item.title];
                                [[NotificationView sharedView].imageView lazyWithUrl:item.image_url];
                                [[NotificationView sharedView] show];
                                
                            }
                            else{
                                NSLog(err);
                            }
                        }];
                    }
                    [_toolbar stopAnimation];
                }];
            }];
        }
        else{
            _toolbar.urlField.text = @"";
            [NotificationView sharedView].titleLabel.text = @"URL格式非法";
            [[NotificationView sharedView] show];
        }
    }
    @catch (NSException *exception) {
        _toolbar.urlField.text = @"";
        [NotificationView sharedView].titleLabel.text = @"URL格式非法";
        [[NotificationView sharedView] show];
    }
}

#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.data[@"wishitems"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 2) / 2.0, 110 + ((SCREEN_WIDTH - 2) / 2.0));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XJXWishItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id wishitem = self.data[@"wishitems"][indexPath.row];
    cell.editing = _editing;
    [cell.editor setStatusChangedHandler:^(CheckEditor *editor,XJXWishItemCell *sender){
        NSIndexPath *_indexPath = [_collectionView indexPathForCell:sender];
        self.data[@"itemSelection"][_indexPath.row] = @(editor.checked);
    }];
    if(![wishitem[@"isCustom"] boolValue]){
        cell.title = wishitem[@"product"][@"name"];
        cell.subTitle = [wishitem[@"model"] stringByJoinProperty:^NSString *(id item) {
            return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
        } delimiter:@";"];
        cell.price = [wishitem[@"product"][@"price"] floatValue] / 100.0;
        cell.amount = [wishitem[@"amount"] intValue];
        [cell loadImageFromURL:SERVER_FILE_WRAPPER(wishitem[@"product"][@"image"][@"medium_thumb_image_url"])];
    }
    else{
        cell.title = wishitem[@"title"];
        cell.subTitle = wishitem[@"desc"];
        cell.price = [wishitem[@"price"] floatValue] / 100.0;
        cell.amount = [wishitem[@"amount"] intValue];
        [cell loadImageFromURL:wishitem[@"image_url"]];
    }
    [cell.editor setNoHandlerChecked:[self.data[@"itemSelection"][indexPath.row] boolValue]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_editing){
        XJXWishItemCell *cell = (XJXWishItemCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.editor.checked = ![self.data[@"itemSelection"][indexPath.row] boolValue];
    }
    else{
        id wishitem = self.data[@"wishitems"][indexPath.row];
        if([wishitem[@"isCustom"] boolValue]){
            [[XJXLinkageRouter defaultRouter] routeToLink:wishitem[@"url"]];
        }
        else{
            id product = wishitem[@"product"];
            NSString *base64 = [[product toJson] toBase64];
            [[XJXLinkageRouter defaultRouter] routeToLink:[NSString stringWithFormat:@"hnh://product?product=%@",base64]];
        }
    }
}

@end
