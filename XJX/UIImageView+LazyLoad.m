//
//  UIImageView+LazyLoad.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "UIImageView+LazyLoad.h"

@implementation UIImageView (LazyLoad)

- (void)lazyWithUrl:(NSString *)url{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [UIView transitionWithView:self
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            // Set the new image
                            // Since its done in the animation block, the change will be animated
                            self.image = image;
                        } completion:^(BOOL finished) {
                            // Do whatever when the animation is finished
                        }];
    }];
}

@end
