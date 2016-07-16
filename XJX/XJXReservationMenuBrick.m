//
//  XJXReservationMenuBrick.m
//  XJX
//
//  Created by Cai8 on 16/3/30.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationMenuBrick.h"

@implementation XJXReservationMenuBrick

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, self.width, self.height)];
    renderView.layer.cornerRadius = self.borderRadius;
    renderView.layer.masksToBounds = YES;
    renderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:renderView.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.layer.masksToBounds = YES;
    [renderView addSubview:bg];
    
    bg.image = self.backgroundImage;
    
    CGSize imageSize = self.titleImage.size;
    CGSize scaleSize = CGSizeMake(imageSize.width * 30 / imageSize.height, 30);
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - [Theme defaultTheme].THEMING_EDGE_PADDING_HORI - scaleSize.width, 0, scaleSize.width, scaleSize.height)];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.layer.masksToBounds = YES;
    titleImageView.image = self.titleImage;
    
    [titleImageView verticalCenteredOnView:renderView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [renderView addGestureRecognizer:tap];
    
    [renderView addSubview:titleImageView];
    
    [view addSubview:renderView];
}

- (void)onTap:(UITapGestureRecognizer *)tap{
    if(self.touchedHandler){
        self.touchedHandler(self);
    }
}

@end
