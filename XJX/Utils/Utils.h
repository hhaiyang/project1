//
//  Utils.h
//  Help
//
//  Created by qimeng13 on 14-4-20.
//  Copyright (c) 2014年 OPush. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SIAlertView;

static UIAlertController *_alertView = nil;
@interface Utils : NSObject

+ (NSDateFormatter *)sharedDateFormatter;

+ (NSString *)pathWithDirectoryName:(NSString *)directoryName;

+ (NSString *)filePathWithDirectoryName:(NSString *)directoryName filename:(NSString *)filename;

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

+ (NSDate *)dateFromString:(NSString *)string formatter:(NSString *)formatter;

+ (NSString *)encodeSpecialCharactersInJsonStr:(NSString *)json;

+ (NSString *)decodeSpecialCharactersInJsonStr:(NSString *)json;

+ (NSString *)readableTime:(NSDate *)date;

+ (void)callPhone:(NSString *)phone;

+ (void)loadImageFromFile:(NSString *)file toImageView:(UIImageView *)view resize:(CGSize)size;

+ (UIImage *)getImageFromColor:(UIColor *)color;

+ (UIViewController *)getCurrentVC;

+ (void)presentViewController:(id)viewcontroller animated:(BOOL)animated completion:(void (^)())handler;

+ (void)pushController:(id)viewController;

+ (NSString *)ToHex:(long long int)tmpid;

+ (unsigned int)intFromHexString:(NSString *) hexStr;

+ (NSData *)bytesFromHex:(NSString *)hexStr;

+ (void)showAlert:(NSString *)alert title:(NSString *)title;

+ (void)printFrame:(CGRect)frame;

+ (void)comfirmWithPromt:(NSString *)promt title:(NSString *)title comfirm:(void (^)())comfirmed;

@end
