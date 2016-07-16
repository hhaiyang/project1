//
//  XJXPageControl.m
//  XJX
//
//  Created by Cai8 on 16/1/10.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXPageControl.h"

#define NODE_MARGIN 12
#define NODE_SELECTED_WIDTH 16
#define NODE_RADIUS 3

@interface XJXPageControlNode : UIView

@property (nonatomic,assign) CGFloat ori_x;

@property (nonatomic,assign) BOOL selected;

@end

@implementation XJXPageControlNode

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if(selected){
        [UIView animateKeyframesWithDuration:.3 delay:0 options: UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
            [self setW: selected ? NODE_SELECTED_WIDTH : NODE_RADIUS * 2];
            [self setX:selected ? _ori_x - (NODE_SELECTED_WIDTH - NODE_RADIUS * 2) / 2 : _ori_x];
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [self setW:NODE_RADIUS * 2];
        [self setX:_ori_x];
    }
}

@end

@implementation XJXPageControl{
    NSUInteger pageCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithPageCount:(NSUInteger)count{
    if(self = [super initWithFrame:CGRectMake(0, 0, (NODE_RADIUS * 2) * count + (count - 1) * NODE_MARGIN, NODE_RADIUS * 2)]){
        pageCount = count;
        nodes = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    CGFloat offset = self.padding.left;
    for (int i=0; i<pageCount; i++) {
        XJXPageControlNode *node = [[XJXPageControlNode alloc] initWithFrame:CGRectMake(offset, self.padding.top, NODE_RADIUS * 2, NODE_RADIUS * 2)];
        node.layer.cornerRadius = NODE_RADIUS;
        node.layer.masksToBounds = YES;
        node.backgroundColor = WhiteColor(1, 1);
        node.ori_x = offset;
        [nodes addObject:node];
        [self addSubview:node];
        
        offset += NODE_RADIUS * 2 + NODE_MARGIN;
    }
}

- (void)setCount:(NSUInteger)count{
    [nodes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [nodes removeAllObjects];
    pageCount = count;
    [self initUI];
}

- (void)setCurrentIndex:(NSUInteger)index{
    [nodes enumerateObjectsUsingBlock:^(XJXPageControlNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:idx == index ? YES : NO];
    }];
}

@end
