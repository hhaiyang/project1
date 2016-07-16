//
//  XJXCFRecordView.m
//  XJX
//
//  Created by Cai8 on 16/2/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXCFRecordView.h"

@interface XJXCFRecordViewBlock()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *moneyLb;

@end

@implementation XJXCFRecordViewBlock

- (instancetype)init{
    if(self = [super init]){
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _nameLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].emFont];
    
    _moneyLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].subTitleFont];
    
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:_imageView];
    [self addSubview:_nameLb];
    [self addSubview:_moneyLb];
}

- (void)layoutSubviews{
    [self layout];
}

- (void)layout{
    [_imageView setY:[Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
    [_imageView setW:[self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    [_imageView setH:[self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID];
    _imageView.layer.cornerRadius = 0.5 * [_imageView getW];
    [_imageView horizontalCenteredOnView:self];
    
    [_nameLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID, 14)];
    [_nameLb horizontalCenteredOnView:self];
    [_nameLb setY:[_imageView getMaxY] + 5 + [Theme defaultTheme].THEMING_EDGE_PADDING_VETI_IN_GRID];
    
    [_moneyLb recalculateSizeWithConstraintSize:CGSizeMake([self getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI_IN_GRID, 14)];
    [_moneyLb horizontalCenteredOnView:self];
    [_moneyLb setY:[_nameLb getMaxY] + 8];
}

- (void)setName:(NSString *)name{
    _name = name;
    _nameLb.text = name;
    [self layout];
}

- (void)setMoney:(CGFloat)money{
    _money = money;
    id attribute = @{
                     NSForegroundColorAttributeName : [Theme defaultTheme].lightColor,
                     NSFontAttributeName : [Theme defaultTheme].subTitleFont
                     };
    NSString *str = [NSString stringWithFormat:@"+ ￥%.2lf",money];
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str attributes:attribute];
    [attrstr addAttribute:NSForegroundColorAttributeName value:[Theme defaultTheme].highlightTextColor range:[str rangeOfString:[NSString stringWithFormat:@"￥%.2lf",money]]];
    _moneyLb.attributedText = attrstr;
    [self layout];
}

- (void)setImage_url:(NSString *)image_url{
    _imageView.image = nil;
    [_imageView lazyWithUrl:image_url];
}

@end

@interface XJXCFRecordView()

@property (nonatomic,strong) NSMutableDictionary *blocks;

@end

@implementation XJXCFRecordView

- (void)layoutSubviews{
    [self layout];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _blocks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)reloadData{
    [_blocks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_blocks removeAllObjects];
}

- (void)layout{
    if(self.delegate){
        int count = [self.delegate numberOfBlocks];
        for(int i = 0;i < count;i++){
            if([self isVisibleBlockAtIndex:i]){
                CGRect frame = [self rectOfBlockAtIndex:i];
                XJXCFRecordViewBlock *block = [self.delegate blockAtIndex:i];
                block.frame = frame;
                if(!block.superview){
                    [self addSubview:block];
                }
                [self enqueueBlock:block atIndex:i];
            }
            else{
                [self.blocks removeObjectForKey:@(i)];
            }
        }
    }
}

- (void)enqueueBlock:(XJXCFRecordViewBlock *)block atIndex:(NSUInteger)index{
    [self.blocks setObject:block forKey:@(index)];
}

- (XJXCFRecordViewBlock *)dequeueBlockAtIndex:(NSUInteger)index{
    return [self.blocks objectForKey:@(index)];
}

- (BOOL)isVisibleBlockAtIndex:(NSUInteger)index{
    return CGRectIntersectsRect(self.bounds, [self rectOfBlockAtIndex:index]);
}

- (CGRect)rectOfBlockAtIndex:(NSUInteger)index{
    int numberHori = [self.delegate numberOfBlocksInHori];
    CGFloat itemHeight = [self.delegate heightOfBlock];
    CGFloat itemWidth  = ([self getW] - (self.padding.left + self.padding.right) - ([self.delegate numberOfBlocksInHori] - 1) * [self.delegate marginOfBlock]) / ([self.delegate numberOfBlocksInHori] * 1.0);
    
    int layer = (int)ceil((index + 1.0) / (numberHori * 1.0));
    int hori_index = index % numberHori;
    
    CGFloat y_offset = self.padding.top + (layer - 1) * (itemHeight + [self.delegate marginOfBlock]);
    
    CGFloat x_offset = self.padding.left + hori_index * (itemWidth + [self.delegate marginOfBlock]);
    
    return CGRectMake(x_offset, y_offset, itemWidth, itemHeight);
}

+ (CGFloat)heightWithItemCount:(NSUInteger)count numberHori:(int)hori itemHeight:(CGFloat)itemHeight margin:(CGFloat)margin contentPadding:(UIEdgeInsets)padding{
    int layer = (int)ceil((count * 1.0) / (hori * 1.0));
    CGFloat height = 0;
    height = padding.top;
    height += layer * itemHeight + (layer - 1) * margin;
    height += padding.bottom;
    return height;
}

@end
