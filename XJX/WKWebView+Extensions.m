

#import "WKWebView+Extensions.h"
#import <objc/runtime.h>

static char IMG_ARR_KEY;

@implementation WKWebView (Extensions)

- (void)setMethod:(NSArray *)imgUrlArray
{
    objc_setAssociatedObject(self, &IMG_ARR_KEY, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &IMG_ARR_KEY);
}

-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView
{
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    [self evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js___Result==%@",Result);
        
        NSLog(@"js___Error -> %@", error);
        
    }];
    
    
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    [self evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSLog(@"js2__Result==%@",Result);
        NSLog(@"js2__Error -> %@", error);
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        NSLog(@"result===%@",resurlt);
        array=[resurlt componentsSeparatedByString:@"#"];
        NSLog(@"array====%@",array);
        [self setMethod:array];
    }];
    
    return array;
}

-(BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        NSUInteger index = [imgUrlArr indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj isEqualToString:imageUrl];
        }];
        if(index != NSNotFound){
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:imgUrlArr animatedFromView:self];
            [browser setInitialPageIndex:index];
            [[XJXLinkageRouter defaultRouter].activityController presentViewController:browser animated:YES completion:nil];
        }
        else{
            return NO;
        }
    }
    return YES;
}

@end
