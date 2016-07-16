//
//  XJXShoppingCard.m
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXShoppingCard.h"
#import "XJXNumberTicker.h"

@interface XJXShoppingCard()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *priceLb;
@property (nonatomic,strong) UILabel *modelLb;
@property (nonatomic,strong) UILabel *amountLb;

@property (nonatomic,strong) UILabel *totalLb;

@property (nonatomic,strong) XJXCartSwiperView *swiperView;

@property (nonatomic,strong) UIButton *btnEdit;

@end

@implementation XJXShoppingCard

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.checkable = YES;
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    [super layout];
    if(self.checkable){
         [_imgView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI + [self.checkableView getMaxX]];
    }
    else{
        [_imgView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    }
    [_imgView verticalCenteredOnView:self.contentView];
    
    [_titleLb setX:[_imgView getMaxX] + 5];
    [_titleLb setY:[_imgView getMinY]];
    [_titleLb recalculateSizeWithConstraintSize:CGSizeMake([self.contentView getW] - RIGHT_SPACING - [_titleLb getMinX], 36)];
    
    [_modelLb setX:[_imgView getMaxX] + 5];
    [_modelLb setY:[_titleLb getMaxY] + 5];
    [_modelLb recalculateSizeWithConstraintSize:CGSizeMake([self.contentView getW] - RIGHT_SPACING - [_modelLb getMinX], 36)];
    
    [_priceLb recalculateSizeWithPrice:_price font:[Theme defaultTheme].normalTextFont symbolFont:[Theme defaultTheme].subTitleFont];
    [_priceLb setX:[_imgView getMaxX] + 5];
    [_priceLb setY:[_imgView getMaxY] - [_priceLb getH]];
    
    [_amountLb recalculateSizeWithConstraintSize:CGSizeMake(RIGHT_SPACING, 22)];
    [_amountLb setX:[self.contentView getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_amountLb getW]];
    [_amountLb setY:[_titleLb getMinY] + ([_titleLb getH] - [_amountLb getH]) / 2.0];
    
    id attribute = @{
                     NSForegroundColorAttributeName : [Theme defaultTheme].schemeColor,
                     NSFontAttributeName : [Theme defaultTheme].emFont
                     };
    NSString *totalS = [NSString stringWithFormat:@"合计: ￥%.2lf",_amount * _price];
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:totalS attributes:attribute];
    [_totalLb setAttributedText:totalStr];
    [_totalLb recalculateSize];
    [_totalLb verticalCenteredOnView:_priceLb];
    [_totalLb setY:[_priceLb getMinY] + [_totalLb getMinY]];
    [_totalLb setX:[self.contentView getW] - [_totalLb getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    
    [_btnEdit verticalCenteredOnView:_priceLb];
    [_btnEdit setY:[_priceLb getMinY] + [_btnEdit getMinY]];
    [_btnEdit setX:[_priceLb getMinX]];
    if(_editingStatus){
        _priceLb.alpha = 0;
        _btnEdit.alpha = 1;
    }
    else{
        _priceLb.alpha = 1;
        _btnEdit.alpha = 0;
    }
    
    [_swiperView setH:[self getH]];
}

- (void)initUI{
    [super initUI];
    if(_imgView)
        return;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
    _imgView.layer.masksToBounds = YES;
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentLeft];
    _modelLb = [UIControlsUtils labelWithTitle:@"" color:[[Theme defaultTheme].lightColor colorWithAlphaComponent:.6] font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentLeft];
    _amountLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].h4Font textAlignment:NSTextAlignmentLeft];
    _priceLb = [UIControlsUtils labelWithPrice:999 font:[Theme defaultTheme].normalTextFont symbolFont:[Theme defaultTheme].subTitleFont];
    
    _totalLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentRight];
    
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _titleLb.numberOfLines = 2;
    
    _btnEdit = [UIControlsUtils buttonWithTitle:@"编辑" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(edit) padding:UIEdgeInsetsMake(5, 25, 5, 25) frame:CGRectZero];
    [_btnEdit setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    _btnEdit.layer.cornerRadius = 0.5 * [_btnEdit getH];
    _btnEdit.alpha = 0;
    
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_titleLb];
    [self.contentView addSubview:_amountLb];
    [self.contentView addSubview:_modelLb];
    [self.contentView addSubview:_priceLb];
    [self.contentView addSubview:_totalLb];
    [self.contentView addSubview:_btnEdit];
}

- (void)initSwipers{
    _swiperView = [[XJXCartSwiperView alloc] init];
    _swiperView.sender = self;
    
    [_swiperView addButtonWithTitle:@"众筹" background:[Theme defaultTheme].highlightTextColor bg:nil padding:UIEdgeInsetsMake(0, 15, 0, 15)];
    [_swiperView addButtonWithTitle:@"删除" background:[[Theme defaultTheme].highlightTextColor colorWithAlphaComponent:.7] bg:nil padding:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self addRightView:_swiperView];
}

- (void)setSwiperViewOnTouched:(onSwiperButtonClicked)clicked{
    if(!self.swiperView){
        [self initSwipers];
    }
    __weak XJXShoppingCard *_self = self;
    _swiperView.buttonClicked = ^(XJXShoppingCard *sender,NSUInteger buttonTouchedIndex){
        [_self resetSwipe:^(BOOL finished) {
            clicked(sender,buttonTouchedIndex);
        } withAnimation:YES];
    };
}

- (void)setImage_url:(NSString *)image_url{
    _image_url = image_url;
    [_imgView lazyWithUrl:_image_url];
}

- (void)setPrice:(CGFloat)price{
    _price = price;
}

- (void)setAmount:(int)amount{
    _amount = amount;
    _amountLb.text = [NSString stringWithFormat:@"x%d",_amount];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = _title;
}

- (void)setModel:(NSString *)model{
    _model = model;
    _modelLb.text = model;
}

- (void)setEditingStatus:(BOOL)editingStatus{
    _editingStatus = editingStatus;
    if(editingStatus){
        self.checkable = NO;
        [self enableEditing];
    }
    else{
        self.checkable = YES;
        [self disableEditing];
    }
}

- (void)enableEditing{
    [self layout];
}

- (void)disableEditing{
    [self layout];
}

- (void)edit{
    if(self.modelClickHandler){
        self.modelClickHandler(self);
    }
}

@end
