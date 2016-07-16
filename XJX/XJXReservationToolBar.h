//
//  XJXReservationToolBar.h
//  XJX
//
//  Created by Cai8 on 16/2/2.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onReservationPublish)();

@interface XJXReservationToolBar : UIView

@property (nonatomic,copy) onReservationPublish publishHandler;

@end
