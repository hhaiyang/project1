//
//  PlaceholderTextView.h
//  XJX
//
//  Created by Cai8 on 16/1/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UIView

@property (nonatomic,assign) UIEdgeInsets padding;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *placeholderColor;

@property (nonatomic,copy) NSString *text;

@end
