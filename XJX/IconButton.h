//
//  IconButton.h
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconButton;

typedef enum {
    kIconButtonStatusInActive = 0,
    KIconButtonStatusActive = 1
}IconButtonStatus;

typedef void (^onClick)(IconButton *button);

@interface IconButton : UIView
{
    NSMutableDictionary *_settings;
    
    IconButtonStatus _status;
    NSString *_title;
}
@property (nonatomic,assign) UIEdgeInsets contentPadding;
@property (nonatomic,assign) UIEdgeInsets imagePadding;
@property (nonatomic,assign) UIEdgeInsets titlePadding;

@property (nonatomic,readonly) IconButtonStatus currentStatus;
@property (nonatomic,readonly) NSString *currentTitle;

@property (nonatomic,strong) UIFont *font;

@property (nonatomic,copy) onClick onClickHandler;

- (void)setIcon:(UIImage *)icon forState:(IconButtonStatus)status;
- (void)setTitle:(NSString *)title forState:(IconButtonStatus)status;
- (void)setTitleColor:(UIColor *)titleColor forState:(IconButtonStatus)status;
- (void)relayout;
- (void)toggle;

@end
