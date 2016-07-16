//
//  XJXTopMenuBar.m
//  XJX
//
//  Created by Cai8 on 16/2/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTopMenuBar.h"

#define EDGE_PADDING 30

#define MAX_ITEMS_PER_PAGE 5

@interface XJXTopMenuBar()

@property (nonatomic,strong) NSArray *menuItems;

@property (nonatomic,strong) UIView *indicator;
@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,assign) CGFloat item_margin;

@property (nonatomic,assign) CGFloat itemWidth;

@end

@implementation XJXTopMenuBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithMenuItems:(NSArray *)items startIndex:(int)index{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]){
        _currentIndex = index;
        _menuItems = items;
        [self initParams];
        [self initUI];
    }
    return self;
}

- (CGFloat)itemWidth{
    if(_itemWidth == 0){
        __block CGFloat width = 0.0;
        [_menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx < MAX_ITEMS_PER_PAGE)
                width += [obj sizeWithFont:[Theme defaultTheme].subTitleFont constrainToSize:CGSizeMake(MAXFLOAT, [self getH])].width;
        }];
        _itemWidth = width;
    }
    return _itemWidth;
}

- (CGFloat)itemMargin{
    NSUInteger index = MIN(_menuItems.count, MAX_ITEMS_PER_PAGE) - 1;
    CGFloat width = (SCREEN_WIDTH - EDGE_PADDING * 2) - [_menuItems[index] sizeWithFont:[Theme defaultTheme].subTitleFont].width - [_menuItems[0] sizeWithFont:[Theme defaultTheme].subTitleFont].width;
    __block CGFloat w = 0.0;
    [_menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx != 0 && idx != index){
            w += [obj sizeWithFont:[Theme defaultTheme].subTitleFont].width;
        }
    }];
    return (width - w) / (MIN(_menuItems.count, MAX_ITEMS_PER_PAGE) - 1);
}

- (void)initParams{
    self.buttons = [NSMutableArray array];
    self.item_margin = [self itemMargin];
    self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, [self getH] - 2, 0, 2)];
    [self.indicator setBackgroundColor:[Theme defaultTheme].highlightTextColor];
}

- (void)initUI{
    __block CGFloat x_offset = EDGE_PADDING;
    [_menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIControlsUtils buttonWithTitle:obj background:[UIColor clearColor] backroundImage:nil target:self selector:@selector(itemSelected:) padding:UIEdgeInsetsZero frame:CGRectZero];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[Theme defaultTheme].lightColor forState:UIControlStateNormal];
        [btn setTitleColor:[Theme defaultTheme].highlightTextColor forState:UIControlStateHighlighted];
        [btn setY:0];
        [btn setX:x_offset];
        [btn setH:[self getH]];
        
        [btn setTag:idx];
        
        x_offset += [btn getW] + self.item_margin;
        
        [self addSubview:btn];
        
        [self.buttons addObject:btn];
    }];
    
    [self addSubview:_indicator];
    
    self.contentSize = CGSizeMake([self.buttons[self.buttons.count - 1] getMaxX], [self getH]);
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, [self getH] - 1, SCREEN_WIDTH, 1)];
    seperator.backgroundColor = WhiteColor(0, .08);
    
    [self addSubview:seperator];
    
    [self selectMenuAtIndex:_currentIndex];
}

- (void)selectMenuAtIndex:(NSUInteger)index{
    [self itemSelected:self.buttons[index]];
}

- (void)itemSelected:(id)sender{
    NSIndexSet *sets = [self.buttons indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isHighlighted];
    }];
    if(sets.count > 0){
        [sets enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [self.buttons[idx] setHighlighted:NO];
        }];
    }
    
    NSUInteger index = [sender tag];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.indicator setX:[sender getMinX]];
        [self.indicator setW:[sender getW]];
    } completion:^(BOOL finished) {
        [sender setHighlighted:YES];
        if(self.onSelectHandler){
            self.onSelectHandler(index);
        }
    }];
}

@end
