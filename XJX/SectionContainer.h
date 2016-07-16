//
//  SectionContainer.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionContainer : XJXLayoutNode

@property (nonatomic,strong) UIColor *backgroundColor;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *subTitleColor;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *subTitleFont;

@property (nonatomic,strong) UIView *contentView;

@end
