//
//  XJXAddWIshItemController.h
//  XJX
//
//  Created by Cai8 on 16/2/2.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didSelectWishItems)(NSArray *selectedItems);

@interface XJXAddWIshItemController : UIView

@property (nonatomic,copy) didSelectWishItems itemSelectedHandler;

+ (void)showWithItemSelected:(didSelectWishItems)onSelected;

@end
