//
//  XJXTagView.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXTagView.h"

#define TITLE_TAG_MARGIN 5
#define TAG_ITEM_MARGIN 5

@interface XJXTagView()

@property (nonatomic,strong) NSArray *groups;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,assign) UIEdgeInsets padding;

@end

@implementation XJXTagView

+ (CGPoint)pointSection:(XJXTagGroup *)group atPoint:(CGPoint)point padding:(UIEdgeInsets)padding{
    __block CGPoint cursor = point;
    CGSize size = [group.group_title sizeWithFont:[Theme defaultTheme].titleFont constrainToSize:CGSizeMake(SCREEN_WIDTH - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, MAXFLOAT)];
    cursor.y += size.height + TITLE_TAG_MARGIN;
    
    [group.tags enumerateObjectsUsingBlock:^(XJXTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.padding = padding;
        CGSize _size = [obj sizeForTag];
        if(_size.width + cursor.x + TAG_ITEM_MARGIN > SCREEN_WIDTH - padding.right){
            cursor.y += _size.height + TAG_ITEM_MARGIN;
            cursor.x = padding.left;
        }
        if(idx != group.tags.count - 1){
            cursor.x += _size.width;
        }
        else{
            cursor.y += _size.height + TITLE_TAG_MARGIN;
        }
    }];
    return cursor;
}

+ (CGSize)sizeForTagGroups:(NSArray *)groups padding:(UIEdgeInsets)padding{
    __block CGPoint cursor = CGPointMake(padding.left, padding.top);
    [groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        cursor = [self pointSection:obj atPoint:cursor padding:padding];
    }];
    return CGSizeMake(SCREEN_WIDTH, cursor.y + padding.bottom);
}

- (instancetype)initWithTagGroups:(NSArray *)groups selectedTags:(NSArray *)tags padding:(UIEdgeInsets)padding{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [XJXTagView sizeForTagGroups:groups padding:padding].height)]){
        _groups = groups;
        _tags = tags;
        _padding = padding;
        [self setup];
    }
    return self;
}

- (void)setup{
    __block CGPoint cursor = CGPointMake(self.padding.left, self.padding.top);
    [_groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        cursor = [self renderSection:obj atPoint:CGPointMake(cursor.x, cursor.y)];
    }];
}

- (CGPoint)renderSection:(XJXTagGroup *)group atPoint:(CGPoint)point{
    __block CGPoint cursor = point;
    UILabel *sectionTitleLb = [UIControlsUtils labelWithTitle:group.group_title color:[Theme defaultTheme].schemeColor font:[Theme defaultTheme].titleFont];
    [sectionTitleLb setX:cursor.x];
    [sectionTitleLb setY:cursor.y];
    
    [self addSubview:sectionTitleLb];
    
    cursor.y += [sectionTitleLb getH] + TITLE_TAG_MARGIN;
    NSString *tag_val = @"";
    NSUInteger index = [self.tags indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj[@"model_attr"] isEqualToString:group.group_title];
    }];
    if(index != NSNotFound){
        tag_val = self.tags[index][@"model_value"];
    }
    [group.tags enumerateObjectsUsingBlock:^(XJXTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeForTag];
        if(![self canRenderOnPoint:cursor forItem:obj]){
            cursor.y += size.height + TAG_ITEM_MARGIN;
            cursor.x = self.padding.left;
        }

        [obj renderOnPoint:cursor onView:self];
        if(idx != group.tags.count - 1){
            cursor.x += size.width + TAG_ITEM_MARGIN;
        }
        else{
            cursor.y += size.height + TITLE_TAG_MARGIN;
        }
        if([tag_val isEqualToString:obj.title]){
            [obj setSelected:YES];
        }
    }];
    if(!self.tags)
        [group selectTag:group.tags[0]];
    return cursor;
}

- (BOOL)canRenderOnPoint:(CGPoint)point forItem:(XJXTag *)item{
    return [item sizeForTag].width + point.x + TAG_ITEM_MARGIN < self.bounds.size.width - self.padding.right;
}

- (NSArray *)getSelectedTags{
    __block BOOL error = NO;
    NSMutableArray *selects = [NSMutableArray array];
    [_groups enumerateObjectsUsingBlock:^(XJXTagGroup *group, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [group.tags indexOfObjectPassingTest:^BOOL(XJXTag *_obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
            return _obj.selected;
        }];
        if(index != NSNotFound){
            [selects addObject:group.tags[index]];
        }
        else{
            error = YES;
        }
    }];
    if(error){
        return nil;
    }
    return selects;
}

@end
