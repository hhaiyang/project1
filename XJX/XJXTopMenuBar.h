//
//  XJXTopMenuBar.h
//  XJX
//
//  Created by Cai8 on 16/2/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didSelectMenuBarAtIndex)(NSUInteger index);

@interface XJXTopMenuBar : UIScrollView

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,copy) didSelectMenuBarAtIndex onSelectHandler;

- (instancetype)initWithMenuItems:(NSArray *)items startIndex:(int)index;

@end
