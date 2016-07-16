//
//  NetworkingDataModel.h
//  Deal
//
//  Created by Barton on 14-6-8.
//  Copyright (c) 2014年 OriginalityPush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingDataModel : NSObject

@property (nonatomic,assign) BOOL isFilePath;//参数是否是文件
@property (nonatomic,copy) NSString *filename;//文件名(如果参数是文件)
@property (nonatomic,strong) NSData *data;//参数值(Value)
@property (nonatomic,copy) NSString *name;//参数的名字(key)

@end
