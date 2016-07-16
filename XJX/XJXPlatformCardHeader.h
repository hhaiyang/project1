//
//  XJXPlatformCardHeader.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJXPlatformCardHeader;
typedef void (^onActionButtonTouched)(XJXPlatformCardHeader *header);

@interface XJXPlatformCardHeader : UITableViewHeaderFooterView

@property (nonatomic,copy) NSString *logo_url;
@property (nonatomic,copy) NSString *platform_name;

@property (nonatomic,copy) NSAttributedString *desc;

@property (nonatomic,assign) BOOL checkable;

@property (nonatomic,strong) UIView *checkableView;
@property (nonatomic,strong) CheckEditor *editor;

@property (nonatomic,assign) NSUInteger section;
@property (nonatomic,assign) BOOL editing;

- (void)setEditorOnCheck:(onEditorCheckStatusChanged)editorChangedHandler;

- (void)layout;

- (void)setActionButtonWithTitle:(NSString *)title action:(onActionButtonTouched)actionHandler;

@end
