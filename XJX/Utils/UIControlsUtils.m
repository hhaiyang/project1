//
//  UIControlsUtils.m
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import "UIControlsUtils.h"

@implementation UIControlsUtils

+ (UIButton *)buttonWithTitle:(NSString *)title background:(UIColor *)background backroundImage:(UIImage *)image target:(id)target selector:(SEL)selector padding:(UIEdgeInsets)padding frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(frame.size.width != 0){
        [btn setFrame:frame];
    }
    else{
         [btn setFrame:CGRectMake(0, 0, [title sizeWithFont:[Theme defaultTheme].normalTextFont].width + padding.left + padding.right, [title sizeWithFont:[Theme defaultTheme].normalTextFont].height + padding.top + padding.bottom)];   
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:background];
    [btn.titleLabel setFont:[Theme defaultTheme].normalTextFont];
    [btn setTitleColor:[Theme defaultTheme].textColor forState:UIControlStateNormal];
    if(image)
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font{
    return [self labelWithTitle:title color:color font:font textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithPrice:(CGFloat)price{
    return [self labelWithPrice:price font:[Theme defaultTheme].h2Font symbolFont:[Theme defaultTheme].normalTextFont];
}

+ (UILabel *)labelWithPrice:(CGFloat)price font:(UIFont *)font symbolFont:(UIFont *)symbolFont{
    NSString *pricestr = [NSString stringWithFormat:@"￥%.2lf",price];
    NSMutableAttributedString *priceval = [[NSMutableAttributedString alloc] initWithString:pricestr attributes:@{NSFontAttributeName : font,
                                                                                                                                                     NSForegroundColorAttributeName : [Theme defaultTheme].highlightTextColor}];
    NSRange decimalRange = [pricestr rangeOfString:[pricestr stringFromString:@"."]];
    [priceval addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, 1)];
    [priceval addAttribute:NSFontAttributeName value:symbolFont range:decimalRange];
    UILabel *priceLb = [UIControlsUtils labelWithAttributeTitle:priceval textAlignment:NSTextAlignmentJustified];
    return priceLb;
}

+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment constrainSize:(CGSize)constrainSize{
    CGSize size = [title sizeWithFont:font constrainToSize:constrainSize];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ceil(size.width), ceil(size.height))];
    lb.numberOfLines = 0;
    lb.lineBreakMode = NSLineBreakByTruncatingTail;
    lb.font = font;
    lb.textColor = color;
    lb.textAlignment = alignment;
    lb.text = title;
    return lb;
}

+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment{
    return [self labelWithTitle:title color:color font:font textAlignment:alignment constrainSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
}

+ (UILabel *)labelWithAttributeTitle:(NSAttributedString *)title textAlignment:(NSTextAlignment)alignment{
    CGSize size = [title size];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    lb.numberOfLines = 0;
    lb.lineBreakMode = NSLineBreakByTruncatingTail;
    lb.textAlignment = alignment;
    lb.attributedText = title;
    return lb;
}

+ (UIView *)addSectionHeaderOnPoint:(CGPoint)point text:(NSString *)text onView:(UIView *)view{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, SCREEN_WIDTH, [text sizeWithFont:[Theme defaultTheme].normalTextFont].height + 2 * SECTION_TITLE_PADDING_VETI)];
    UILabel *title = [self labelWithTitle:text color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].normalTextFont textAlignment:NSTextAlignmentCenter];
    [title setX:(sectionHeader.bounds.size.width - title.bounds.size.width) / 2.0];
    [title setY:(sectionHeader.bounds.size.height - title.bounds.size.height) / 2.0];
    UIView *left_line = [[UIView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, (sectionHeader.bounds.size.height - 1) / 2.0, title.frame.origin.x - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - SECTION_TITLE_PADDING, 1)];
    UIView *right_line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame) + SECTION_TITLE_PADDING,(sectionHeader.bounds.size.height - 1) / 2.0, sectionHeader.bounds.size.width - CGRectGetMaxX(title.frame) - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - SECTION_TITLE_PADDING, 1)];
    
    left_line.backgroundColor = right_line.backgroundColor = hex(@"#dfdfdf");
    
    [sectionHeader addSubview:left_line];
    [sectionHeader addSubview:title];
    [sectionHeader addSubview:right_line];
    
    [view addSubview:sectionHeader];
    
    return sectionHeader;
}

@end
