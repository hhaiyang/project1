//
//  XJXLoginController.h
//  XJX
//
//  Created by Cai8 on 16/1/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

typedef void (^onLoginSuccess)(BOOL success);

@interface XJXLoginController : BaseController

@property (nonatomic,copy) onLoginSuccess onLoginSuccessHandler;

@end
