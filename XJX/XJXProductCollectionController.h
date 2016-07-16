//
//  XJXProductCollectionController.h
//  XJX
//
//  Created by Cai8 on 16/1/14.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

typedef void (^onDataRecved)(id data,NSString *err);

typedef void (^loadData)(int page,int pageSize,onDataRecved recvHandler);
typedef void (^onGridClicked)(id item);

@interface XJXProductCollectionController : BaseController
{
    NSMutableArray *data;
    int page;
    int pageSize;
    BOOL noMoreData;
}


@end
