//
//  XJXCFRecordView.h
//  XJX
//
//  Created by Cai8 on 16/2/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXCFRecordViewBlock : UIView

@property (nonatomic,strong) NSString *image_url;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat money;

@end

@protocol XJXCFRecordViewDelegate <NSObject>

- (XJXCFRecordViewBlock *)blockAtIndex:(NSUInteger)index;

- (int)numberOfBlocks;

- (int)numberOfBlocksInHori;

- (CGFloat)marginOfBlock;

- (CGFloat)heightOfBlock;

@end

@interface XJXCFRecordView : UIView

@property (nonatomic,assign) id<XJXCFRecordViewDelegate> delegate;
@property (nonatomic,assign) UIEdgeInsets padding;

- (XJXCFRecordViewBlock *)dequeueBlockAtIndex:(NSUInteger)index;

+ (CGFloat)heightWithItemCount:(NSUInteger)count numberHori:(int)hori itemHeight:(CGFloat)itemHeight margin:(CGFloat)margin contentPadding:(UIEdgeInsets)padding;

- (void)reloadData;

@end
