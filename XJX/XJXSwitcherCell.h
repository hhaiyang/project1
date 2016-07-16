//
//  XJXSwitcherCell.h
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXFormFieldCell.h"

typedef void (^onSwitchStateChanged)(BOOL on);

@interface XJXSwitcherCell : XJXFormFieldCell

@property (nonatomic,assign) BOOL on;

@property (nonatomic,assign) BOOL enabled;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) onSwitchStateChanged stateChangedHandler;

@end
