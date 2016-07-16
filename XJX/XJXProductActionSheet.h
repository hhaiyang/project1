//
//  XJXProductActionSheet.h
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onClose)();
@interface XJXProductActionSheetHeader : XJXLayoutNode

@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) CGFloat price;

@property (nonatomic,copy) onClose closeHandler;

@end

@interface XJXProductActionSheetModels : XJXLayoutNode

@property (nonatomic,strong) NSArray *models;
@property (nonatomic,strong) NSArray *selectedModel;

- (NSArray *)getSelectedModels;

@end

@interface XJXProductActionSheetContent : XJXLayoutNode

@property (nonatomic,strong) XJXProductActionSheetModels *model;
@property (nonatomic,assign) int amount;

- (NSDictionary *)getSelectedModelAndAmount;

@end

typedef void (^onActionSheetDone)();
@interface XJXProductActionSheetFooter : XJXLayoutNode

@property (nonatomic,copy) onActionSheetDone okHandler;

@end

@interface XJXProductActionSheet : XJXLayoutNode

@property (nonatomic,copy) NSString *identifier;

@property (nonatomic,strong) XJXProductActionSheetHeader *header;
@property (nonatomic,strong) XJXProductActionSheetContent *content;
@property (nonatomic,strong) XJXProductActionSheetFooter *footer;

@property (nonatomic,strong) UIView *containerView;

+ (XJXProductActionSheet *)showWithModels:(NSArray *)models title:(NSString *)title price:(CGFloat)price imageUrl:(NSString *)image_url identifier:(NSString *)identifier selectedModel:(NSArray *)model amount:(int)amount onSheetDone:(onActionSheetDone)done;

- (BOOL)valueChanged;

- (void)close;

@end
