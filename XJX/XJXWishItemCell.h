//
//  XJXWishItemCell.h
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJXWishItemCell : UICollectionViewCell

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) int amount;
@property (nonatomic,assign) BOOL editing;

@property (nonatomic,strong) CheckEditor *editor;

- (void)loadImageFromURL:(NSString *)url;

@end
