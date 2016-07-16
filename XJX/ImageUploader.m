//
//  ImageUploader.m
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ImageUploader.h"

@implementation ImageUploader

+ (void)pickImageWithScaledSize:(CGSize)size completion:(onImageUploaded)handler onPickerDismissed:(void (^)())controllerDismissedHandler{
    [self pickImageWithScaledSize:size customText:@"从相册选择图片" completion:handler onPickerDismissed:controllerDismissedHandler];
}

+ (void)pickImageWithScaledSize:(CGSize)size customText:(NSString *)text completion:(onImageUploaded)handler onPickerDismissed:(void (^)())controllerDismissedHandler{
    RMAction *imagePickerAction = [RMAction actionWithTitle:text style:RMActionStyleDone andHandler:^(RMActionController * _Nonnull controller) {
        TWPhotoPickerController *vc = [[TWPhotoPickerController alloc] init];
        vc.cropBlock = ^(UIImage *image){
            UIImage *scaledImage = [image resizedImageToFitInSize:size];
            @autoreleasepool {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSString *base64Image = [UIImageJPEGRepresentation(scaledImage, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [FileAPI uploadBase64Image:base64Image completion:^(id res, NSString *err) {
                            handler(res,err);
                        }];
                    });
                });
            }
            
        };
        [[XJXLinkageRouter defaultRouter].activityController presentViewController:vc animated:YES completion:nil];
    }];
    RMAction *cancelPickerAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleDestructive andHandler:^(RMActionController * _Nonnull controller) {
        NSLog(@"canceled");
    }];
    
    RMActionController *vc = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite title:@"照片选择" message:@"选择最满意的照片来定制您的喜讯吧" selectAction:imagePickerAction andCancelAction:cancelPickerAction];
    vc.onControllerDisappearHandler = ^(){
        if(controllerDismissedHandler){
            controllerDismissedHandler();
        }
    };
    
    vc.disableBlurEffects = NO;
    vc.disableBouncingEffects = NO;
    vc.disableMotionEffects = NO;
    
    [[XJXLinkageRouter defaultRouter].activityController presentViewController:vc animated:YES completion:nil];
}

@end
