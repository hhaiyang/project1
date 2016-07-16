//
//  XJXReservationTemplateCell.h
//  XJX
//
//  Created by Cai8 on 16/1/26.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseCell.h"
#import "TemplateContainer.h"

@interface XJXReservationTemplateCell : XJXBaseCell

@property (nonatomic,assign) BOOL isHeaderOnTop;

@property (nonatomic,strong) id galleryTemplate;

@property TemplateContainer *container;

+ (CGFloat)heightForTemplate:(id)galleryTemplate;

@end
