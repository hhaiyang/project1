//
//  XJXReservationWizard.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXReservationWizard.h"

#import "XJXReservationRequirementController.h"

@interface XJXWizardClassing : NSObject

@property (nonatomic,assign) Class class;
@property (nonatomic,copy) NSString *identifier;

@end

@implementation XJXWizardClassing

@end

@interface XJXReservationWizard()

@property (nonatomic,assign) NSUInteger step;

@property (nonatomic,strong) NSMutableDictionary *state;

@property (nonatomic,strong) NSMutableArray *registeredClasses;

@property (nonatomic,weak) XJXBaseWizardController *currentViewController;

@end

@implementation XJXReservationWizard

- (instancetype)init{
    if(self = [super init]){
        self.state = [NSMutableDictionary dictionary];
        self.registeredClasses = [NSMutableArray array];
        self.step = 0;
    }
    return self;
}

- (void)regsiterWizardClass:(Class)wizardControllerClass identifier:(NSString *)identifier{
    if([wizardControllerClass isSubclassOfClass:[XJXBaseWizardController class]]){
        XJXWizardClassing *classing = [[XJXWizardClassing alloc] init];
        classing.class = wizardControllerClass;
        classing.identifier = identifier;
        [self.registeredClasses addObject:classing];
        
    }
    else{
        @throw [NSException exceptionWithName:@"WrongClassing" reason:@"Class不合法" userInfo:nil];
    }
}

- (void)showWizardWithCompletion:(onWizardDone)done{
    XJXWizardClassing *classing = self.registeredClasses[_step];
    _currentViewController = [classing.class showWithCompletion:^(XJXBaseWizardController *controller,id state,BOOL canceled){
        if(!canceled){
            [self.state setObject:state forKey:@(_step)];
            if(_step < _registeredClasses.count - 1){
                _step++;
                [self showWizardWithCompletion:done];
            }
            else{
                if(done){
                    done(self.state,NO);
                }
                [controller dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else{
            if(_step > 0){
                _step--;
                [controller.navigationController popViewControllerAnimated:YES];
            }
            else{
                if(done){
                    done(nil,YES);
                }
                [controller dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } state:self.state push:_step > 0];
}

@end
