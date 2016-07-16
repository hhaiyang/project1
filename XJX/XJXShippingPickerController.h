//
//  XJXShippingPickerController.h
//  XJX
//
//  Created by Cai8 on 16/1/23.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

typedef void (^didPickShippingInfo)(BOOL needReload);

@interface XJXShippingPickerController : BaseController

@property (nonatomic,copy) didPickShippingInfo didPickShippingInfoHandler;

@end
