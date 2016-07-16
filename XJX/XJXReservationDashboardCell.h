//
//  XJXReservationDashboardCell.h
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

@interface XJXReservationDashboardCell : XJXBaseCell

@property (nonatomic,copy) NSString *unit;
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int number;

@property (nonatomic,assign) int total;

@end
