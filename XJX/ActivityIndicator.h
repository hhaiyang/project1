//
//  ActivityIndicator.h
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extensions.h"

@interface ActivityIndicator : UIView

+ (instancetype)sharedIndicator;

- (void)show;
- (void)hide;

@end
