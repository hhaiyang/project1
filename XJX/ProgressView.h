//
//  ProgressView.h
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onProgressChanging)(NSArray *currentValues);

@interface ProgressView : UIView

@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *trackColor;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,copy) onProgressChanging progressingHandler;

- (void)setProgress:(CGFloat)progress customParamsFrom:(NSArray *)customParams customParamsTo:(NSArray *)customParamsTo;

@end
