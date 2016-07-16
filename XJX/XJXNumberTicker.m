//
//  XJXNumberTicker.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXNumberTicker.h"

#define BUTTON_HEIGHT 14

#define TICKER_HEIGHT 35

@implementation XJXNumberTicker
{
    UILabel *displayLb;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, TICKER_HEIGHT)]){
        UIButton *btnMinus = [UIControlsUtils buttonWithTitle:@"" background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"minus"] target:self selector:@selector(minus) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        UIButton *btnPlus = [UIControlsUtils buttonWithTitle:@"" background:[UIColor clearColor] backroundImage:[UIImage imageNamed:@"plus"] target:self selector:@selector(plus) padding:UIEdgeInsetsZero frame:CGRectMake(0, 0, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        [btnPlus setX:self.bounds.size.width - BUTTON_HEIGHT - ((TICKER_HEIGHT - BUTTON_HEIGHT) / 2)];
        [btnPlus verticalCenteredOnView:self];
        [btnMinus setX:(TICKER_HEIGHT - BUTTON_HEIGHT) / 2];
        [btnMinus verticalCenteredOnView:self];
        
        displayLb = [[UILabel alloc] initWithFrame:CGRectMake([btnMinus getMaxX], 0, btnPlus.frame.origin.x - [btnMinus getMaxX], TICKER_HEIGHT)];
        displayLb.font = [Theme defaultTheme].titleFont;
        displayLb.textColor = [Theme defaultTheme].highlightTextColor;
        displayLb.textAlignment = NSTextAlignmentCenter;
        displayLb.text = @"1";
        
        [self addSubview:btnMinus];
        [self addSubview:btnPlus];
        [self addSubview:displayLb];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 0.5 * TICKER_HEIGHT;
        self.layer.borderColor = [Theme defaultTheme].highlightTextColor.CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)minus{
    int value = [displayLb.text intValue] - 1;
    displayLb.text = [NSString stringWithFormat:@"%d",MAX(value,1)];
}

- (void)plus{
    int value = [displayLb.text intValue] + 1;
    displayLb.text = [NSString stringWithFormat:@"%d",MAX(value,1)];
}

- (int)value{
    return [displayLb.text intValue];
}

- (void)setValue:(int)value{
    displayLb.text = [NSString stringWithFormat:@"%d",value];
}

@end
