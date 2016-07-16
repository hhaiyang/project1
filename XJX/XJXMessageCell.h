//
//  XJXMessageCell.h
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXMessageCell : XJXBaseCell

@property (nonatomic,assign) XJXMessageCellType messageType;
@property (nonatomic,assign) int badge;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *time;

@end
