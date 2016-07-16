//
//  XJXBaseWizardController.h
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "BaseController.h"

@class XJXBaseWizardController;

typedef void (^onWizardStepDone)(XJXBaseWizardController *controller,id state,BOOL canceled);

@interface XJXBaseWizardController : BaseController

@property (nonatomic,copy) onWizardStepDone stepDoneHandler;

@property (nonatomic,strong) id state;

+ (XJXBaseWizardController *)showWithCompletion:(onWizardStepDone)stepDoneHandler state:(NSDictionary *)state push:(BOOL)push;

@end
