//
//  XJXSlider.m
//  XJX
//
//  Created by Cai8 on 16/1/6.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXSlider.h"
#import "iCarousel/iCarousel.h"
#import "XJXPageControl.h"

@interface XJXSlider()<iCarouselDataSource,iCarouselDelegate>

@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,strong) XJXPageControl *pageControl;

@property (nonatomic,assign) NSInteger selectingSlideIndex;

@end

@implementation XJXSlider

+ (XJXSlider *)sliderWithData:(NSArray *)data frame:(CGRect)frame spacing:(CGFloat)spacing onViewCreated:(onViewCreated)onViewCreateHandler onViewReused:(onViewReused)onViewReusedHandler onViewTouched:(onViewTouched)onViewTouchedHandler{
    XJXSlider *slider = [[XJXSlider alloc] initWithFrame:frame];
    slider.viewCreatedHandler = onViewCreateHandler;
    slider.viewReusedHandler = onViewReusedHandler;
    slider.viewTouchedHandler = onViewTouchedHandler;
    slider.itemSpacing = spacing;
    [slider reloadWithData:data];
    return slider;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        [self initUI];
    }
    return self;
}

- (void)initParams{
    _data = [NSMutableArray array];
    _enablePageIndicator = NO;
    
    _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
    _carousel.type = iCarouselTypeLinear;
    _carousel.scrollSpeed = 0.5;
    _carousel.scrollToItemBoundary = YES;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.bounceDistance = .2f;
}

- (void)setPageEnable:(BOOL)pageEnable{
    _carousel.pagingEnabled = pageEnable;
}

- (void)selectSlideOnIndex:(NSUInteger)index{
    [_carousel scrollToItemAtIndex:index animated:NO];
}

- (XJXSlide *)selectingSlide{
    if(_selectingSlideIndex != -1){
        return (XJXSlide *)[_carousel itemViewAtIndex:_selectingSlideIndex];
    }
    else
        return nil;
}

- (void)setEnablePageIndicator:(BOOL)enablePageIndicator{
    _enablePageIndicator = enablePageIndicator;
    if(_enablePageIndicator){
        if(!_pageControl){
            _pageControl = [[XJXPageControl alloc] initWithPageCount:_data.count];
            [_pageControl setY:self.bounds.size.height - _pageControl.bounds.size.height - 10];
            [_pageControl setX:(self.bounds.size.width - _pageControl.bounds.size.width) / 2];
            [self addSubview:_pageControl];
        }
        else{
            [_pageControl setCount:_data.count];
        }
    }
    else{
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
}

- (void)initUI{
    [self addSubview:_carousel];
}

-(void)reloadWithData:(NSArray *)data{
    _data = [data mutableCopy];
    [_carousel reloadData];
}

- (void)appendData:(NSArray *)data{
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        [_data addObject:obj];
        [_carousel insertItemAtIndex:_data.count animated:YES];
    }];
}

#pragma mark - carousel delegate & datasource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _data.count;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1];
    BOOL _vertical = _carousel.vertical;
    CGFloat _itemWidth = _carousel.itemWidth;
    if (_vertical)
    {
        return CATransform3DTranslate(transform, 0.0, offset * _itemWidth * spacing, 0.0);
    }
    else
    {
        return CATransform3DTranslate(transform, offset * _itemWidth * spacing, 0.0, 0.0);
    }
    return transform;
}

- (XJXSlide *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(XJXSlide *)view{
    if(!view){
        if(_viewCreatedHandler){
            view = _viewCreatedHandler(index,_data[index]);
        }
        else{
            @throw [NSException exceptionWithName:@"No Handler Exception" reason:@"没有设置回调" userInfo:nil];
        }
    }
    if(_viewReusedHandler){
        _viewReusedHandler(view,index,_data[index]);
    }
    else{
        @throw [NSException exceptionWithName:@"No Handler Exception" reason:@"没有设置回调" userInfo:nil];
    }
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if(_viewTouchedHandler){
        _selectingSlideIndex = index;
        _viewTouchedHandler(index,_data[index]);
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if(_pageControl){
        [_pageControl setCurrentIndex:carousel.currentItemIndex];
    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if(option == iCarouselOptionSpacing){
        return value * (1 + _itemSpacing / self.bounds.size.width);
    }
    return value;
}

@end
