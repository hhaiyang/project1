//
//  XJXReservationDashboardButtonCell.h
//  XJX
//
//  Created by Cai8 on 16/2/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

@class XJXReservationDashboardButtonCell;

typedef void (^onButtonPressed)(XJXReservationDashboardButtonCell *cell);

@interface XJXReservationDashboardButtonCell : XJXBaseCell

@property (nonatomic,copy) NSString *unit;
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int number;

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,copy) NSString *buttonTitle;

@property (nonatomic,copy) onButtonPressed buttonClickHandler;

@end
