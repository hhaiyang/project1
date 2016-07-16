//
//  XJXSlide.m
//  XJX
//
//  Created by Cai8 on 16/1/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXSlide.h"

@implementation XJXSlide

- (instancetype)init{
    if(self = [super init]){
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.masksToBounds = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
    return self;
}

- (UIImageView *)coverView{
    return imageView;
}

- (void)loadImageFromUrl:(NSString *)url{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [UIView transitionWithView:imageView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            // Set the new image
                            // Since its done in the animation block, the change will be animated
                            imageView.image = image;
                        } completion:^(BOOL finished) {
                            // Do whatever when the animation is finished
                        }];
    }];
}

@end
