//
//  NSString+Extensions.m
//  XJX
//
//  Created by Cai8 on 15/11/18.
//  Copyright © 2015年 Cai8. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+ (NSString *)readFromFile:(NSString *)file type:(NSString *)type{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type] encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)isEmpty{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || self == nil;
}

- (NSString *)stringFromString:(NSString *)start to:(NSString *)end{
    NSRange range = [self rangeOfString:start];
    if(range.location != NSNotFound){
        NSString *subsequence = [self substringFromIndex:range.location + range.length];
        NSRange endRange = [subsequence rangeOfString:end];
        if(endRange.location != NSNotFound){
            return [subsequence substringToIndex:endRange.location];
        }
        else{
            return [self stringFromString:start];
        }
    }
    else{
        return @"";
    }
}
- (NSString *)stringFromString:(NSString *)start to:(NSString *)end or:(NSString *)orstr{
    NSString *result = [self stringFromString:start to:end];
    if([result isEmpty]){
        result = [self stringFromString:start to:orstr];
    }
    return result;
}

- (NSString *)stringFromString:(NSString *)start{
    NSRange range = [self rangeOfString:start];
    if(range.location != NSNotFound){
        NSString *subsequence = [self substringFromIndex:range.location + range.length];
        return subsequence;
    }
    else{
        return @"";
    }
}

- (NSString *)stringToString:(NSString *)end{
    NSRange range = [self rangeOfString:end];
    if(range.location != NSNotFound)
        return [self substringToIndex:range.location];
    else
        return @"";
}

- (NSURL *)normalizeNSURL{
    NSString *url = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:url];
}

- (CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font constrainToSize:CGSizeMake(SCREEN_WIDTH - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2, MAXFLOAT)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainToSize:(CGSize)constrainSize{
    CGSize size = [self boundingRectWithSize:constrainSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName : font} context:nil].size;
    return size;
}

- (BOOL)isStartWithString:(NSString *)str{
    return [self hasPrefix:str];
}

- (id)fromJson{
    NSError *err;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err){
        return nil;
    }
    else{
        return result;
    }
}

- (NSString *)toBase64{
    // Create NSData object
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    // Print the Base64 encoded string
    NSString *base64 = [data base64EncodedString];
    return base64;
}

- (NSString *)fromBase64{
    NSData *nsdataFromBase64String = [NSData dataFromBase64String:self];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}

- (NSAttributedString *)priceFormatAttributeWithFont:(UIFont *)font symbolFont:(UIFont *)symbolFont color:(UIColor *)color{
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",self];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [str addAttribute:NSFontAttributeName value:symbolFont range:[priceStr rangeOfString:@"￥"]];
    [str addAttribute:NSFontAttributeName value:font range:[priceStr rangeOfString:self]];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, priceStr.length)];
    return str;
}

@end
