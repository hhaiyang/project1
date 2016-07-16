//
//  XJXWishlistToolbar.h
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJXWishlistToolbar;
typedef void (^onUrlAdded)(NSString *url);
typedef void (^onLoadingAnimationComplete)(XJXWishlistToolbar *toolbar);

@interface XJXWishlistToolbar : UIView

@property (nonatomic,copy) onUrlAdded urlAddedHandler;

@property (nonatomic,strong) UITextField *urlField;

- (void)startLoadingAnimationOnCompletion:(onLoadingAnimationComplete)complete;
- (void)stopAnimation;

@end
