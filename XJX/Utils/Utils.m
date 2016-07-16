//
//  Utils.m
//  Help
//
//  Created by qimeng13 on 14-4-20.
//  Copyright (c) 2014年 OPush. All rights reserved.
//

#import "Utils.h"
#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer *player;

@implementation Utils

+ (NSString *)readableTime:(NSDate *)date{
    return @"";
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

+ (NSString *)pathWithDirectoryName:(NSString *)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:directoryName];
    return cacheDirectoryName;
}

+ (NSString *)filePathWithDirectoryName:(NSString *)directoryName filename:(NSString *)filename
{
    return [[self pathWithDirectoryName:directoryName] stringByAppendingPathComponent:filename];
}

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *df = [Utils sharedDateFormatter];
    df.dateFormat = formatter;
    return [df stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string formatter:(NSString *)formatter
{
    NSDateFormatter *df = [Utils sharedDateFormatter];
    df.dateFormat = formatter;
    return [df dateFromString:string];
}

+ (void)callPhone:(NSString *)phone
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

+ (UIImage *)getImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

+ (NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

+ (unsigned int)intFromHexString:(NSString *) hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

+ (NSData *)bytesFromHex:(NSString *)hexStr_
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexStr_.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexStr_ substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (void)comfirmWithPromt:(NSString *)promt title:(NSString *)title comfirm:(void (^)())comfirmed{
    SCLAlertView *vc = [[SCLAlertView alloc] init];
    vc.tintTopCircle = YES;
    vc.customViewColor = [Theme defaultTheme].highlightTextColor;
    vc.backgroundViewColor = WhiteColor(1, 1);
    vc.backgroundType = Blur;
    vc.showAnimationType = SlideInFromTop;
    vc.showAnimationType = SlideOutToBottom;
    vc.cornerRadius = 5;
    [vc addButton:@"确认" actionBlock:^{
        if(comfirmed){
            comfirmed();
        }
    }];
    [vc showQuestion:[XJXLinkageRouter defaultRouter].activityController title:title subTitle:promt closeButtonTitle:@"取消" duration:0.0];
}

+ (void)showAlert:(NSString *)alert title:(NSString *)title
{
    SCLAlertView *vc = [[SCLAlertView alloc] init];
    vc.tintTopCircle = YES;
    vc.customViewColor = [Theme defaultTheme].highlightTextColor;
    vc.showAnimationType = SlideInFromTop;
    vc.showAnimationType = SlideOutToBottom;
    vc.backgroundType = Blur;
    vc.cornerRadius = 5;
    if([title isEqualToString:@"信息"]){
         [vc showInfo:[XJXLinkageRouter defaultRouter].activityController title:title subTitle:alert closeButtonTitle:@"确定" duration:0.0];
    }
    else if([title isEqualToString:@"警告"]){
         [vc showNotice:[XJXLinkageRouter defaultRouter].activityController title:title subTitle:alert closeButtonTitle:@"确定" duration:0.0];
    }
}

//获取当前屏幕显示的viewcontroller
// 获取当前处于activity状态的view controller

+ (void)printFrame:(CGRect)frame{
    NSLog(@"(%lf,%lf,%lf,%lf)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}



@end
