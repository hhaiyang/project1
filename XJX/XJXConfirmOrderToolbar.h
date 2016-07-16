//
//  XJXConfirmOrderToolbar.h
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onOrder)();

@interface XJXConfirmOrderToolbar : UIView

@property (nonatomic,copy) onOrder onOrderHandler;

@property (nonatomic,assign) CGFloat totalPrice;

@end
