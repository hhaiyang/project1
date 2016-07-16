//
//  XJXSlide.h
//  XJX
//
//  Created by Cai8 on 16/1/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXSlide : UIView{
    UIImageView *imageView;
}

- (void)loadImageFromUrl:(NSString *)url;

- (UIImageView *)coverView;

@end
