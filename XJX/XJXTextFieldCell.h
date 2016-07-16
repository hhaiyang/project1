//
//  XJXTextFieldCell.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onTextChanged)(NSString *text);

@interface XJXTextFieldCell : XJXFormFieldCell

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *text;

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) UIKeyboardType keyboardType;

@property (nonatomic,strong) UIView *rightView;

@property (nonatomic,copy) onTextChanged onTextChangedHandler;

@end
