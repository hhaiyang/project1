//
//  XJXCrowdFundingCell.h
//  XJX
//
//  Created by Cai8 on 16/2/21.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"

@class XJXCrowdFundingCell;
@protocol XJXCrowdFundingCellDelegate <NSObject>

- (void)didCollapseStatusChange:(XJXCrowdFundingCell *)cell;

- (void)didTerminateCFPressed:(XJXCrowdFundingCell *)cell;

@end

@interface XJXCrowdFundingCell : XJXBaseCell

@property (nonatomic,assign) BOOL collapse;

@property (nonatomic,strong) NSArray *funders;

@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) CGFloat fundedMoney;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) BOOL isCustom;

@property (nonatomic,assign) id<XJXCrowdFundingCellDelegate> delegate;

+ (CGFloat)heightOfFundingCellWithCollapse:(BOOL)collapse fcounts:(NSUInteger)fcounts;

@end
