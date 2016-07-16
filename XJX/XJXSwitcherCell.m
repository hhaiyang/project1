//
//  XJXSwitcherCell.m
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXSwitcherCell.h"

@interface XJXSwitcherCell()

@property (nonatomic,strong) UISwitch *switcher;

@property (nonatomic,strong) UILabel *descLb;

@end

@implementation XJXSwitcherCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layout{
    [super layout];
    [_switcher setX:[self getW] - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - [_switcher getW]];
    [_switcher verticalCenteredOnView:self];
    
    [_descLb recalculateSize];
    [_descLb setX:[_switcher getMinX] - 5 - [_descLb getW]];
    [_descLb verticalCenteredOnView:self];
    
}

- (void)initUI{
    [super initUI];
    
    _descLb = [UIControlsUtils labelWithTitle:@"" color:[Theme defaultTheme].highlightTextColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentRight];
    _descLb.numberOfLines = 1;
    
    _switcher = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
    [_switcher setOnTintColor:[Theme defaultTheme].schemeColor];
    [_switcher addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switcher];
    [self addSubview:_descLb];
}

- (void)setOn:(BOOL)on{
    _switcher.on = on;
}

- (BOOL)on{
    return _switcher.on;
}

- (void)switchTouched:(id)sender{
    if(self.stateChangedHandler){
        self.stateChangedHandler([self on]);
    }
}

- (void)setDesc:(NSString *)desc{
    _desc = desc;
    _descLb.text = _desc;
    [self layout];
}

- (void)setEnabled:(BOOL)enabled{
    _switcher.enabled = enabled;
}

@end
