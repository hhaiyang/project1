//
//  XJXProductActionSheet.m
//  XJX
//
//  Created by Cai8 on 16/1/15.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXProductActionSheet.h"
#import "XJXNumberTicker.h"

@implementation XJXProductActionSheetHeader

- (UIView *)render{
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getWidth], [self getHeight])];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.padding.left, self.padding.top, 64, 64)];
    
    UIButton *closeButton = [UIControlsUtils buttonWithTitle:@"" background:nil backroundImage:[UIImage imageNamed:@"close"] target:self selector:@selector(close:) padding:UIEdgeInsetsZero frame:CGRectMake([self getWidth] - self.padding.left - 18, 0, 18, 18)];
    
    UILabel *titleLb = [UIControlsUtils labelWithTitle:_title color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont textAlignment:NSTextAlignmentLeft constrainSize:CGSizeMake([closeButton getMinX] - self.padding.left - self.padding.right - [imageView getMaxX], [imageView getH])];
    
    UILabel *priceLb = [UIControlsUtils labelWithPrice:_price font:[Theme defaultTheme].normalTextFont symbolFont:[Theme defaultTheme].subTitleFont];
    
    UILabel *infoLb = [UIControlsUtils labelWithTitle:@"请选择规格" color:[Theme defaultTheme].lightColor font:[Theme defaultTheme].subTitleFont];
    
    [titleLb setX:[imageView getMaxX] + 5];
    [titleLb setY:imageView.frame.origin.y + 5];
    
    [closeButton setY:[titleLb getMinY] + ([titleLb getH] - [closeButton getH]) / 2.0];
    
    [priceLb setX:[imageView getMaxX] + 5];
    [priceLb setY:[titleLb getMaxY] + 5];
    
    [infoLb setX:[imageView getMaxX] + 5];
    [infoLb setY:[imageView getMaxY] - 5 - infoLb.bounds.size.height];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, renderView.bounds.size.height, renderView.bounds.size.width, 1)];
    seperator.backgroundColor = WhiteColor(0, .15);
    
    [renderView addSubview:imageView];
    [renderView addSubview:titleLb];
    [renderView addSubview:priceLb];
    [renderView addSubview:infoLb];
    [renderView addSubview:seperator];
    [renderView addSubview:closeButton];
    
    [imageView lazyWithUrl:_image_url];
    
    return renderView;
}

- (void)close:(id)sender{
    if(_closeHandler){
        _closeHandler();
    }
}

- (CGFloat)getHeight{
    return 93;
}

@end

@implementation XJXProductActionSheetContent
{
    XJXNumberTicker *ticker;
}

- (instancetype)init{
    if(self = [super init]){
        _model = [[XJXProductActionSheetModels alloc] init];
        _model.padding = UIEdgeInsetsMake(10, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 10, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    }
    return self;
}

- (UIView *)render{
    CGFloat y_offset = self.padding.top;
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self getHeight])];
    renderView.backgroundColor = WhiteColor(.95, 1);
    
    UIView *modelView = [_model render];
    [modelView setY:y_offset];
    
    y_offset += modelView.bounds.size.height + 10;
    
    UILabel *countLb = [UIControlsUtils labelWithTitle:@"数量" color:[Theme defaultTheme].titleColor font:[Theme defaultTheme].titleFont];
    [countLb setX:[Theme defaultTheme].THEMING_EDGE_PADDING_HORI];
    [countLb setY:y_offset];
    
    y_offset += countLb.bounds.size.height + 5;
    ticker = [[XJXNumberTicker alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, y_offset, 100, 0)];
    ticker.value = self.amount;
    [renderView addSubview:modelView];
    [renderView addSubview:countLb];
    [renderView addSubview:ticker];
    [renderView setH:[ticker getMaxY] + self.padding.bottom];
    return renderView;
}

- (NSDictionary *)getSelectedModelAndAmount{
    id tags = [_model getSelectedModels];
    if(!tags){
        @throw [NSException exceptionWithName:@"Model Required" reason:@"请选择产品型号" userInfo:nil];
    }
    int amount = ticker.value;
    return @{
             @"tags" : tags,
             @"amount" : @(amount)
             };
}

- (CGFloat)getHeight{
    CGFloat height = self.padding.top;
    height += [_model getHeight];
    height += [@"数量" sizeWithFont:[Theme defaultTheme].titleFont].height + 5;
    height += 35;
    height += self.padding.bottom;
    return height;
}

@end

@implementation XJXProductActionSheetModels{
    XJXTagView *tagView;
}

- (UIView *)render{
    if(!tagView){
        NSMutableArray *groups = [NSMutableArray array];
        [_models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [groups indexOfObjectPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                return [[_obj group_title] isEqualToString:obj[@"model_attr"]];
            }];
            if(index != NSNotFound){
                XJXTag *tag = [[XJXTag alloc] init];
                tag.title = obj[@"model_value"];
                [(XJXTagGroup *)groups[index] addTag:tag];
            }
            else{
                XJXTagGroup *group = [[XJXTagGroup alloc] init];
                group.group_title = obj[@"model_attr"];
                XJXTag *tag = [[XJXTag alloc] init];
                tag.title = obj[@"model_value"];
                [group addTag:tag];
                [groups addObject:group];
            }
        }];
        
        tagView = [[XJXTagView alloc] initWithTagGroups:groups selectedTags:self.selectedModel padding:UIEdgeInsetsMake(10, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 10, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI)];
    }
    return tagView;
}

- (NSArray *)getSelectedModels{
    NSArray *selectModel = [tagView getSelectedTags];
    if(selectModel != nil){
        NSMutableArray *model = [NSMutableArray array];
        [selectModel enumerateObjectsUsingBlock:^(XJXTag *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [_models indexOfObjectPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                return [obj.title isEqualToString:_obj[@"model_value"]];
            }];
            if(index != NSNotFound){
                [model addObject:_models[index]];
            }
            else{
                @throw [NSException exceptionWithName:@"Unknown Error" reason:@"未知错误" userInfo:nil];
            }
        }];
        return model;
    }
    else{
        return nil;
    }
}

- (CGFloat)getHeight{
    NSMutableArray *groups = [NSMutableArray array];
    [_models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [groups indexOfObjectPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
            return [[_obj group_title] isEqualToString:obj[@"model_attr"]];
        }];
        if(index != NSNotFound){
            XJXTag *tag = [[XJXTag alloc] init];
            tag.title = obj[@"model_value"];
            [(XJXTagGroup *)groups[index] addTag:tag];
        }
        else{
            XJXTagGroup *group = [[XJXTagGroup alloc] init];
            group.group_title = obj[@"model_attr"];
            XJXTag *tag = [[XJXTag alloc] init];
            tag.title = obj[@"model_value"];
            [group addTag:tag];
            [groups addObject:group];
        }
    }];
    return [XJXTagView sizeForTagGroups:groups padding:self.padding].height + self.padding.top + self.padding.bottom;
}

@end

@implementation XJXProductActionSheetFooter

- (UIView *)render{
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [self getWidth], [self getHeight])];
    renderView.backgroundColor = WhiteColor(1, 1);
    UIButton *btnOk = [UIControlsUtils buttonWithTitle:@"确定" background:[[Theme defaultTheme].highlightTextColor colorWithAlphaComponent:.8] backroundImage:nil target:self selector:@selector(ok) padding:UIEdgeInsetsMake(15, 55, 15, 55) frame:CGRectZero];
    [btnOk setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
    [btnOk horizontalCenteredOnView:renderView];
    [btnOk verticalCenteredOnView:renderView];
    btnOk.layer.cornerRadius = 0.5 * btnOk.bounds.size.height;
    [renderView addSubview:btnOk];
    return renderView;
}

- (void)ok{
    if(_okHandler){
        _okHandler();
    }
}

- (CGFloat)getHeight{
    return 50;
}

@end

@implementation XJXProductActionSheet

- (instancetype)init{
    if(self = [super init]){
        WS(_self);
        
        _header = [[XJXProductActionSheetHeader alloc] init];
        _content = [[XJXProductActionSheetContent alloc] init];
        _footer = [[XJXProductActionSheetFooter alloc] init];
        
        _header.closeHandler = ^(){
            [_self close];
        };
    }
    return self;
}

- (UIView *)render{
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getWidth], [self getHeight])];
    renderView.backgroundColor = WhiteColor(1, 1);
    [_header renderOnPoint:CGPointMake(self.padding.left, self.padding.top) onView:renderView];
    [_content renderOnPoint:CGPointMake(self.padding.left, [_header getHeight] + self.padding.top) onView:renderView];
    [_footer renderOnPoint:CGPointMake(self.padding.left, [_header getHeight] + [_content getHeight]) onView:renderView];
    return renderView;
}

- (CGFloat)getHeight{
    return [_header getHeight] + [_content getHeight] + [_footer getHeight] + self.padding.top + self.padding.bottom;
}

- (BOOL)valueChanged{
    id result = [self.content getSelectedModelAndAmount];
    if(self.content.amount != [result[@"amount"] intValue]){
        return YES;
    }
    else{
        __block BOOL bl = YES;
        [self.content.model.selectedModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *attr = obj[@"model_attr"];
            NSUInteger index = [result[@"tags"] indexOfObjectPassingTest:^BOOL(id  _Nonnull _obj, NSUInteger _idx, BOOL * _Nonnull _stop) {
                return [_obj[@"model_attr"] isEqualToString:attr];
            }];
            if(index != NSNotFound){
                bl = ![obj[@"model_value"] isEqualToString:result[@"tags"][index][@"model_value"]];
            }
            else{
                bl = NO;
            }
            *stop = bl;
        }];
        return bl;
    }
}

- (void)close{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@([self.containerView getMinY])];
    anim.toValue = @[@(SCREEN_HEIGHT)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
    };
    [anim setCompletionBlock:^(POPAnimation *ani, BOOL finished) {
        if(finished){
            [self.containerView.superview removeFromSuperview];
            self.containerView = nil;
        }
    }];
    [self.containerView pop_addAnimation:anim forKey:kPOPViewFrame];
}

+ (XJXProductActionSheet *)showWithModels:(NSArray *)models title:(NSString *)title price:(CGFloat)price imageUrl:(NSString *)image_url identifier:(NSString *)identifier selectedModel:(NSArray *)model amount:(int)amount onSheetDone:(onActionSheetDone)done{
    XJXProductActionSheet *sheet = [[XJXProductActionSheet alloc] init];
    sheet.identifier = identifier;
    sheet.header.padding = UIEdgeInsetsMake([Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    sheet.header.title = title;
    sheet.header.image_url = image_url;
    sheet.header.price = price;
    sheet.content.padding = UIEdgeInsetsMake(5, 0, 15, 0);
    sheet.content.model.models = models;
    sheet.content.model.selectedModel = model;
    sheet.content.amount = amount;
    sheet.footer.okHandler = done;
    UIView *containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containerView.backgroundColor = WhiteColor(0, .4);
    UIView *renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [sheet getHeight])];
    [sheet renderOnPoint:CGPointMake(0, 0) onView:renderView];
    [renderView setY:SCREEN_HEIGHT];
    [containerView addSubview:renderView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:containerView];
    
    sheet.containerView = renderView;
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 1;
    anim.fromValue = @[@(SCREEN_HEIGHT)];
    anim.toValue = @[@(SCREEN_HEIGHT - renderView.bounds.size.height)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
    };
    [renderView pop_addAnimation:anim forKey:kPOPViewFrame];
    return sheet;
}

@end
