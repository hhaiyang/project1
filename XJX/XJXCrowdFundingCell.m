//
//  XJXCrowdFundingCell.m
//  XJX
//
//  Created by Cai8 on 16/2/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCrowdFundingCell.h"
#import "XJXCFRecordView.h"

#define PADDING_VETI 0
#define PADDING_HORI 15
#define ITEM_HEIGHT 104
#define ITEM_MARGIN 5

#define HEADER_HEIGHT 100

@interface XJXCrowdFundingCell()<XJXCFRecordViewDelegate>

@property (nonatomic,strong) UIView *headerContainer;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *subtitleLb;
@property (nonatomic,strong) UILabel *priceLb;

@property (nonatomic,strong) UILabel *readmeLb;

@property (nonatomic,strong) UIButton *btnEnd;
@property (nonatomic,strong) XJXCFRecordView *recordView;

@property (nonatomic,strong) UIView *footerContainer;

@property (nonatomic,strong) UILabel *footerLb;

@property (nonatomic,strong) UIView *header_sep;
@property (nonatomic,strong) UIView *footer_sep;

@end

@implementation XJXCrowdFundingCell

- (void)layout{
    [_imgView setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_imgView verticalCenteredOnView:_headerContainer];
    
    [_btnEnd setX:[self.contentView getW] - [_btnEnd getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [_btnEnd verticalCenteredOnView:_headerContainer];
    
    [_titleLb setX:[_imgView getMaxX] + 5];
    [_titleLb setY:[_imgView getMinY] + 5];
    [_titleLb recalculateSizeWithConstraintSize:CGSizeMake([_btnEnd getMinX] - [_titleLb getMinX], 14)];
    
    [_subtitleLb setX:[_titleLb getMinX]];
    [_subtitleLb setY:[_titleLb getMaxY] + 5];
    [_subtitleLb recalculateSizeWithConstraintSize:CGSizeMake([_btnEnd getMinX] - [_titleLb getMinX], 14)];
    
    [_readmeLb setX:[_titleLb getMinX]];
    [_readmeLb setY:[_subtitleLb getMaxY] + 2];
    [_readmeLb recalculateSizeWithConstraintSize:CGSizeMake([_btnEnd getMinX] - [_titleLb getMinX], 14)];
    
    [_priceLb recalculateSize];
    [_priceLb setX:[_titleLb getMinX]];
    [_priceLb setY:[_imgView getMaxY] - [_priceLb getH]];
    
    [_header_sep setX:0];
    [_header_sep setW:[self.contentView getW]];
    [_header_sep setY:[_headerContainer getMaxY]];
    
    if(_price - _fundedMoney == 0){
        [_btnEnd setBackgroundColor:[Theme defaultTheme].highlightTextColor];
        [_btnEnd setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
        [_btnEnd setTitle:@"领取" forState:UIControlStateNormal];
    }
    else{
        [_btnEnd setBackgroundColor:[UIColor clearColor]];
        [_btnEnd setTitleColor:[Theme defaultTheme].highlightTextColor forState:UIControlStateNormal];
        [_btnEnd setTitle:@"结束" forState:UIControlStateNormal];
    }
    
    CGFloat height = 0.0;
    if(self.funders.count > 0){
        if(_collapse){
            height = [XJXCFRecordView heightWithItemCount:5 numberHori:5 itemHeight:ITEM_HEIGHT margin:ITEM_MARGIN contentPadding:UIEdgeInsetsMake(PADDING_VETI, PADDING_HORI, PADDING_VETI, PADDING_HORI)];
        }
        else{
            height = [XJXCFRecordView heightWithItemCount:self.funders.count numberHori:5 itemHeight:ITEM_HEIGHT margin:ITEM_MARGIN contentPadding:UIEdgeInsetsMake(PADDING_VETI, PADDING_HORI, PADDING_VETI, PADDING_HORI)];
        }
        _footer_sep.alpha = 1;
    }
    else{
        _footer_sep.alpha = 0;
    }
    [_recordView setX:0];
    [_recordView setY:[_header_sep getMaxY]];
    [_recordView setW:[self.contentView getW]];
    [_recordView setH:height];
    
    [_footer_sep setW:[self.contentView getW]];
    [_footer_sep setX:0];
    [_footer_sep setY:[_recordView getMaxY]];
    
    [_footerContainer setH:44];
    [_footerContainer setW:[self.contentView getW]];
    [_footerContainer setX:0];
    [_footerContainer setY:[_footer_sep getMaxY]];
    
    [_footerLb verticalCenteredOnView:_footerContainer];
    [_footerLb horizontalCenteredOnView:_footerContainer];
}

- (void)initUI{
    [self initHeader];
    [self initRecordView];
    [self initFooter];
    
    _header_sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    _footer_sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    _header_sep.backgroundColor = _footer_sep.backgroundColor = WhiteColor(0, .06);
    [self.contentView addSubview:_header_sep];
    [self.contentView addSubview:_footer_sep];
}

- (void)initHeader{
    _headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.masksToBounds = YES;
    
    _titleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].titleFont];
    
    _subtitleLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].subTitleFont];
    
    _priceLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].titleFont];
    _readmeLb = [UIControlsUtils labelWithTitle:@"*只有自定义产品才可以提现" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].emFont];
    _readmeLb.hidden = YES;
    
    _btnEnd = [UIControlsUtils buttonWithTitle:@"结束" background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(end:) padding:UIEdgeInsetsMake(8, 25, 8, 25) frame:CGRectZero];
    
    [_btnEnd setTitleColor:[Theme defaultTheme].highlightTextColor forState:UIControlStateNormal];
    _btnEnd.layer.cornerRadius = 0.5 * [_btnEnd getH];
    _btnEnd.layer.borderColor = [Theme defaultTheme].highlightTextColor.CGColor;
    _btnEnd.layer.borderWidth = 1;
    
    [_headerContainer addSubview:_imgView];
    [_headerContainer addSubview:_titleLb];
    [_headerContainer addSubview:_subtitleLb];
    [_headerContainer addSubview:_priceLb];
    [_headerContainer addSubview:_readmeLb];
    [_headerContainer addSubview:_btnEnd];
    
    [self.contentView addSubview:_headerContainer];
}

- (void)initRecordView{
    _recordView = [[XJXCFRecordView alloc] initWithFrame:CGRectZero];
    _recordView.backgroundColor = WhiteColor(1, 1);
    _recordView.padding = UIEdgeInsetsMake(PADDING_VETI, PADDING_HORI, PADDING_VETI, PADDING_HORI);
    _recordView.delegate = self;
    [self.contentView addSubview:_recordView];
}

- (void)initFooter{
    _footerContainer = [[UIView alloc] initWithFrame:CGRectZero];
    _footerContainer.backgroundColor = WhiteColor(1, 1);
    _footerLb = [UIControlsUtils labelWithTitle:@"点击查看全部" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].subTitleFont];
    [_footerContainer addSubview:_footerLb];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMore:)];
    
    [_footerContainer addGestureRecognizer:tap];
    
    [self.contentView addSubview:_footerContainer];
}

- (void)seeMore:(UIGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didCollapseStatusChange:)]){
        [self.delegate didCollapseStatusChange:self];
    }
}

- (void)end:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTerminateCFPressed:)]){
        [self.delegate didTerminateCFPressed:self];
    }
}

- (void)setImage_url:(NSString *)image_url{
    _imgView.image = nil;
    [_imgView lazyWithUrl:image_url];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = title;
    [self layout];
}

- (void)setFundedMoney:(CGFloat)fundedMoney{
    _fundedMoney = fundedMoney;
    NSString *str = [NSString stringWithFormat:@"还剩 %.2lf",_price - _fundedMoney];
    self.subtitleLb.text = str;
    [self layout];
}

- (void)setPrice:(CGFloat)price{
    _price = price;
    NSString *str = [NSString stringWithFormat:@"还剩 %.2lf",_price - _fundedMoney];
    self.subtitleLb.text = str;
    
    NSString *priceStr = [NSString stringWithFormat:@"%.2lf",_price];
    self.priceLb.attributedText = [priceStr priceFormatAttributeWithFont:[Theme defaultTheme].subTitleFont symbolFont:[Theme defaultTheme].emFont color:[Theme defaultTheme].highlightTextColor];
    [self layout];
}

- (void)setIsCustom:(BOOL)isCustom{
    _isCustom = isCustom;
    _readmeLb.hidden = !_isCustom;
    [self layout];
}

- (void)setFunders:(NSArray *)funders{
    if([funders isEqual:_funders])
        return;
    _funders = funders;
    if(_funders.count == 0){
        _footerLb.text = @"暂时没有人众筹";
        _footerLb.textColor = [Theme defaultTheme].lightColor;
        _footerContainer.userInteractionEnabled = NO;
    }
    else if(_funders.count <= [self numberOfBlocksInHori]){
        _footerLb.text = @"没有更多了";
        _footerLb.textColor = [Theme defaultTheme].lightColor;
        _footerContainer.userInteractionEnabled = NO;
    }
    else{
        _footerLb.text = @"点击查看全部";
        _footerLb.textColor = [Theme defaultTheme].highlightTextColor;
        _footerContainer.userInteractionEnabled = YES;
    }
    [_recordView reloadData];
    [self layout];
}

#pragma mark - record view delegate
- (int)numberOfBlocks{
    return (int)self.funders.count;
}

- (int)numberOfBlocksInHori{
    return 5;
}

- (CGFloat)heightOfBlock{
    return ITEM_HEIGHT;
}

- (CGFloat)marginOfBlock{
    return ITEM_MARGIN;
}

- (XJXCFRecordViewBlock *)blockAtIndex:(NSUInteger)index{
    XJXCFRecordViewBlock *block = [_recordView dequeueBlockAtIndex:index];
    if(!block){
        block = [[XJXCFRecordViewBlock alloc] initWithFrame:CGRectZero];
    }
    block.image_url = _funders[index][@"headimgUrl"];
    block.name = _funders[index][@"wechat_name"];
    block.money = [_funders[index][@"money"] floatValue] / 100;
    return block;
}

+ (CGFloat)heightOfFundingCellWithCollapse:(BOOL)collapse fcounts:(NSUInteger)fcounts{
    if(fcounts == 0){
        return HEADER_HEIGHT + 44 + 2;
    }
    CGFloat height = 0.0;
    if(collapse){
        height = [XJXCFRecordView heightWithItemCount:5 numberHori:5 itemHeight:ITEM_HEIGHT margin:ITEM_MARGIN contentPadding:UIEdgeInsetsMake(PADDING_VETI, PADDING_HORI, PADDING_VETI, PADDING_HORI)];
    }
    else{
        height = [XJXCFRecordView heightWithItemCount:fcounts numberHori:5 itemHeight:ITEM_HEIGHT margin:ITEM_MARGIN contentPadding:UIEdgeInsetsMake(PADDING_VETI, PADDING_HORI, PADDING_VETI, PADDING_HORI)];
    }
    
    height += HEADER_HEIGHT + 44 + 2;
    return height;
}

@end
