//
//  XJXURL.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXURL : NSObject

@property (nonatomic,copy) NSString *absoluteURL;
@property (nonatomic,copy) NSString *scheme;
@property (nonatomic,copy) NSString *host;
@property (nonatomic,copy) NSMutableDictionary *urlParams;

+ (XJXURL *)urlWithString:(NSString *)url;

/*
 *  @"ishangmai://{host}?{params}
 *  @"http | https://{host}?{params}
 */

@end
