//
//  XJXProduct.h
//  XJX
//
//  Created by Cai8 on 16/1/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadImageEntity.h"

@interface XJXProduct : NSObject

@property (nonatomic,assign) NSUInteger ID;

@property (nonatomic,strong) UploadImageEntity *image;


@end
