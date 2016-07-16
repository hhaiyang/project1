//
//  XJXShippingCell.h
//  XJX
//
//  Created by Cai8 on 16/1/17.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXShippingCell : XJXBaseCell

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *tele;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,assign) BOOL needBG;

@property (nonatomic,assign) BOOL isEmpty;

@end
