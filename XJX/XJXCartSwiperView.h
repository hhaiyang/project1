//
//  XJXCartSwiperView.h
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJXShoppingCard;

typedef void (^onSwiperButtonClicked)(XJXShoppingCard *sender,NSUInteger buttonTouchedIndex);

@interface XJXCartSwiperView : UIView

@property (nonatomic,weak) UIView *sender;
@property (nonatomic,copy) onSwiperButtonClicked buttonClicked;

- (void)addButtonWithTitle:(NSString *)title background:(UIColor *)background bg:(UIImage *)bg padding:(UIEdgeInsets)padding;

- (CGFloat)getWidth;

@end
