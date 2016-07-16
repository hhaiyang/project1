//
//  XJXProductCell.h
//  XJX
//
//  Created by Cai8 on 16/1/14.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXProductCell : UICollectionViewCell

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,assign) CGFloat price;

- (void)loadImageFromURL:(NSString *)url;

@end
