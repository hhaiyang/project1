//
//  XJXCartSection.h
//  XJX
//
//  Created by Cai8 on 16/1/18.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXCartSection : NSObject

@property (nonatomic,copy) NSString *platform_logo_url;
@property (nonatomic,copy) NSString *platform;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *itemSelections;

@end
