//
//  XJXBaseCell.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RIGHT_SPACING 80

@interface XJXBaseCell : UITableViewCell

@property (nonatomic,assign) BOOL accessoryEnabled;
@property (nonatomic,assign) BOOL checkable;
@property (nonatomic,strong) UIView *checkableView;
@property (nonatomic,strong) CheckEditor *editor;

@property (nonatomic,strong) UIView *seperator;

- (void)initUI;
- (void)layout;
- (void)initCheckableView;

- (void)setCheck:(BOOL)check;
- (void)setEditorOnCheck:(onEditorCheckStatusChanged)editorChangedHandler;

@end
