//
//  ImageUploader.h
//  XJX
//
//  Created by Cai8 on 16/1/28.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onImageUploaded)(NSArray *entities,NSString *err);

@interface ImageUploader : NSObject

+ (void)pickImageWithScaledSize:(CGSize)size completion:(onImageUploaded)handler onPickerDismissed:(void (^)())controllerDismissedHandler;

+ (void)pickImageWithScaledSize:(CGSize)size customText:(NSString *)text completion:(onImageUploaded)handler onPickerDismissed:(void (^)())controllerDismissedHandler;

@end
