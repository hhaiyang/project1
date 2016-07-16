//
//  UIImage+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)theURL;

+ (UIImage * _Nullable)imageWithFile:(NSString *)file type:(NSString *)type;

- (CGFloat)getFitHeightWithContainerWidth:(CGFloat)width;

- (UIImage * _Nullable)resizedImageToFitInSize:(CGSize)boundingSize;
- (UIImage * _Nullable)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

@end
