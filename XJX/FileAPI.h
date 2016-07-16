//
//  FileAPI.h
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileAPI : NSObject

+ (MKNetworkOperation *)uploadBase64Image:(NSString *)base64Image completion:(onAPIRequestDone)handler;

@end
