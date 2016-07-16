//
//  Theme.h
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECTION_TITLE_PADDING_VETI 5
#define SECTION_TITLE_PADDING 5

#define XJX_TOOLBAR_HEIGHT 50

#define NAVBAR_ICON_SIZE 24
#define LIST_ICON_SIZE 24

@interface Theme : NSObject

@property (nonatomic,assign) int THEMING_EDGE_PADDING_HORI;
@property (nonatomic,assign) int THEMING_EDGE_PADDING_VETI;

@property (nonatomic,assign) int THEMING_EDGE_PADDING_HORI_IN_GRID;
@property (nonatomic,assign) int THEMING_EDGE_PADDING_VETI_IN_GRID;

@property (nonatomic,strong) UIColor *schemeColor;

@property (nonatomic,strong) UIColor *sectionTitleColor;
@property (nonatomic,strong) UIColor *sectionSubTitleColor;

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *subTitleColor;
@property (nonatomic,strong) UIColor *highlightTextColor;
@property (nonatomic,strong) UIColor *lightColor;
@property (nonatomic,strong) UIColor *naviButtonColor;
@property (nonatomic,strong) UIColor *naviTitleColor;

@property (nonatomic,strong) UIColor *invitationFieldColor;

@property (nonatomic,strong) UIFont *h1Font;
@property (nonatomic,strong) UIFont *h2Font;
@property (nonatomic,strong) UIFont *h3Font;
@property (nonatomic,strong) UIFont *h4Font;
@property (nonatomic,strong) UIFont *normalTextFont;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *subTitleFont;
@property (nonatomic,strong) UIFont *emFont;

@property (nonatomic,strong) UIFont *invitationFieldBigFont;
@property (nonatomic,strong) UIFont *invitationFieldFont;
@property (nonatomic,strong) UIFont *invitationAndFont;

@property (nonatomic,strong) UIFont *sectionTitleFont;
@property (nonatomic,strong) UIFont *sectionSubTitleFont;

@property (nonatomic,copy) NSString *backgroundImagePathUrl;

+ (instancetype)defaultTheme;

@end
