//
//  XJXCustomWishItemAnalysisResultView.h
//  XJX
//
//  Created by Cai8 on 16/1/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJXCustomWishItem.h"

typedef void (^onItemAdd)(XJXCustomWishItem *item);

@interface XJXCustomWishItemAnalysisResultView : UIScrollView

+ (void)showResultViewWithTitle:(NSString *)title desc:(NSString *)desc price:(NSString *)price imageUrl:(NSString *)image_url url:(NSString *)url onAdded:(onItemAdd)addHandler;

- (void)show;

- (void)close;

@end
