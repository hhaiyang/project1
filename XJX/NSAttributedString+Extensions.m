//
//  NSAttributedString+Extensions.m
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "NSAttributedString+Extensions.h"

@implementation NSAttributedString (Extensions)

- (CGSize)size{
    return [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

- (CGSize)sizeWithConstraintSize:(CGSize)size{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

+ (instancetype)attributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height textAlignment:(NSTextAlignment)alignment{
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragarphStyle setAlignment:alignment];
    [paragarphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragarphStyle setLineSpacing:height];
    id attributes = @{
                      NSParagraphStyleAttributeName : paragarphStyle,
                      NSForegroundColorAttributeName : textColor,
                      NSFontAttributeName : font
                      };
    return [[NSAttributedString alloc] initWithString:str attributes:attributes];
}

+ (instancetype)attributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragarphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragarphStyle setLineSpacing:height];
    id attributes = @{
                      NSParagraphStyleAttributeName : paragarphStyle,
                      NSForegroundColorAttributeName : textColor,
                      NSFontAttributeName : font
                      };
    return [[NSAttributedString alloc] initWithString:str attributes:attributes];
}

+ (instancetype)mutableAttributeStringWithString:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragarphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragarphStyle setLineSpacing:height];
    id attributes = @{
                      NSParagraphStyleAttributeName : paragarphStyle,
                      NSForegroundColorAttributeName : textColor,
                      NSFontAttributeName : font
                      };
    return [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
}

@end
