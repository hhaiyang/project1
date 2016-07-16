//
//  XJXSlider.h
//  XJX
//
//  Created by Cai8 on 16/1/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJXSlide.h"

typedef XJXSlide *(^onViewCreated)(NSUInteger index,id item);
typedef void (^onViewReused)(XJXSlide *slide,NSUInteger index,id item);
typedef void (^onViewTouched)(NSUInteger index,id item);

@interface XJXSlider : UIView

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,copy) onViewCreated viewCreatedHandler;
@property (nonatomic,copy) onViewReused viewReusedHandler;
@property (nonatomic,copy) onViewTouched viewTouchedHandler;
@property (nonatomic,assign) CGFloat itemSpacing;

@property (nonatomic,assign) BOOL pageEnable;

@property (nonatomic,assign) BOOL enablePageIndicator;

+ (XJXSlider *)sliderWithData:(NSArray *)data frame:(CGRect)frame spacing:(CGFloat)spacing onViewCreated:(onViewCreated)onViewCreateHandler onViewReused:(onViewReused)onViewReusedHandler onViewTouched:(onViewTouched)onViewTouchedHandler;

- (void)reloadWithData:(NSArray *)data;
- (void)appendData:(NSArray *)data;

- (void)selectSlideOnIndex:(NSUInteger)index;

- (XJXSlide *)selectingSlide;

@end
