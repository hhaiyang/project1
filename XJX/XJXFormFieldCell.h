//
//  XJXFormFieldCell.h
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

#define LEFT_SPACING 100

@interface XJXFormFieldCell : XJXBaseCell

@property (nonatomic,copy) NSString *field_title;

@property (nonatomic,strong) UIColor *titleColor;

@end
