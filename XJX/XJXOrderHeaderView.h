//
//  XJXOrderHeaderView.h
//  XJX
//
//  Created by Cai8 on 16/2/9.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXOrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic,copy) NSAttributedString *order_status;
@property (nonatomic,copy) NSString *shipping_status;

@end
