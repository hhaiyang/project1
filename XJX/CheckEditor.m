//
//  CheckEditor.m
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "CheckEditor.h"

@implementation CheckEditor

- (instancetype)init{
    if(self = [super initWithFrame:CGRectMake(0, 0, 24, 24)]){
        self.checked = NO;
        self.layer.cornerRadius = 0.5 * 24;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[Theme defaultTheme].highlightTextColor colorWithAlphaComponent:.6].CGColor;
        self.layer.masksToBounds = YES;
        self.backgroundColor = WhiteColor(1, 1);
        
        [self setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChecked:(BOOL)checked{
    if(checked == _checked)
        return;
    
    _checked = checked;
    [self setSelected:checked];
    if(_statusChangedHandler){
        _statusChangedHandler(self,_sender);
    }
}

- (void)setNoHandlerChecked:(BOOL)checked{
    _checked = checked;
    [self setSelected:checked];    
}

- (void)toggle{
    self.checked = !self.checked;
}

@end
