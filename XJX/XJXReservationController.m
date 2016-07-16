//
//  MainController.m
//  XJX
//
//  Created by Cai8 on 15/11/19.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import "XJXReservationController.h"
#import "XJXReservationCoverView.h"
#import "XJXReservationTemplateCell.h"
#import "XJXReservationBlockCell.h"
#import "XJXReservationWizard.h"
#import "XJXReservationRequirementController.h"
#import "XJXBrandMatchingController.h"
#import "XJXReservationToolBar.h"
#import "XJXAddWIshItemController.h"
#import "XJXReservationDashboard.h"

#define CELL_HEIGHT 250

@interface XJXReservationController()<UITableViewDataSource,UITableViewDelegate,XJXReservationCoverViewDelegate,CNPPopupControllerDelegate,XJXReservationDashboardDelegate,XJXReservationBlockCellDelegate>

@property (nonatomic,strong) XJXReservationCoverView *coverView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *gallery;

@property (nonatomic,strong) XJXReservationToolBar *toolbar;

@property (nonatomic,strong) XJXReservationDashboard *dashboard;

@property (nonatomic,strong) CNPPopupController *popupController;

@end

@implementation XJXReservationController
{
    NSArray *templates;
}

- (void)initNav{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.navBar setBarTintColor:[UIColor clearColor]];
    [self.navBar setShadowImage:[UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnDashboard = [UIControlsUtils buttonWithTitle:nil background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"Dashboard"] target:self selector:@selector(dashboard:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    
    UIBarButtonItem *itemDashboard = [[UIBarButtonItem alloc] initWithCustomView:btnDashboard];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setRightBarButtonItem:itemDashboard];
    [self.navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:self.navBar];
}

- (void)dashboard:(id)sender{
    if(!self.popupController){
        CGFloat totalHeight = 400;
        
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 44)];
        bar.backgroundColor = WhiteColor(1, 1);
        UILabel *lb = [UIControlsUtils labelWithTitle:@"我的成就" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont];
        [lb horizontalCenteredOnView:bar];
        [lb verticalCenteredOnView:bar];
        [bar addSubview:lb];
        
        UIButton *closeBtn = [UIControlsUtils buttonWithTitle:@"" background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"close"] target:self selector:@selector(closePopup:) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, LIST_ICON_SIZE, LIST_ICON_SIZE)];
        [closeBtn verticalCenteredOnView:bar];
        [closeBtn setX:[bar getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [closeBtn getW]];
        
        [bar addSubview:closeBtn];
        
        self.dashboard = [[XJXReservationDashboard alloc] initWithFrame:CGRectMake(0, [bar getMaxY] + 5, SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, totalHeight - [bar getH] - 5)];
        self.dashboard.delegate = self;
        
        self.popupController = [[CNPPopupController alloc] initWithContents:@[bar,self.dashboard]];
        CNPPopupTheme *theme = [CNPPopupTheme defaultTheme];
        theme.maxPopupWidth = SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI;
        theme.popupContentInsets = UIEdgeInsetsZero;
        self.popupController.theme = theme;
        self.popupController.theme.popupStyle = CNPPopupStyleCentered;
        self.popupController.delegate = self;
    }
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)share:(id)sender{
    [XJXAddWIshItemController showWithItemSelected:^(NSArray *selectedItems) {
        if(selectedItems.count == 0){
            [Utils showAlert:@"请选择参与众筹物品" title:@"警告"];
        }
        else{
            NSString *wedding_id = self.data[@"weddingInfo"][@"ID"];
            NSArray *item_ids = [[selectedItems stringByJoinProperty:^NSString *(id item) {
                return [NSString stringWithFormat:@"%@;%@",[item[@"ID"] stringValue],[item[@"isCustom"] boolValue] ? @"custom" : @"origin"];
            } delimiter:@","] componentsSeparatedByString:@","];
            id postData = @{
                            @"wedding_id" : wedding_id,
                            @"wishitem_ids" : item_ids,
                            @"requester" : @([Session current].ID)
                            };
            [FundingAPI shareItems:postData completion:^(id res, NSString *err) {
                if(!err){
                    NSString *serialNo = res;
                    NSString *url = INVITATION_HTML_URL_WRAPPER(wedding_id, serialNo);
                    WechatShareContent *content = [[WechatShareContent alloc] init];
                    content.redirect_url = [[WechatAgent defaultAgent] getAuthUrl:url];
                    content.shared_image = [UIImage imageWithFile:@"invitation" type:@"jpg"];
                    content.title = [NSString stringWithFormat:@"%@ 与 %@百年好合",self.data[@"weddingInfo"][@"bridename"],self.data[@"weddingInfo"][@"groomname"]];
                    content.desc = @"我们就要结婚了，快来看看我们的新婚愿望吧，希望得到您的的祝福！";
                    content.scene = kWechatShareSceneSession;
                    [[WechatAgent defaultAgent] doShareContent:content];
                }
                else{
                    NSLog(err);
                }
            }];
        }
    }];
}

- (void)loadDataWithCompletion:(onActionDone)done{
    //Check user has valid wedding or not
    if(![Session current].isLogined){
        [self performSelector:@selector(loadDataWithCompletion:) withObject:done afterDelay:0.5];
        return;
    }
    [ReservationAPI requestWeddingInfoWithCompletion:^(id res, NSString *err) {
        if(!err){
            if([res isKindOfClass:[NSNull class]]){
                [self reserveWeddingWithCompletion:^(id res) {
                    [self loadDataWithCompletion:done];
                }];
            }
            else{
                [self.data setObject:[res mutableCopy] forKey:@"weddingInfo"];
                done();
            }
        }
        else{
            [self onError];
        }
    }];
}

- (void)reserveWeddingWithCompletion:(void (^)(id res))handler{
    id post = @{
                @"wedding_id" : @"-1",
                @"cover" : @"-1",
                @"bridename" : @"",
                @"groomname" : @"",
                @"city" : @"",
                @"address" : @"",
                @"time" : [Utils stringFromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 30] formatter:@"yyyy-MM-dd HH:mm"],
                @"guimo" : @(150),
                @"venuetype" : @(3),
                @"consume" : @(250),
                @"brand_ids" : @[],
                @"requester" : @([Session current].ID)
                };
    [ReservationAPI updateWeddingInfo:post completion:^(id res, NSString *err) {
        if(!err){
            handler(res);
        }
        else{
            NSLog(err);
        }
    }];
}

- (void)initParams{
    templates = @[
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 4 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 3)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI)],
                      @"accessoryImage" : @"template-accessory-1",
                      @"foreground" : @(NO),
                      @"placeholder" : @"image01"
                      },
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 5 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 4.5, 0)],
                      @"accessoryImage" : @"template-accessory-2",
                      @"foreground" : @(NO),
                      @"placeholder" : @"image02"
                      },
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 3.5)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 1.5)],
                      @"accessoryImage" : @"template-accessory-3",
                      @"foreground" : @(YES),
                      @"placeholder" : @"image03"
                      },
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH * 0.6, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0)],
                      @"accessoryImage" : @"template-accessory-4",
                      @"foreground" : @(YES),
                      @"placeholder" : @"image04"
                      },
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 4 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 4)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2)],
                      @"accessoryImage" : @"template-accessory-5",
                      @"foreground" : @(NO),
                      @"placeholder" : @"image05"
                      },
                  @{
                      @"size" : [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH * 0.62, CELL_HEIGHT - [Theme defaultTheme].THEMING_EDGE_PADDING_VETI * 2.5)],
                      @"offset" : [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH * 0.3, 0)],
                      @"accessoryImage" : @"template-accessory-6",
                      @"foreground" : @(NO),
                      @"placeholder" : @"image06"
                      }
                  ];
    
    self.gallery = [NSMutableDictionary dictionary];
    [self.data[@"weddingInfo"][@"images"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.gallery setObject:obj forKey:@(idx+1)];
    }];
}

- (void)initUI{
    WS(_self);
    _coverView = [[XJXReservationCoverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self.view getH]) style:UITableViewStyleGrouped];
    _tableView.parallaxHeader.view = _coverView;
    _tableView.parallaxHeader.height = [_coverView getH];
    _tableView.parallaxHeader.minimumHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = WhiteColor(1, 1);
    [_tableView registerClass:[XJXReservationBlockCell class] forCellReuseIdentifier:NSStringFromClass([XJXReservationBlockCell class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view insertSubview:_tableView belowSubview:self.navBar];
    
    id wedding = self.data[@"weddingInfo"];
    
    _coverView.groomname = wedding[@"groomname"];
    _coverView.bridename = wedding[@"bridename"];
    _coverView.time = wedding[@"time"];
    _coverView.address = wedding[@"address"];
    if([wedding[@"cover"][@"imageID"] integerValue] != -1){
        _coverView.coverEntity = wedding[@"cover"];
    }
    _coverView.delegate = self;
}

- (void)closePopup:(id)sender{
    [self.popupController dismissPopupControllerAnimated:YES];
}

#pragma mark - dashboard delegate
- (NSUInteger)weddingIdOfDashboard:(XJXReservationDashboard *)dashboard{
    return [self.data[@"weddingInfo"][@"ID"] integerValue];
}

- (NSString *)coverUrlOfDashboard:(XJXReservationDashboard *)dashboard{
    return SERVER_FILE_WRAPPER(self.data[@"weddingInfo"][@"cover"][@"tiny_thumb_image_url"]);
}

#pragma mark - delegate
- (void)popupControllerWillPresent:(CNPPopupController *)controller{
    [self.dashboard reload];
}

- (void)popupControllerWillDismiss:(CNPPopupController *)controller{
    
}

#pragma mark - cover delegate
- (void)didWeddingInfoChanged:(id)weddinginfo{
    NSString *bridename = weddinginfo[@"bridename"];
    NSString *groomname = weddinginfo[@"groomname"];
    NSInteger coverId = [weddinginfo[@"coverId"] integerValue];
    NSString *address = weddinginfo[@"address"];
    NSString *time = [Utils stringFromDate:[Utils dateFromString:weddinginfo[@"time"] formatter:@"yyyy年 MM月 dd日 HH:mm"] formatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *wedding_id = self.data[@"weddingInfo"][@"ID"];
    id submitForm = @{
                      @"wedding_id" : wedding_id,
                      @"cover" : @(coverId),
                      @"bridename" : bridename,
                      @"groomname" : groomname,
                      @"address" : address,
                      @"time" : time,
                      @"requester" : @([Session current].ID)
                      };
    [ReservationAPI updateWeddingInfo:submitForm completion:^(id res, NSString *err) {
        if(!err){
            NSLog(@"update success");
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
    return templates.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT + CELL_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id template = templates[indexPath.row];
    XJXReservationBlockCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJXReservationBlockCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewSize = [template[@"size"] CGSizeValue];
    cell.coord_offsets = [template[@"offset"] CGPointValue];
    cell.accessoryImage = [UIImage imageNamed:template[@"accessoryImage"]];
    cell.accessoryForeground = [template[@"foreground"] boolValue];
    cell.delegate = self;
    if(self.gallery[@(indexPath.row+1)]){
        [cell.coverImageView lazyWithUrl:SERVER_FILE_WRAPPER(self.gallery[@(indexPath.row + 1)][@"image"][@"big_thumb_image_url"])];
    }
    else{
        cell.coverImageView.image = [UIImage imageWithFile:template[@"placeholder"] type:@"jpg"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WS(_self);
    if(!_toolbar){
        _toolbar = [[XJXReservationToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _toolbar.publishHandler = ^(){
            [_self share:nil];
        };
    }
    return _toolbar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

#pragma mark - template delegate

- (void)didTemplateOnTouched:(UIImageView *)imageView onCell:(XJXReservationBlockCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self updateGalleryWithOrder:(int)(indexPath.row + 1) completion:^(id imageEntity) {
        [self.gallery setObject:imageEntity forKey:@((int)(indexPath.row + 1))];
        [imageView lazyWithUrl:SERVER_FILE_WRAPPER(imageEntity[@"big_thumb_image_url"])];
    }];
}

- (void)updateGalleryWithOrder:(int)order completion:(void (^)(id imageEntity))handler{
    [ImageUploader pickImageWithScaledSize:CGSizeMake(750, 750) completion:^(NSArray *entities, NSString *err) {
        if(!err){
            id entity = entities[0];
            [ReservationAPI updateWeddingGalleryWithPhotoId:[entity[@"imageID"] integerValue] onWeddingWithId:[self.data[@"weddingInfo"][@"ID"] integerValue] atOrder:order completion:^(id _res, NSString *_err) {
                if(!_err){
                    if(handler){
                        handler(entity);
                    }
                }
                else{
                    [Utils showAlert:_err title:@"警告"];
                }
            }];
        }
        else{
            NSLog(err);
        }
    } onPickerDismissed:^{
        
    }];
}

@end
