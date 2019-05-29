//
//  FMUString.m
//  FMLibrary
//
//  Created by fangstar on 13-3-22.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMUString.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//暴雪MPQ HASH算法
#define HASH_MAX_LENGTH 2*1024	//最大字符串长度(字节)
typedef unsigned int DWORD;		//类型定义
static DWORD cryptTable[0x500];		//哈希表
static bool HASH_TABLE_INITED = false;
static void prepareCryptTable();
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex);

@implementation FMUString

#pragma mark - Base
+ (BOOL)isEmptyString:(NSString *)_str
{
    if ([_str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([_str isEqualToString:@""]) {
        return YES;
    }
    if (_str == nil) {
        return YES;
    }
    if (_str == NULL) {
        return YES;
    }
    if ((NSNull*)_str == [NSNull null]) {
        return YES;
    }
    return [self isEmptyStringBySpace:_str];
    return NO;
}

//全是空格
+ (BOOL)isEmptyStringBySpace:(NSString*)_str
{
    //全是空格不可完成提交
    if ([[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyStringFilterBlank:(NSString *)_str
{
    if ([self isEmptyString:_str]) {
        return YES;
    }
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

+(NSString*)bytesSizeText:(double)bytes
{
    NSString *ret = nil;
    double size = bytes;
    if (size > 1024*1024)
    {
        ret = [NSString stringWithFormat:@"%.1fMB", size / 1024.0 / 1024.0];
    }
    else if (size > 1024)
    {
        ret = [NSString stringWithFormat:@"%.0fKB", size / 1024.0];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%.0f字节", size];
    }
    
    return ret;
}

+ (NSInteger)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

+ (NSUInteger)theLenthOfStringFilterBlank:(NSString *)_str
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    return string.length;
}

+ (CGFloat)heightForText:(NSString*)text withTextWidth:(CGFloat)textWidth withFont:(UIFont*)aFont {
    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (CGFloat)widthForText:(NSString*)text withTextHeigh:(CGFloat)textHeigh withFont:(UIFont*)aFont
{
    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(MAXFLOAT, textHeigh) lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

+ (BOOL)inputView:(id)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSInteger)maxlength
{
    if (![inputView isKindOfClass:[UITextView class]] &&
        ![inputView isKindOfClass:[UITextField class]] &&
        ![inputView isKindOfClass:[UISearchBar class]]) {
        return NO;
    }
    
    if (range.length == 1 && text.length == 0) { //退格键
        return YES;
    }
    else {
        if (range.location < maxlength) {
            NSInteger re_length = maxlength - range.location;
            if (text.length > re_length) {
                NSRange liRange = NSMakeRange(0, re_length);
                NSString *liString = [text substringWithRange:liRange];
                
                if ([inputView isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)inputView;
                    textView.text = [textView.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UITextField class]])
                {
                    UITextField *textField = (UITextField *)inputView;
                    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UISearchBar class]])
                {
                    UISearchBar *searchBar = (UISearchBar *)inputView;
                    searchBar.text = [searchBar.text stringByReplacingCharactersInRange:range withString:liString];
                }
                
                return NO;
            }
            return YES;
        }
        return NO;
    }
}

+(void)sizeToFitWebView:(UIWebView*)webview
{
    //    webview.scalesPageToFit = NO;
    CGRect rect = webview.frame;
    rect.size.height = 1;
    webview.frame = rect;
    
    NSInteger content_height = [[webview stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] integerValue];
    
    rect.size.height = content_height;
    webview.frame = rect;
    //    webview.scalesPageToFit = YES;
}

//判断是否为数字
+ (BOOL)isNumberVaild:(NSString *)aString
{
    NSString *Regex = @"^[0-9]*$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}

//判断是否为浮点数
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isFloatVaild:(NSString *)aString
{
    NSString *Regex = @"^[0-9]+(.[0-9]{2})?$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}

+(BOOL)digitACharacterAuth:(NSString*)password min:(NSInteger)min max:(NSInteger)max
{
    //6-16位数字或者英文字母
    if (password.length < min || password.length >max) {
        return NO;
    }
    NSString *Regex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [pwdTest evaluateWithObject:password];
}

//判断字数，包含中英文
+(CGFloat)unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    float unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

#pragma mark - Time
//NSDate 2013-5-8 19:09 45 => yyyy-MM-dd
+ (NSString *)timeSinceDate:(NSDate *)date format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    return ret;
}

//1233444s => "YYYY/MM/dd(formatestr)"
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    return [self timeSinceDate:date format:formatestr];
}

//"YYYY/MM/dd(formatestr)" => 1233444s
+ (NSTimeInterval)secTimeInterValSice1970:(NSString *)string Format:(NSString *)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSDate *date = [formatter dateFromString:string];
    
    NSTimeInterval sec = [date timeIntervalSince1970];
    [formatter release];
    
    return sec;
}

//NSDate 2013-5-8 19:09 45 => ***前 或 yyyy-MM-dd
+ (NSString*)cusTimeSinceDate:(NSDate*)date format:(NSString*)formatestr
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
	if (real_seconds > 60*60*24)
	{
		ttext = real_seconds/60/60/24;
        if (ttext <= 2) {
            ret = [NSString stringWithFormat:@"%@天前", @(ttext)];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatestr];
            ret = [formatter stringFromDate:date];
            [formatter release];
        }
        
	}
	else if (real_seconds > 60*60)
	{
		ttext = real_seconds/60/60;
        ret = [NSString stringWithFormat:@"%@小时前", @(ttext)];
	}
	else
	{
		ttext = real_seconds/60;
        ret = [NSString stringWithFormat:@"%@分钟前", @(ttext)];
	}
    return ret;
}

//NSDate 2013-5-8 19:09 45 => ***前 或 yyyy-MM-dd hh:mm 为了适应新的时间规则增加的方法
/*
 //规则：当天：1分钟以内：刚刚
             1小时以内：xx分钟前
             超过1小时：hh:mm
        非当天：昨天、前天、日期
 */
+ (NSString*)cusTimeSinceDateNewRole:(NSDate*)date format:(NSString*)formatestr
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday2, *yesterday;
    
    yesterday2 = [today dateByAddingTimeInterval: -2*secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[yesterday2 description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    
    NSString * time = [formatter stringFromDate:date];
    
    
    if ([dateString isEqualToString:todayString])
    {
        if (real_seconds >= 60* 60)
        {
            if ([formatestr isEqualToString:@"yyyy-MM-dd HH:mm"]) {
                ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(11, 5)]];
            }
            else if([formatestr isEqualToString:@"yy-MM-dd HH:mm"])
            {
                ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(9, 5)]];
            }
        }
        else if (real_seconds > 60 &&
                 real_seconds < 60*60)
        {
            ttext = real_seconds/60;
            ret = [NSString stringWithFormat:@"%@分钟前", @(ttext)];
        }
        else if (real_seconds <=60 ) {
            ret = [NSString stringWithFormat:@"刚刚"];
        }
    } else if ([dateString isEqualToString:yesterdayString])
    {
        ret = [NSString stringWithFormat:@"%@",@"昨天"];

    }else if ([dateString isEqualToString:tomorrowString])
    {
        ret = [NSString stringWithFormat:@"%@",@"前天"];
    }
    else
    {
        if ([formatestr isEqualToString:@"yyyy-MM-dd HH:mm"]) {
            ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(0, 10)]];
        }
        else if([formatestr isEqualToString:@"yy-MM-dd HH:mm"])
        {
            ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(0, 8)]];
        }
        
    }
    [formatter release];
    return ret;
}
//为了适应新的时间规则增加的方法，淘房资讯使用
/*
 //规则：
 当天：1分钟以内：1分钟前
 1小时以内：xx分钟前，最小单位为1分钟，去秒留分
 超过1小时：xx小时前，最小单位为1小时，去分钟留小时
 非当天：
 超过24小时后，显示发布时期，展示“x月x日”
 超过365天后，显示“x年x月x日”
 */
+ (NSString*)timeSinceDateNewRole:(NSDate*)date
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if(real_seconds > 60*60*24*365)
    {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        ret = [formatter stringFromDate:date];
    }
    else if(real_seconds > 60*60*24)
    {
        [formatter setDateFormat:@"MM月dd日"];
        ret = [formatter stringFromDate:date];
    }
    else if (real_seconds >= 60* 60)
    {
        ttext = real_seconds/3600;
        ret = [NSString stringWithFormat:@"%@小时前",@(ttext)];
    }
    else if (real_seconds > 60 &&
             real_seconds < 60*60)
    {
        ttext = real_seconds/60;
        ret = [NSString stringWithFormat:@"%@分钟前", @(ttext)];
    }
    else if (real_seconds <=60 ) {
        ret = @"1分钟前";
    }
    
    [formatter release];
    return ret;
}

//"YYYY/MM/dd(formatestr)" => ***前 或 yyyy-MM-dd(formatestr)
+ (NSString*)cusTimeSinceDateString:(NSString*)datestr Format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatestr];
	NSDate *pub_dt = [formatter dateFromString:datestr];
	[formatter release];
    
    return [self cusTimeSinceDate:pub_dt format:formatestr];
}

#pragma mark - URL
//是否为url
+ (BOOL)isURL:(NSString*)url
{
    NSString *regex = @"(http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [urlPredicate evaluateWithObject:url];
    return result;
}

//拼接url
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

//解析url参数
+ (NSDictionary *)getParamsFromUrl:(NSString*)urlQuery
{
    NSArray *pairs = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:10];
    for (int i=0; i<pairs.count; i++)
    {
        NSString *pair = [pairs objectAtIndex:i];
        NSArray *tmp = [pair componentsSeparatedByString:@"="];
        if (tmp.count > 1)
        {
            [md setObject:[tmp objectAtIndex:1] forKey:[tmp objectAtIndex:0]];
        }
    }
    return md;
}

//解析url参数
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

#pragma mark - HTML
+ (NSString*)filterHtml:(NSString*)str
{
    if (!str) {
        return nil;
    }
    
    NSMutableString *ms = [NSMutableString stringWithCapacity:10];
    [ms setString:str];
    [ms replaceOccurrencesOfString:@"<p>" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"</p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br />" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br/>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"\t" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#8226;" withString:@"•" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#9832;" withString:@"♨" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&ldquo;" withString:@"“" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rdquo;" withString:@"”" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&mdash;" withString:@"—" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lsquo;" withString:@"‘" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rsquo;" withString:@"’" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&hellip;" withString:@"…" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&middot;" withString:@"·" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&uarr;" withString:@"↑" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&darr;" withString:@"↓" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&larr;" withString:@"←" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rarr;" withString:@"→" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];

    
    while ([ms hasPrefix:@"\r\n"])
    {
        [ms replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length>5?5:ms.length)];
    }
    
    while ([ms replaceOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    while ([ms replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    return ms;
}

//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html
{
	if (!html)
	{
		return nil;
	}
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    NSString *ret = [NSString stringWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        ret = [ret stringByReplacingOccurrencesOfString:
               [ NSString stringWithFormat:@"%@>", text]
                                             withString:@" "];
        
    } // while //
    
    return ret;
}

#pragma mark - Encode
+ (NSString*)encodedString:(NSString*)str
{
    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL, /* allocator */
                                                                                  (CFStringRef)str,
                                                                                  NULL, /* charactersToLeaveUnescaped */
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    return [escaped_value autorelease];
}

+ (NSString*)encodeBase64:(NSData*)input
{
    //NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
//    NSData *data = [GTMBase64 encodeData:input];
//    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return [base64String autorelease];
    return nil;
}

#pragma mark - Phone
+ (BOOL) isSupportCallPhoneWithDevice
{
    CTTelephonyNetworkInfo * networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if(networkInfo.currentRadioAccessTechnology)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    [networkInfo release];
}
+ (BOOL)isPhoneNumber:(NSString *)mobileNum {
    //电话号码，包括手机号，坐机号，400电话
    NSArray *nums = [mobileNum componentsSeparatedByString:@","];
    NSString *filterMobileNum = [nums objectAtIndex:0];
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    
    NSString * PHONE = @"^\\d{11}$";  //11位手机号
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * PHSS = @"^\\d{7,8}$";   //8位不带区号
    NSString * SERVICE = @"^\\d{5}$";  //5位客服
    
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHONE];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestphss = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHSS];
    NSPredicate *regextestser = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", SERVICE];
    
    if (([regextestPhone evaluateWithObject:filterMobileNum] == YES)
        || ([regextestmobile evaluateWithObject:filterMobileNum] == YES)
        || ([regextestcm evaluateWithObject:filterMobileNum] == YES)
        || ([regextestct evaluateWithObject:filterMobileNum] == YES)
        || ([regextestcu evaluateWithObject:filterMobileNum] == YES)
        || ([regextestphs evaluateWithObject:filterMobileNum] == YES)
        || ([regextestphss evaluateWithObject:filterMobileNum] == YES)
        || ([regextestser evaluateWithObject:filterMobileNum] == YES))
    {
        return YES;
    }
    //对14开头的号码，认为是合法的
    if ([[filterMobileNum substringToIndex:2]isEqualToString:@"14"]) {
        return YES;
    }
    //400电话认为是合法的
    if ([[filterMobileNum substringToIndex:3]isEqualToString:@"400"]) {
        return YES;
    }
    
    else
    {
        return NO;
    }
}
/**
 * 手机号码
 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 * 联通：130,131,132,152,155,156,185,186
 * 电信：133,1349,153,180,189
 */
+(BOOL)isMobileNumber:(NSString *)text
{
    //手机号码，11位
    NSString *Regex = @"^\\d{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:text];
    
//    NSString * MOBILE = @"^0{0,1}(13[0-9]|15[7-9]|153|156|18[7-9])[0-9]{8}$";
//        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//
//    if (([regextestmobile evaluateWithObject:text] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
}

+ (BOOL)telePhoneCall:(NSString*)telno withNoneAlert:(BOOL)key
{    
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];

    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"（" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"）" withString:@""];
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    
    if (phoneNum == nil || [phoneNum isEqualToString:@""]) {
        return NO;
    }
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    [[UIApplication sharedApplication] openURL:phoneURL];
    return YES;
}

+ (BOOL)telePhoneCall:(NSString*)telno
{
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"（" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"）" withString:@""];
    
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    
    if (phoneNum == nil || [phoneNum isEqualToString:@""]) {
        return NO;
    }
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:telURL];
    return YES;
}

+ (BOOL)telePhoneCallWithChecking:(NSString*)telno
{
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"（" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"）" withString:@""];
    
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    
    if(![self isPhoneNumber:phoneNum]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"电话号码不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:telURL];
    return YES;
}

//获取日
+ (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:[NSDate date]];
    return [dayComponents day];
}
//获取月
+ (NSUInteger)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
    return [dayComponents month];
}
//获取年
+ (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
    return [dayComponents year];
}
//获取小时
+ (NSUInteger )getHour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    return (int)hour;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}
#pragma mark - HASH
+ (NSString*)hashString:(NSString*)str
{
    return [NSString md5Str:str];
}

#pragma mark - 判断是否是字母，汉字，数字
+ (BOOL)isLetterAndChineseCharacterAndNumber:(NSString *)str
{
    BOOL isLetter = NO;
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:str])
    {
        isLetter = NO;
    }
    else
    {
        isLetter = YES;
    }
    return isLetter;
}

#pragma mark - 判断是否为1-9的数字
+ (BOOL)isSingleValidNumber:(NSString *)str{
    NSString *regex = @"^[1-9]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

#pragma mark - 判断是否是字母，数字
+ (BOOL)isLetterAndNumber:(NSString *)str
{
    NSString *regex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

+ (NSString*)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}

#pragma mark - 去除字符串前后空格
+ (NSString *)deleteBeforeAndAfterSpace:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

#pragma mark - //暴雪MPQ HASH算法
//生成哈希表
static void prepareCryptTable()
{
	DWORD dwHih, dwLow,seed = 0x00100001,index1 = 0,index2 = 0, i;
	for(index1 = 0; index1 < 0x100; index1++)
	{
		for(index2 = index1, i = 0; i < 5; i++, index2 += 0x100)
		{
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwHih= (seed & 0xFFFF) << 0x10;
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwLow= (seed & 0xFFFF);
			cryptTable[index2] = (dwHih| dwLow);
		}
	}
}

//生成HASH值
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex)
{
	if (!HASH_TABLE_INITED)
	{
		prepareCryptTable();
		HASH_TABLE_INITED = true;
	}
	unsigned char *key = (unsigned char *)lpszFileName;
	DWORD seed1 = 0x7FED7FED, seed2 = 0xEEEEEEEE;
	int ch;
	while(*key != 0)
	{
		ch = *key++;
		seed1 = cryptTable[(dwCryptIndex<< 8) + ch] ^ (seed1 + seed2);
		seed2 = ch + seed1 + seed2 + (seed2 << 5) + 3;
	}
	return seed1;
}
