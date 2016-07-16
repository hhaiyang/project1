//
//  Theme.m
//  IShangMai
//
//  Created by Roy on 15/11/4.
//  Copyright © 2015年 Royge. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (instancetype)defaultTheme{
    static Theme *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [Theme new];
    });
    return instance;
}

- (UIFont *)lantingFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:size];
}

- (UIFont *)lightLantingFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FZLanTingHeiS-UL-GB" size:size];
}

- (UIFont *)boldLantingFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"FZLanTingHei-M-GBK" size:size];
}

- (instancetype)init{
    if(self = [super init]){
        self.THEMING_EDGE_PADDING_HORI = 15;
        self.THEMING_EDGE_PADDING_VETI = 10;
        
        self.THEMING_EDGE_PADDING_HORI_IN_GRID = 5;
        self.THEMING_EDGE_PADDING_VETI_IN_GRID = 5;
        
        self.schemeColor = hex(@"#855b68");
        self.textColor = hex(@"#9a878d");
        self.titleColor = hex(@"#9a878d");
        self.subTitleColor = hex(@"#d695a6");
        self.lightColor = hex(@"#c9bbbf");
        self.highlightTextColor = hex(@"#c27d92");
        
        self.naviTitleColor = hex(@"#744352");
        self.naviButtonColor = [hex(@"#744352") colorWithAlphaComponent:.6];
        
        self.sectionTitleColor = hex(@"#855b68");
        self.sectionSubTitleColor = hex(@"#9a878d");
        
        self.h1Font = [self lantingFontWithSize:30];
        self.h2Font = [self lantingFontWithSize:20];
        self.h3Font = [self lantingFontWithSize:16];
        self.h4Font = [self lantingFontWithSize:14];
        self.normalTextFont = [self lantingFontWithSize:12];
        self.titleFont = [self boldLantingFontWithSize:14];
        self.subTitleFont = [self lantingFontWithSize:12];
        self.emFont = [self lantingFontWithSize:10];
        
        self.sectionTitleFont = [UIFont boldSystemFontOfSize:18];
        self.sectionSubTitleFont = [UIFont italicSystemFontOfSize:10];
        
        self.invitationFieldColor = WhiteColor(1, .5);
//        self.invitationFieldBigFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
//        self.invitationFieldFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
//        self.invitationAndFont = [UIFont fontWithName:@"HelveticaNeue" size:26];
        self.invitationFieldBigFont = [self lantingFontWithSize:22];
        self.invitationFieldFont = [self boldLantingFontWithSize:18];
        self.invitationAndFont = [self lantingFontWithSize:26];
    }
    return self;
}

@end
