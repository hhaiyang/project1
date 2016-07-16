//
//  XJXShoppingCartToolbar.h
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onOrder)();
typedef void (^onSelectAll)(BOOL isAllSelected);

@interface XJXShoppingCartToolbar : UIView

@property (nonatomic,strong) CheckEditor *editor;

@property (nonatomic,copy) onSelectAll onSelectAllHandler;

@property (nonatomic,copy) onOrder onOrderHandler;

@property (nonatomic,assign) CGFloat totalPrice;

- (void)reset;

@end
