//
//  XJXToolbar.h
//  XJX
//
//  Created by Cai8 on 16/1/13.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onFav)();
typedef void (^onBuy)();
typedef void (^onAppendWishlist)();

@interface XJXCrowdFundingToolbar : UIView

@property (nonatomic,copy) onFav onFavHandler;
@property (nonatomic,copy) onBuy onBuyHandler;
@property (nonatomic,copy) onAppendWishlist onAppendWishlistHandler;

@end
