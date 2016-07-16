//
//  XJXBaseWizardController.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXBaseWizardController.h"

@interface XJXBaseWizardController ()

@end

@implementation XJXBaseWizardController

+ (XJXBaseWizardController *)showWithCompletion:(onWizardStepDone)stepDoneHandler state:(NSDictionary *)state push:(BOOL)push{
    XJXBaseWizardController *vc = [[[self class] alloc] initWithExternalParams:state];
    vc.stepDoneHandler = stepDoneHandler;
    if(push){
        [[XJXLinkageRouter defaultRouter].activityController pushController:vc];
    }
    else{
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        navi.navigationBarHidden = YES;
        [[XJXLinkageRouter defaultRouter].activityController presentViewController:navi animated:YES completion:nil];
    }
    return vc;
}

- (void)back:(id)sender{
    if(self.stepDoneHandler){
        self.stepDoneHandler(self,nil,YES);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
