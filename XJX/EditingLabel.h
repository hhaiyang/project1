//
//  EditingLabel.h
//  XJX
//
//  Created by Cai8 on 16/1/25.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditingLabel;

@protocol EditingLabelDelegate <NSObject>

- (void)didEditing:(EditingLabel *)label;

@end

@interface EditingLabel : UIView

@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,assign) id<EditingLabelDelegate> delegate;

- (instancetype)initWithText:(NSString *)text;

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font;

- (void)setText:(NSString *)text;

- (void)recalculateSize;

@end
