//
//  NSString+Extensions.h
//  XJX
//
//  Created by Cai8 on 15/11/18.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

+ (NSString *)readFromFile:(NSString *)file type:(NSString *)type;

- (BOOL)isEmpty;

- (NSString *)stringFromString:(NSString *)start to:(NSString *)end;
- (NSString *)stringToString:(NSString *)end;
- (NSString *)stringFromString:(NSString *)start;
- (NSString *)stringFromString:(NSString *)start to:(NSString *)end or:(NSString *)orstr;

- (BOOL)isStartWithString:(NSString *)str;

- (NSURL *)normalizeNSURL;

- (id)fromJson;

- (NSString *)toBase64;
- (NSString *)fromBase64;

- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font constrainToSize:(CGSize)constrainSize;

- (NSAttributedString *)priceFormatAttributeWithFont:(UIFont *)font symbolFont:(UIFont *)symbolFont color:(UIColor *)color;

@end
