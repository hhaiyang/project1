//
//  UIViewController+Extensions.m
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import "UIViewController+Extensions.h"

#import <objc/runtime.h>

static char DISAPPEAR_NOTIFIER_KEY;

@implementation UIViewController (Extensions)
@dynamic onControllerDisappearHandler;

- (void)setOnControllerDisappearHandler:(onControllerDisappear)onControllerDisappearHandler{
    objc_setAssociatedObject(self, &DISAPPEAR_NOTIFIER_KEY, onControllerDisappearHandler, OBJC_ASSOCIATION_COPY);
}

- (onControllerDisappear)onControllerDisappearHandler{
    return objc_getAssociatedObject(self, &DISAPPEAR_NOTIFIER_KEY);
}

- (void)viewDidDisappear:(BOOL)animated{
    if(self.onControllerDisappearHandler){
        self.onControllerDisappearHandler();
    }
}

- (CGRect)bounds{
    return self.view.bounds;
}

- (void)addSubview:(UIView *)view{
    [self.view addSubview:view];
}

@end
