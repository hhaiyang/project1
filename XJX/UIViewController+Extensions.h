//
//  UIViewController+Extensions.h
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onControllerDisappear)();

@interface UIViewController (Extensions)

@property (nonatomic,copy) onControllerDisappear onControllerDisappearHandler;

- (CGRect)bounds;

- (void)addSubview:(UIView *)view;

@end
