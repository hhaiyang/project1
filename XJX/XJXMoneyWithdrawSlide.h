//
//  XJXMoneyWithdrawSlide.h
//  XJX
//
//  Created by Cai8 on 16/3/1.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXSlide.h"

@interface XJXMoneyWithdrawSlide : XJXSlide

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,assign) float price;

@end
