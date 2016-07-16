//
//  XJXCustomWishItem.h
//  XJX
//
//  Created by Cai8 on 16/1/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXCustomWishItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int amount;

@end
