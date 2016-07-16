//
//  XJXWebBrowser.h
//  XJX
//
//  Created by Cai8 on 16/1/7.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"
#import <WebKit/WebKit.h>

@interface XJXWebBrowser : BaseController

+ (XJXWebBrowser *)browserWithRedirectUrl:(NSString *)url;

@end
