//
//  XJXReservationWizard.h
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onWizardDone)(id state,BOOL canceled);

@interface XJXReservationWizard : NSObject

- (void)regsiterWizardClass:(Class)wizardControllerClass identifier:(NSString *)identifier;

- (void)showWizardWithCompletion:(onWizardDone)done;

@end
