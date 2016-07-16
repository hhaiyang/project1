//
//  XJXShoppingCard.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJXCartSwiperView.h"

@class XJXShoppingCard;
typedef void (^onModelClicked)(XJXShoppingCard *card);

@interface XJXShoppingCard : XJXBaseCell

@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *model;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int amount;

@property (nonatomic,assign) BOOL editingStatus;

@property (nonatomic,copy) onModelClicked modelClickHandler;

- (void)setSwiperViewOnTouched:(onSwiperButtonClicked)clicked;

@end
