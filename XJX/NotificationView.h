//
//  NotificationView.h
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationView : UIView

+ (instancetype)sharedView;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)show;
- (void)hide;

@end
