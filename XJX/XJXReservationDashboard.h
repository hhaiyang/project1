//
//  XJXReservationDashboard.h
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJXReservationDashboard;

@protocol XJXReservationDashboardDelegate <NSObject>

- (NSUInteger)weddingIdOfDashboard:(XJXReservationDashboard *)dashboard;

- (NSString *)coverUrlOfDashboard:(XJXReservationDashboard *)dashboard;

@end

@interface XJXReservationDashboard : UIView

@property (nonatomic,assign) id<XJXReservationDashboardDelegate> delegate;

- (void)reload;

@end
