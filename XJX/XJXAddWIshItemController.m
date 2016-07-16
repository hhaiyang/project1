//
//  XJXAddWIshItemController.m
//  XJX
//
//  Created by Cai8 on 16/2/2.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXAddWIshItemController.h"
#import "XJXCustomWishItem.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "XJXWishItemCell.h"

@interface XJXAddWIshItemController()<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong) CHTCollectionViewWaterfallLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *wishitems;
@property (nonatomic,strong) NSMutableArray *itemSelection;

@property (nonatomic,strong) UIView *navbar;

@end

@implementation XJXAddWIshItemController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        [self initBar];
        [self setup];
    }
    return self;
}

- (void)initParams{
    self.wishitems = [NSMutableArray array];
    self.itemSelection = [NSMutableArray array];
}

- (void)initBar{
    self.navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getW], 44)];
    self.navbar.backgroundColor = WhiteColor(1, 1);
    UILabel *lb = [UIControlsUtils labelWithTitle:@"添加心愿单" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont];
    [lb verticalCenteredOnView:self.navbar];
    [lb horizontalCenteredOnView:self.navbar];
    
    UIButton *btnClose = [UIControlsUtils buttonWithTitle:@"" background:nil backroundImage:[UIImage imageNamed:@"close"] target:self selector:@selector(hide) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    [btnClose verticalCenteredOnView:self.navbar];
    [btnClose setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [btnClose getW]];
    
    [self.navbar addSubview:btnClose];
    [self.navbar addSubview:lb];
    [self addSubview:self.navbar];
}

- (void)setup{
    self.backgroundColor = WhiteColor(1, 1);
    
    [FundingAPI requestProductInWishlistOnCompletion:^(id res, NSString *err) {
        if(!err){
            self.wishitems = res;
            [res enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.itemSelection addObject:@(NO)];
            }];
            [self initUI];
        }
        else{
            [self onError];
        }
    }];
}

- (void)onError{
    
}

- (void)initUI{
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, [self getH] - 50, SCREEN_WIDTH, 50)];
    toolbar.backgroundColor = WhiteColor(1, 1);
    [toolbar enableBluredEffect];
    
    UIButton *btnOK = [UIControlsUtils buttonWithTitle:@"确定" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(ok) padding:UIEdgeInsetsZero frame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 5, [toolbar getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [toolbar getH] - 2 * 5)];
    btnOK.layer.cornerRadius = 0.5 * [btnOK getH];
    [btnOK setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    [toolbar addSubview:btnOK];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [self.navbar getMaxY], SCREEN_WIDTH, [self getH] - [self.navbar getMaxY]) collectionViewLayout:[self collectionLayout]];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XJXWishItemCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    [self addSubview:toolbar];
    
    [_collectionView setContentSize:CGSizeMake([_collectionView getW],_collectionView.contentSize.height + [toolbar getH] + 44)];
}

- (NSArray *)getCheckedItems{
    NSIndexSet *sets = [self.itemSelection indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj boolValue] == YES;
    }];
    return [self.wishitems objectsAtIndexes:sets];
}

- (void)ok{
    NSArray *selectedItems = [self getCheckedItems];
    /*WechatShareContent *content = [[WechatShareContent alloc] init];
    content.image_url = [Session current].headimgUrl;
    content.title = @"心愿单分享";
    content.desc = [selectedItems toJson];
    content.scene = kWechatShareSceneSession;
    
    [[WechatAgent defaultAgent] doShareContent:content];
    [self hide];*/
    if(self.itemSelectedHandler){
        self.itemSelectedHandler(selectedItems);
    }
    [self hide];
}

- (void)hide{
    [self pop_removeAllAnimations];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@([self getMinY]),@(self.alpha)];
    anim.toValue = @[@(SCREEN_HEIGHT),@(0)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
        [rView.superview setAlpha:[v[1] floatValue]];
    };
    [anim setCompletionBlock:^(POPAnimation *ani, BOOL finished) {
        if(finished){
            [self.superview removeFromSuperview];
        }
    }];
    [self pop_addAnimation:anim forKey:@"customHide"];

}

+ (void)showWithItemSelected:(didSelectWishItems)onSelected{
    UIView *container = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = WhiteColor(0, .4);
    container.alpha = 0;
    
    XJXAddWIshItemController *vc = [[XJXAddWIshItemController alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [container getH] * 0.75)];
    vc.itemSelectedHandler = onSelected;
    [container addSubview:vc];
    
    [[UIApplication sharedApplication].keyWindow addSubview:container];
    [vc pop_removeAllAnimations];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@(SCREEN_HEIGHT),@(vc.alpha)];
    anim.toValue = @[@(SCREEN_HEIGHT - vc.bounds.size.height),@(1)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
        [rView.superview setAlpha:[v[1] floatValue]];
    };
    [vc pop_addAnimation:anim forKey:@"customShow"];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.wishitems count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 2) / 2.0, 110 + ((SCREEN_WIDTH - 2) / 2.0));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XJXWishItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id wishitem = self.wishitems[indexPath.row];
    cell.editing = YES;
    [cell.editor setStatusChangedHandler:^(CheckEditor *editor,XJXWishItemCell *sender){
        NSIndexPath *_indexPath = [_collectionView indexPathForCell:sender];
        self.itemSelection[_indexPath.row] = @(editor.checked);
    }];
    if(![wishitem[@"isCustom"] boolValue]){
        cell.title = wishitem[@"product"][@"name"];
        cell.subTitle = [wishitem[@"model"] stringByJoinProperty:^NSString *(id item) {
            return [NSString stringWithFormat:@"%@:%@",item[@"model_attr"],item[@"model_value"]];
        } delimiter:@";"];
        cell.price = [wishitem[@"product"][@"price"] floatValue];
        cell.amount = [wishitem[@"amount"] intValue];
        [cell loadImageFromURL:SERVER_FILE_WRAPPER(wishitem[@"product"][@"image"][@"medium_thumb_image_url"])];
    }
    else{
        cell.title = wishitem[@"title"];
        cell.subTitle = wishitem[@"desc"];
        cell.price = [wishitem[@"price"] floatValue];
        cell.amount = [wishitem[@"amount"] intValue];
        [cell loadImageFromURL:wishitem[@"image_url"]];
    }
    [cell.editor setNoHandlerChecked:[self.itemSelection[indexPath.row] boolValue]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        XJXWishItemCell *cell = (XJXWishItemCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.editor.checked = ![self.itemSelection[indexPath.row] boolValue];
}


@end
