//
//  UIControlsUtils.h
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IconButton.h"

@interface UIControlsUtils : NSObject

+ (UIButton *)buttonWithTitle:(NSString *)title background:(UIColor *)background backroundImage:(UIImage *)image target:(id)target selector:(SEL)selector padding:(UIEdgeInsets)padding frame:(CGRect)frame;

+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font;
+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;
+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment constrainSize:(CGSize)constrainSize;
+ (UILabel *)labelWithPrice:(CGFloat)price;
+ (UILabel *)labelWithPrice:(CGFloat)price font:(UIFont *)font symbolFont:(UIFont *)symbolFont;
+ (UILabel *)labelWithAttributeTitle:(NSAttributedString *)title textAlignment:(NSTextAlignment)alignment;

+ (UIView *)addSectionHeaderOnPoint:(CGPoint)point text:(NSString *)text onView:(UIView *)view;

@end
