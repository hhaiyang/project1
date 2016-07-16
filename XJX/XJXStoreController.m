//
//  StroeController.m
//  XJX
//
//  Created by Cai8 on 15/11/19.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import "XJXStoreController.h"
#import "XJXGrid.h"
#import "XJXSlider.h"
#import "XJXBanner.h"
#import "XJXProduct.h"
#import "SectionContainer.h"

#define BANNER_HEIGHT 220
#define PRODUCT_ICON_MARGIN 40
#define PRODUCT_SCROLLER_ITEM_PADDING 20
#define PRODUCT_SCROLLER_HEIGHT 120

@interface XJXStoreController()<YSLTransitionAnimatorDataSource>
{
    UIScrollView *baseView;
}

@property (nonatomic,strong) XJXSlider *banner;
@property (nonatomic,strong) XJXSlider *popularScroller;

@property (nonatomic,strong) XJXGrid *sceneGrid;
@property (nonatomic,strong) XJXGrid *articleGrid;

@end

@implementation XJXStoreController{
    CGFloat y_offset;
}

- (UIImage *)tabImage{
    return [UIImage imageNamed:@"商城"];
}

- (UIImage *)selectedTabImage{
    return [UIImage imageNamed:@"商城-selected"];
}

- (NSString *)tabTitle{
    return @"推荐";
}

- (UIScrollView *)baseView{
    if(!baseView){
        baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        if(self.navBar)
            [self.view insertSubview:baseView belowSubview:self.navBar];
        else{
            [self.view addSubview:baseView];
        }
    }
    return baseView;
}

- (void)initBG{
    self.view.backgroundColor = rgba(255,255,255,1);
}

- (void)viewWillDisappear:(BOOL)animated{
    [self ysl_removeTransitionDelegate];
}

- (UIImageView *)pushTransitionImageView{
    return [[_popularScroller selectingSlide] coverView];
}

- (UIImageView *)popTransitionImageView{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:0
                                                   animationDuration:0.3];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    [ShopAPI requestShopDetailWithCompletion:^(id res, NSString *err) {
        if(!err){
            self.data = res;
            done();
        }
        else{
            [self onError];
        }
    }];
}

- (void)onError{
    [[self.view viewWithTag:12] removeFromSuperview];
    UIButton *errBtn = [UIControlsUtils buttonWithTitle:@"获取数据失败,点击重试" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(setup) padding:UIEdgeInsetsMake(5, 12, 5, 12) frame:CGRectZero];
    [errBtn setX:(self.view.bounds.size.width - errBtn.bounds.size.width) / 2];
    [errBtn setY:(self.view.bounds.size.height - errBtn.bounds.size.height) / 2];
    errBtn.tag = 12;
    [self.view addSubview:errBtn];
}

- (void)initParams{
    __weak XJXStoreController *_self = self;
    
    _banner = [XJXSlider sliderWithData:@[@"slide1",@"slide2",@"slide3"] frame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT) spacing:0 onViewCreated:^XJXSlide *(NSUInteger index, id item) {
        XJXSlide *slide = [[XJXSlide alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT)];
        return slide;
    } onViewReused:^(XJXSlide *slide, NSUInteger index, id item) {
        [slide.coverView setImage:[UIImage imageWithFile:item type:@"jpg"]];
    } onViewTouched:^(NSUInteger index, XJXSlide *item) {
//        id article = self.data[@"article"][[self.data[@"article"] count] - 1 - index];
//        NSString *base64 = [[article toJson] toBase64];
//        [[XJXLinkageRouter defaultRouter] routeToLink:[NSString stringWithFormat:@"hnh://article?article=%@&title=%@",base64,article[@"title"]]];
    }];
    _banner.enablePageIndicator = YES;
    _banner.pageEnable = YES;
    _banner.backgroundColor = hex(@"#dfdfdf");
    
    _popularScroller = [XJXSlider sliderWithData:self.data[@"product"] frame:CGRectMake(0, 0, SCREEN_WIDTH, PRODUCT_SCROLLER_HEIGHT) spacing:PRODUCT_ICON_MARGIN onViewCreated:^XJXSlide *(NSUInteger index, id item) {
        XJXSlide *slide = [[XJXSlide alloc] initWithFrame:CGRectMake(0, 0, PRODUCT_SCROLLER_HEIGHT - PRODUCT_SCROLLER_ITEM_PADDING * 2, PRODUCT_SCROLLER_HEIGHT - PRODUCT_SCROLLER_ITEM_PADDING * 2)];
        slide.backgroundColor = WhiteColor(.95, 1);
        return slide;
    } onViewReused:^(XJXSlide *slide, NSUInteger index, id item) {
        [slide loadImageFromUrl:SERVER_FILE_WRAPPER(item[@"image"][@"tiny_thumb_image_url"])];
    } onViewTouched:^(NSUInteger index, XJXSlide *item) {
        NSString *base64 = [[self.data[@"product"][index] toJson] toBase64];
        [[XJXLinkageRouter defaultRouter] routeToLink:[NSString stringWithFormat:@"hnh://product?product=%@",base64]];
    }];
    
    __block NSMutableArray *sceneBricks = [NSMutableArray array];
    [self.data[@"category"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJXBrick *brick = [[XJXBrick alloc] init];
        brick.identifier = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
        brick.title = obj[@"name"];
        brick.image_url = [NSString stringWithFormat:@"%@%@",BASE_URL,obj[@"cover_image_url"]];
        brick.titleFont = [Theme defaultTheme].titleFont;
        brick.titleColor = [UIColor whiteColor];
        [sceneBricks addObject:brick];
    }];
    
    __block NSMutableArray *articleBricks = [NSMutableArray array];
    [self.data[@"article"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJXBrick *brick = [[XJXBrick alloc] init];
        brick.identifier = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
        brick.title = obj[@"title"];
        brick.titleFont = [Theme defaultTheme].titleFont;
        brick.titleColor = [UIColor whiteColor];
        brick.image_url = SERVER_FILE_WRAPPER(obj[@"image"][@"big_thumb_image_url"]);
        [articleBricks addObject:brick];
    }];
    
    _sceneGrid = [[XJXGrid alloc] init];
    _sceneGrid.bricks = sceneBricks;
    _sceneGrid.onItemSelected = ^(XJXBrick *brick){
        //Select Category
        NSInteger index = [[brick identifier] integerValue];
        id category = _self.data[@"category"][index];
        [[XJXLinkageRouter defaultRouter] routeToLink:[NSString stringWithFormat:@"hnh://category?category_id=%d&category_name=%@",[category[@"ID"] intValue],category[@"name"]]];
    };
    _articleGrid = [[XJXGrid alloc] init];
    _articleGrid.bricks = articleBricks;
    _articleGrid.NUM_HORI = 1;
    _articleGrid.onItemSelected = ^(XJXBrick *brick){
        //Select Article
        NSInteger index = [[brick identifier] integerValue];
        id article = _self.data[@"article"][index];
        NSString *base64 = [[article toJson] toBase64];
        [[XJXLinkageRouter defaultRouter] routeToLink:[NSString stringWithFormat:@"hnh://article?article=%@&title=%@",base64,article[@"title"]]];
    };
    
    [_popularScroller selectSlideOnIndex:MIN(2, [self.data[@"product"] count] / 2)];
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    /*UIButton *btnScan = [UIControlsUtils buttonWithTitle:nil background:[Theme defaultTheme].naviButtonColor backroundImage:[UIImage imageNamed:@"codescan"] target:self selector:@selector(codescan:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    btnScan.layer.cornerRadius = 0.5 * NAVBAR_ICON_SIZE;
    
    UIButton *btnMessage = [UIControlsUtils buttonWithTitle:nil background:[Theme defaultTheme].naviButtonColor backroundImage:[UIImage imageNamed:@"message"] target:self selector:@selector(message:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    btnMessage.layer.cornerRadius = 0.5 * NAVBAR_ICON_SIZE;

    UIBarButtonItem *itemScan = [[UIBarButtonItem alloc] initWithCustomView:btnScan];
    UIBarButtonItem *itemMessage = [[UIBarButtonItem alloc] initWithCustomView:btnMessage];*/
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    //[item setRightBarButtonItems:@[itemScan,itemMessage]];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)codescan:(id)sender{
    
}

- (void)message:(id)sender{
    
}

- (void)initUI{
    y_offset = _banner.frame.origin.y;
    
    [[self baseView] addSubview:_banner];
    
    y_offset = [_banner getMaxY];
    
    SectionContainer *section_popular = [[SectionContainer alloc] init];
    section_popular.backgroundColor = WhiteColor(.98, 1);
    section_popular.padding = UIEdgeInsetsMake([Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    section_popular.title = @"人气推荐";
    section_popular.subTitle = @"Popular products";
    section_popular.titleColor = [Theme defaultTheme].sectionTitleColor;
    section_popular.subTitleColor = [Theme defaultTheme].sectionSubTitleColor;
    section_popular.titleFont = [Theme defaultTheme].sectionTitleFont;
    section_popular.subTitleFont = [Theme defaultTheme].sectionSubTitleFont;
    section_popular.contentView = _popularScroller;
    [section_popular renderOnPoint:CGPointMake(0, y_offset) onView:[self baseView]];
    
    y_offset += [section_popular getHeight];
    
    SectionContainer *section_category = [[SectionContainer alloc] init];
    section_category.backgroundColor = WhiteColor(0.95, 1);
    section_category.padding = UIEdgeInsetsMake([Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    //section_category.title = @"场景分类";
    //section_category.subTitle = @"Scene classification";
    section_category.titleColor = [Theme defaultTheme].sectionTitleColor;
    section_category.subTitleColor = [Theme defaultTheme].sectionSubTitleColor;
    section_category.titleFont = [Theme defaultTheme].sectionTitleFont;
    section_category.subTitleFont = [Theme defaultTheme].sectionSubTitleFont;
    section_category.contentView = [_sceneGrid render];
    [section_category renderOnPoint:CGPointMake(0, y_offset) onView:[self baseView]];
    
    y_offset += [section_category getHeight];
    
    SectionContainer *section_article = [[SectionContainer alloc] init];
    section_article.backgroundColor = [UIColor whiteColor];
    section_article.padding = UIEdgeInsetsMake([Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    section_article.title = @"专题";
    section_article.subTitle = @"Special";
    section_article.titleColor = [Theme defaultTheme].sectionTitleColor;
    section_article.subTitleColor = [Theme defaultTheme].sectionSubTitleColor;
    section_article.titleFont = [Theme defaultTheme].sectionTitleFont;
    section_article.subTitleFont = [Theme defaultTheme].sectionSubTitleFont;
    section_article.contentView = [_articleGrid render];
    [section_article renderOnPoint:CGPointMake(0, y_offset) onView:[self baseView]];
    
    y_offset += [section_article getHeight];
    
    [[self baseView] setContentSize:CGSizeMake(SCREEN_WIDTH, y_offset)];
}

@end
