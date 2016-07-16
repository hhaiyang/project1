//
//  XJXBrick.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJXBrick;

typedef void (^onBrickTouched)(XJXBrick *brick);

@interface XJXBrick : XJXLayoutNode

@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image_url;

@property (nonatomic,assign) CGFloat borderRadius;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIFont *titleFont;

@property (nonatomic,copy) onBrickTouched touchedHandler;

@end
