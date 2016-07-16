//
//  TemplateContainer.h
//  XJX
//
//  Created by Cai8 on 16/1/27.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_SPACING 15

@protocol TemplateContainerDelegate <NSObject>

- (void)didTemplateOnTouched:(UIImageView *)imageView imageTemplate:(id)imageTemplate;

@end

@interface TemplateContainer : UIView

- (void)loadTemplate:(id)galleryTemplate;
- (CGFloat)getHeight;

@property (nonatomic,assign) id<TemplateContainerDelegate> delegate;

@end
