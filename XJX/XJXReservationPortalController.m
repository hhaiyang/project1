//
//  XJXReservationPortalController.m
//  XJX
//
//  Created by Cai8 on 16/3/30.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationPortalController.h"
#import "XJXSlider.h"
#import "XJXSlide.h"
#import "XJXGrid.h"
#import "XJXReservationMenuBrick.h"
#import "XJXReservationController.h"
#import "XJXEarnController.h"

@interface XJXReservationPortalController()

@property (nonatomic,strong) XJXSlider *slider;
@property (nonatomic,strong) XJXGrid *menuGrid;

@property (nonnull,strong) UIScrollView *scroller;

@property (nonnull,strong) UIView *menuGridRenderingView;

@end

@implementation XJXReservationPortalController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (UIImage *)tabImage{
    return [[UIImage imageNamed:@"喜讯-nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)selectedTabImage{
    return [[UIImage imageNamed:@"喜讯-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (NSString *)tabTitle{
    return @"喜讯";
}

- (void)initNav{
    
}

- (void)loadDataWithCompletion:(onActionDone)done{
    done();
}

- (void)initParams{
    id bricks = @[@{
                      @"menu-bg" : @"reservation-menu-bg-invitation",
                      @"menu-icon" : @"reservation-menu-icon-invitation",
                      @"id" : @"invitation"
                      },
                  @{
                      @"menu-bg" : @"reservation-menu-bg-wish",
                      @"menu-icon" : @"reservation-menu-icon-wish",
                      @"id" : @"wish"
                      },
                  @{
                      @"menu-bg" : @"reservation-menu-bg-money",
                      @"menu-icon" : @"reservation-menu-icon-money",
                      @"id" : @"money"
                      }];
    [self.data setObject:bricks forKey:@"bricks"];
    
    id slides = @[@"slide1",@"slide2",@"slide3"];
    [self.data setObject:slides forKey:@"slides"];
}

- (UIScrollView *)baseView{
    if(!self.scroller){
        self.scroller = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.view addSubview:self.scroller];
    }
    return self.scroller;
}

- (void)initUI{
    WS(_self);
    self.slider = [XJXSlider sliderWithData:self.data[@"slides"] frame:CGRectMake(0, 0, SCREEN_WIDTH, 250) spacing:0 onViewCreated:^XJXSlide *(NSUInteger index, id item) {
        XJXSlide *slide = [[XJXSlide alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [_self.slider getH])];
        return slide;
    } onViewReused:^(XJXSlide *slide, NSUInteger index, id item) {
        //[slide loadImageFromUrl:item[@"image"][@"big_thumb_image_url"]];
        UIImage *image = [UIImage imageWithFile:item type:@"jpg"];
        slide.coverView.image = image;
    } onViewTouched:^(NSUInteger index, id item) {
        
    }];
    self.slider.pageEnable = YES;
    self.slider.enablePageIndicator = YES;
    
    [self baseView].parallaxHeader.view = self.slider;
    [self baseView].parallaxHeader.height = [self.slider getH];
    [self baseView].parallaxHeader.minimumHeight = 0;
    
    NSMutableArray *bricks = [NSMutableArray array];
    [self.data[@"bricks"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJXReservationMenuBrick *brick = [[XJXReservationMenuBrick alloc] init];
        brick.backgroundImage = [UIImage imageWithFile:self.data[@"bricks"][idx][@"menu-bg"] type:@"png"];
        brick.titleImage = [UIImage imageWithFile:self.data[@"bricks"][idx][@"menu-icon"] type:@"png"];
        brick.identifier = self.data[@"bricks"][idx][@"id"];
        [bricks addObject:brick];
    }];
    
    self.menuGrid = [[XJXGrid alloc] init];
    self.menuGrid.NUM_HORI = 1;
    self.menuGrid.ITEM_MARGIN = 5;
    self.menuGrid.bricks = bricks;
    self.menuGrid.brickHeight = 125;
    self.menuGrid.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.menuGrid.onItemSelected = ^(XJXBrick *_brick){
        [_self onMenuItemSelected:_brick.identifier];
    };
    self.menuGridRenderingView = [self.menuGrid render];
    [self.menuGridRenderingView setX:0];
    [self.menuGridRenderingView setY:0];
    [[self baseView] addSubview:self.menuGridRenderingView];
    
    
    [[self baseView] setContentSize:CGSizeMake(SCREEN_WIDTH, [self.menuGridRenderingView getMaxY] + 40)];
}

- (void)onMenuItemSelected:(NSString *)identifier{
    if([identifier isEqualToString:@"invitation"]){
        XJXReservationController *vc = [[XJXReservationController alloc] init];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }
    else if([identifier isEqualToString:@"wish"]){
        NSString *link = @"hnh://shopping.wishlist";
        [[XJXLinkageRouter defaultRouter] routeToLink:link];
    }
    else if([identifier isEqualToString:@"money"]){
        XJXEarnController *vc = [[XJXEarnController alloc] init];
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }
}

@end
