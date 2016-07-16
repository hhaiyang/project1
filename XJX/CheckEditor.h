//
//  CheckEditor.h
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckEditor;

typedef void (^onEditorCheckStatusChanged)(CheckEditor *editor,id sender);

@interface CheckEditor : UIButton

@property (nonatomic,assign) BOOL checked;

@property (nonatomic,weak) id sender;

@property (nonatomic,copy) onEditorCheckStatusChanged statusChangedHandler;

- (void)setNoHandlerChecked:(BOOL)checked;

@end
