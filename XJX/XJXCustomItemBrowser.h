//
//  XJXCustomItemBrowser.h
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

@class XJXCustomWishItem;

typedef void (^onAnalysisDone)(XJXCustomWishItem *item);

@interface XJXCustomItemBrowser : BaseController

+ (void)analysisItemWithUrl:(NSString *)url completion:(onAnalysisDone)handler;

@end
