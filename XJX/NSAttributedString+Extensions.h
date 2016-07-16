//
//  NSAttributedString+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Extensions)

- (CGSize)size;
- (CGSize)sizeWithConstraintSize:(CGSize)size;

+ (instancetype)attributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height textAlignment:(NSTextAlignment)alignment;
+ (instancetype)attributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height;
+ (instancetype)mutableAttributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height;

@end
