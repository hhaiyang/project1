//
//  XJXReservationCoverView.h
//  XJX
//
//  Created by Cai8 on 16/1/25.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditingLabel.h"

@protocol XJXReservationCoverViewDelegate <NSObject>

- (void)didWeddingInfoChanged:(id)weddinginfo;

@end

@interface XJXReservationCoverView : UIView

@property (nonatomic,assign) id<XJXReservationCoverViewDelegate> delegate;

@property (nonatomic,copy) NSString *groomname;
@property (nonatomic,copy) NSString *bridename;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) id coverEntity;

@end
