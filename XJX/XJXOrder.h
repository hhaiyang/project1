//
//  XJXOrder.h
//  XJX
//
//  Created by Cai8 on 16/2/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXOrder : NSObject

@property (nonatomic,assign) NSUInteger ID;
@property (nonatomic,assign) BOOL paid;
@property (nonatomic,copy) NSString *custom_need;
@property (nonatomic,copy) NSString *serialno;
@property (nonatomic,strong) id shipping;
@property (nonatomic,strong) id item;

@end
