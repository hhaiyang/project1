//
//  XJXReservationCoverView.m
//  XJX
//
//  Created by Cai8 on 16/1/25.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationCoverView.h"
#import "CountDownProgressView.h"

#define COUNT_DOWN_EDGE_LENGTH 108

#define FOOTER_HEIGHT 80

@interface XJXReservationCoverView()<EditingLabelDelegate>

@property (nonatomic,strong) UIImageView *cover;

@property (nonatomic,strong) UIView *headerContainer;

@property (nonatomic,strong) UIView *footerContainer;

@property (nonatomic,strong) UIImageView *welcomeImageView;
@property (nonatomic,strong) EditingLabel *groomLabel;
@property (nonatomic,strong) EditingLabel *brideLabel;
@property (nonatomic,strong) UILabel *andLabel;

@property (nonatomic,strong) UIImageView *calendarIconView;
@property (nonatomic,strong) UILabel *dateLb;
@property (nonatomic,strong) UILabel *timeLb;

@property (nonatomic,strong) UIImageView *locationIconView;
@property (nonatomic,strong) EditingLabel *locationLabel;

@property (nonatomic,strong) CountDownProgressView *progressView;

@end

@implementation XJXReservationCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    //[self layout];
    [self scrollingEffect];
}

- (void)scrollingEffect{
    _headerContainer.alpha = ([_headerContainer getH] + [self getMinY] * 2) / [_headerContainer getH];
}

- (void)layout{
    [self layoutNaming];
    [self layoutCalendar];
    [self layoutLocation];
    [self layoutProgressView];
}

- (void)initUI{
    WS(_self);
    
    self.backgroundColor = WhiteColor(1, 1);
    
    _cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self getW], [self getH] - 0.5 * COUNT_DOWN_EDGE_LENGTH)];
    _cover.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"invitation" ofType:@"jpg"]];
    _cover.contentMode = UIViewContentModeScaleAspectFill;
    _cover.layer.masksToBounds = YES;
    [self addSubview:_cover];
    
    _headerContainer = [[UIView alloc] initWithFrame:_cover.bounds];
    [self addSubview:_headerContainer];
    
//    _headerContainer.backgroundColor = WhiteColor(0, .4);
    
//    _welcomeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 233, 60)];
//    _welcomeImageView.image = [UIImage imageNamed:@"welcome"];
//    _welcomeImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_welcomeImageView horizontalCenteredOnView:self];
//    
//    [_headerContainer addSubview:_welcomeImageView];
    
//    [_headerContainer setOnViewTouchedHandler:^(UIView *touchedView){
//        if([touchedView isEqual:_self.headerContainer]){
//            [_self changeCover:nil];
//        }
//    }];
    
    [self addNamingLine];
    [self addCalendarLine];
    [self addLocationLine];
    
    [self addProgressView];
    
    [self addFooterContainer];
    
    [self layout];

    _brideLabel.delegate =
    _groomLabel.delegate =
    _locationLabel.delegate = self;
    
    [self setH:[_footerContainer getMaxY]];
}

- (void)changeCover:(id)sender{
    WS(_self);
    [ImageUploader pickImageWithScaledSize:CGSizeMake(750, 750) completion:^(NSArray *entities, NSString *err) {
        if(!err){
            id entity = entities[0];
            self.coverEntity = entity;
            
            [self save];
        }
        else{
            NSLog(err);
        }
    } onPickerDismissed:^{
        [[XJXLinkageRouter defaultRouter].activityController hideTabBar:NO animated:YES];
    }];
    
    [[XJXLinkageRouter defaultRouter].activityController hideTabBar:YES animated:YES];
}

- (void)addFooterContainer{
    UIImage *titleImage = [UIImage imageNamed:@"wenzi01"];
    UIImage *textImage = [UIImage imageNamed:@"wenzi02"];
    _footerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [_headerContainer getMaxY], SCREEN_WIDTH, FOOTER_HEIGHT + 0.5 * [_progressView getH])];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5 * [_progressView getH], 0.8 * [self getW], (titleImage.size.height / titleImage.size.width) * (0.8 * [self getW]))];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.image = titleImage;
    titleImageView.layer.masksToBounds = YES;
    
    UIImageView *textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [titleImageView getMaxY] + 10, 0.8 * [self getW], (textImage.size.height / textImage.size.width) * (0.8 * [self getW]))];
    textImageView.contentMode = UIViewContentModeScaleAspectFill;
    textImageView.image = textImage;
    textImageView.layer.masksToBounds = YES;

    [titleImageView horizontalCenteredOnView:_footerContainer];
    [textImageView horizontalCenteredOnView:_footerContainer];
    
    [_footerContainer addSubview:titleImageView];
    [_footerContainer addSubview:textImageView];
    
    [_footerContainer setH:[textImageView getMaxY]];
    [self addSubview:_footerContainer];
}

- (void)addNamingLine{
    _groomLabel = [[EditingLabel alloc] initWithText:@"Mr.Right"];
    _andLabel = [UIControlsUtils labelWithTitle:@"&" color:WhiteColor(1, 1) font:[Theme defaultTheme].invitationAndFont];
    _brideLabel = [[EditingLabel alloc] initWithText:@"Mrs.Right"];
    
    _groomLabel.placeholder = @"请输入新郎姓名";
    _brideLabel.placeholder = @"请输入新娘姓名";
    
    _groomLabel.textLabel.textAlignment = NSTextAlignmentRight;
    _brideLabel.textLabel.textAlignment = NSTextAlignmentLeft;
    
    [_headerContainer addSubview:_groomLabel];
    [_headerContainer addSubview:_andLabel];
    [_headerContainer addSubview:_brideLabel];
}

- (void)layoutNaming{
    [_groomLabel recalculateSize];
    [_brideLabel recalculateSize];
    
    CGFloat y_offset = 80;
    CGSize totalSize = CGSizeMake([_groomLabel getW] + 10 + [_andLabel getW] + 10 + [_brideLabel getW], [_andLabel getH]);
    
    [_groomLabel setX:([self getW] - totalSize.width) / 2.0];
    [_groomLabel setY:(totalSize.height + y_offset) - [_groomLabel getH]];
    
    [_andLabel setX:[_groomLabel getMaxX] + 10];
    [_andLabel setY:y_offset];
    
    [_brideLabel setX:[_andLabel getMaxX] + 10];
    [_brideLabel setY:(totalSize.height + y_offset) - [_brideLabel getH]];
    
    [_headerContainer addSubview:_groomLabel];
    [_headerContainer addSubview:_andLabel];
    [_headerContainer addSubview:_brideLabel];
}

- (void)addCalendarLine{
    _calendarIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    _calendarIconView.contentMode = UIViewContentModeScaleAspectFit;
    _calendarIconView.image = [UIImage imageNamed:@"date-icon"];
    
    NSString *date = @"xxxx年 xx月 xx日";
    _dateLb = [UIControlsUtils labelWithTitle:date color:[Theme defaultTheme].invitationFieldColor font:[Theme defaultTheme].invitationFieldFont];
    
    _timeLb = [UIControlsUtils labelWithTitle:@"xx:xx" color:[Theme defaultTheme].invitationFieldColor font:[Theme defaultTheme].invitationFieldFont];
    [_timeLb setY:[_dateLb getMaxY] + 5];
    
    _timeLb.userInteractionEnabled = _dateLb.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTime:)];
    [_dateLb addGestureRecognizer:tap];
    //[_timeLb addGestureRecognizer:tap];
    
    [_headerContainer addSubview:_calendarIconView];
    [_headerContainer addSubview:_dateLb];
    [_headerContainer addSubview:_timeLb];
}

- (void)layoutCalendar{
    [_dateLb recalculateSize];
    [_timeLb recalculateSize];
    
    CGFloat y_offset = [_andLabel getMaxY] + 20;
    CGSize totalSize = CGSizeMake([_dateLb getW] + 5 + [_calendarIconView getW], [_timeLb getH] + 5 + MAX([_calendarIconView getH],[_dateLb getH]));
    [_calendarIconView setX:([self getW] - totalSize.width) / 2.0];
    [_calendarIconView setY:y_offset];
    
    [_dateLb setX:[_calendarIconView getMaxX] + 5];
    [_dateLb verticalCenteredOnView:_calendarIconView];
    [_dateLb setY:y_offset + [_dateLb getMinY]];
    
    [_timeLb horizontalCenteredOnView:self];
    [_timeLb setY:[_dateLb getMaxY] + 5];
}

- (void)addLocationLine{
    _locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_ICON_SIZE, NAVBAR_ICON_SIZE)];
    _locationIconView.contentMode = UIViewContentModeScaleAspectFit;
    _locationIconView.image = [UIImage imageNamed:@"place-icon"];
    
    _locationLabel = [[EditingLabel alloc] initWithText:@"婚礼地点" font:[Theme defaultTheme].invitationFieldFont];
    
    [_headerContainer addSubview:_locationIconView];
    [_headerContainer addSubview:_locationLabel];
}

- (void)layoutLocation{
    [_locationLabel recalculateSize];
    
    CGFloat y_offset = [_timeLb getMaxY] + 30;
    CGSize totalSize = CGSizeMake([_locationIconView getW] + 5 + [_locationLabel getW], MAX([_locationIconView getH], [_locationLabel getH]));
    [_locationIconView setX:([self getW] - totalSize.width) / 2.0];
    [_locationIconView setY:y_offset];
    
    [_locationLabel setX:[_locationIconView getMaxX] + 5];
    [_locationLabel verticalCenteredOnView:_locationIconView];
    [_locationLabel setY:y_offset + [_locationLabel getMinY]];
}

- (void)addProgressView{
    _progressView = [[CountDownProgressView alloc] initWithFrame:CGRectMake(0, 0, COUNT_DOWN_EDGE_LENGTH, COUNT_DOWN_EDGE_LENGTH)];
    _progressView.title = @"99";
    [_progressView horizontalCenteredOnView:self];
    [_progressView setY:[_headerContainer getMaxY] - COUNT_DOWN_EDGE_LENGTH * 0.5];
    _progressView.backgroundColor = [Theme defaultTheme].highlightTextColor;
    _progressView.layer.cornerRadius = 0.5 * COUNT_DOWN_EDGE_LENGTH;
    [self addSubview:_progressView];
}

- (void)layoutProgressView{
    [_progressView setY:(([_headerContainer getMaxY] - 0.5 * COUNT_DOWN_EDGE_LENGTH) + [self getMinY])];
}

- (void)pickTime:(UIGestureRecognizer *)gesture{
    NSString *title = @"选择婚礼开始日期";
    UIDatePickerMode mode = UIDatePickerModeDateAndTime;
    NSDate *selectDate = [NSDate date];
    NSDate *minimumDate = [NSDate date];
    NSDate *maximumDate = [[NSDate date] dateByAddingTimeInterval:1000 * 60 * 60 * 24 * 365];
    
    if(![_dateLb.text containsString:@"xxxx"]){
        NSString *dateStr = [NSString stringWithFormat:@"%@ %@",_dateLb.text,_timeLb.text];
        selectDate = [Utils dateFromString:dateStr formatter:@"yyyy年 MM月 dd日 HH:mm"];
    }
    
    [ActionSheetDatePicker showPickerWithTitle:title datePickerMode:mode selectedDate:selectDate minimumDate:minimumDate maximumDate:maximumDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        _dateLb.text = [Utils stringFromDate:selectedDate formatter:@"yyyy年 MM月 dd日"];
        _timeLb.text = [Utils stringFromDate:selectedDate formatter:@"HH:mm"];
        [UIView animateWithDuration:.4 animations:^{
            [self layout];
        }];
        [self save];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self];
}

#pragma mark - getter & setter
- (void)setGroomname:(NSString *)groomname{
    if([groomname isEmpty]){
        groomname = @"Mr.Right";
    }
    _groomLabel.textLabel.text = groomname;
    [self layout];
}

- (void)setBridename:(NSString *)bridename{
    if([bridename isEmpty]){
        bridename = @"Mrs.Right";
    }
    _brideLabel.textLabel.text = bridename;
    [self layout];
}

- (void)setTime:(NSString *)time{
    NSString *dateStr = [Utils stringFromDate:[Utils dateFromString:time formatter:@"yyyy/MM/dd HH:mm:ss"] formatter:@"yyyy年 MM月 dd日"];
    NSString *timeStr = [Utils stringFromDate:[Utils dateFromString:time formatter:@"yyyy/MM/dd HH:mm:ss"] formatter:@"HH:mm"];
    _dateLb.text = dateStr;
    _timeLb.text = timeStr;
    
    _progressView.title = [NSString stringWithFormat:@"%d",(int)([[Utils dateFromString:time formatter:@"yyyy/MM/dd HH:mm:ss"] timeIntervalSinceNow] / (24 * 60 * 60))];
    
    [self layout];
}

- (void)setAddress:(NSString *)address{
    if([address isEmpty]){
        address = @"婚礼地点";
    }
    _locationLabel.textLabel.text = address;
    [self layout];
}

- (void)setCoverEntity:(id)coverEntity{
    _coverEntity = coverEntity;
    [_cover lazyWithUrl:SERVER_FILE_WRAPPER(coverEntity[@"big_thumb_image_url"])];
}

#pragma mark - editing
- (void)didEditing:(EditingLabel *)label{
    [UIView animateWithDuration:.3 animations:^{
        [self layout];
    }];
    
    [self save];
}

- (void)save{
    NSString *bridename = _brideLabel.textLabel.text;
    NSString *groomname = _groomLabel.textLabel.text;
    NSString *address = _locationLabel.textLabel.text;
    NSString *time = [NSString stringWithFormat:@"%@ %@",_dateLb.text,_timeLb.text];
    if([time containsString:@"x"]){
        [Utils showAlert:@"日期格式非法" title:@"警告"];
        return;
    }
    NSInteger coverId = -1;
    if(self.coverEntity){
        coverId = [self.coverEntity[@"imageID"] integerValue];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didWeddingInfoChanged:)]){
        id form = @{
                    @"bridename" : bridename,
                    @"groomname" : groomname,
                    @"address" : address,
                    @"time" : time,
                    @"coverId" : @(coverId)
                    };
        [self.delegate didWeddingInfoChanged:form];
    }
}

@end
