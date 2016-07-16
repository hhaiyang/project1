//
//  XJXLoginController.m
//  XJX
//
//  Created by Cai8 on 16/1/24.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXLoginController.h"
#import "XJXSlider.h"

@interface XJXLoginController ()

@property (nonatomic,strong) XJXSlider *slider;

@property (nonatomic,strong) NSMutableArray *slides;

@end

@implementation XJXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParams{
    self.slides = [NSMutableArray array];
    for(int i = 1;i <= 4;i++){
        [self.slides addObject:[NSString stringWithFormat:@"0%d",i]];
    }
}

- (void)initUI{
    self.slider = [XJXSlider sliderWithData:self.slides frame:self.bounds spacing:0 onViewCreated:^XJXSlide *(NSUInteger index, id item) {
        XJXSlide *slide = [[XJXSlide alloc] initWithFrame:self.bounds];
        return slide;
    } onViewReused:^(XJXSlide *slide, NSUInteger index, id item) {
        UIImage *image = [UIImage imageWithFile:item type:@"png"];
        slide.coverView.image = image;
        if(index == 3){
            UIButton *btn = [UIControlsUtils buttonWithTitle:@"微信登陆" background:[Theme defaultTheme].highlightTextColor backroundImage:nil target:self selector:@selector(login:) padding:UIEdgeInsetsZero frame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2,0.7 * [self.view getH],[self.view getW] - 2 * [Theme defaultTheme].THEMING_EDGE_PADDING_HORI * 2,50)];
            [btn setTitleColor:WhiteColor(1, 1) forState:UIControlStateNormal];
            [btn setTitle:@"微信登陆" forState:UIControlStateNormal];
            [btn setBackgroundColor:[Theme defaultTheme].highlightTextColor];
            [btn setTag:999];
            btn.layer.cornerRadius = 0.5 * [btn getH];
            [slide addSubview:btn];
        }
        else{
            [[slide viewWithTag:999] removeFromSuperview];
        }
    } onViewTouched:^(NSUInteger index, id item) {
        
    }];
    self.slider.pageEnable = YES;
    [self addSubview:self.slider];
}

- (void)login:(id)sender{
    [[Session current] loginWithCompletionHandler:^(NSString *err) {
        if(_onLoginSuccessHandler){
            _onLoginSuccessHandler(err ? NO : YES);
        }
    }];
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
