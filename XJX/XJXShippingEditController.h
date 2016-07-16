//
//  XJXShippingEditController.h
//  XJX
//
//  Created by Cai8 on 16/1/22.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

typedef void (^onShippingEditingDone)();

@interface XJXShippingEditController : BaseController

@property (nonatomic,copy) onShippingEditingDone onEditingDoneHandler;

@end
