//
//  FMUTestData.m
//  FMLibrary
//
//  Created by fangstar on 13-4-17.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMUTestData.h"

@implementation FMUTestData

+(NSString*)thumbImageUrl
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"http://ww4.sinaimg.cn/bmiddle/aaee62ectw1duvh0ipa84j.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/80c75f0bjw1dut8ln2otzj.jpg",
                      @"http://ww4.sinaimg.cn/thumbnail/8e3a608bjw1duw1mhfghpj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/68de80adjw1dv5q656mhsj.jpg",
                      @"http://ww3.sinaimg.cn/thumbnail/668669eajw1dv5q3zrmc5g.gif",
                      @"http://tp2.sinaimg.cn/1918109253/50/5637656904/0",
                      @"http://ww4.sinaimg.cn/thumbnail/6e5c06b1jw1dv5q12bx69j.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/8a7cc4bajw1dv59q0gfnlg.gif",
                      @"http://ww3.sinaimg.cn/thumbnail/62d804ccjw1dv2wpwalbcj.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/62ca611cjw1dv5q0vp86jj.jpg",
                      @"http://ww4.sinaimg.cn/thumbnail/96b2d6a5jw1dv5g21891fj.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/61b69811jw1dv5j253cobg.gif",
                      @"http://ww1.sinaimg.cn/thumbnail/888b188cjw1dv38wp76szj.jpg",
                      @"http://ww3.sinaimg.cn/thumbnail/8a1978d7jw1dv5pqla5imj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/78039404gw1dv5ohqrvh1j.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/89645f9ejw1dv4nveaf0ej.jpg",
                      @"http://ww4.sinaimg.cn/thumbnail/62037b5ajw1dv5pqf1idlg.gif",
                      @"http://ww3.sinaimg.cn/bmiddle/95e89532gw1dv4vtexp1lj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/74a70faejw1dv05jk0dw5j.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/9c252c0cjw1dv2anlsg1pj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/668669eagw1dv5pg6mr3rj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/5498c4a0jw1dv5p5q08pej.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/87abf23fjw1dv2cl54ggjg.gif",
                      @"http://ww3.sinaimg.cn/thumbnail/642beb18gw1dv5wfw09e4j.jpg",
                      @"http://ww3.sinaimg.cn/thumbnail/87fb335cjw1dua4a2lenpj.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/6628711bjw1dv5wdr2x9fj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/a772360fjw1dv4my6yaqjj.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/88088c15jw1dv36s8t366j.jpg",
                      @"http://ww4.sinaimg.cn/thumbnail/91d7818cgw1dv2flqj1e0j.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/5f7f0379jw1duv8d20ufvj.jpg",
                      @"http://ww1.sinaimg.cn/thumbnail/63a179c2jw1dv5w7hsqwzg.gif",
//                      @"",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)lagetImageUrl
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"http://ww2.sinaimg.cn/bmiddle/79c0422fjw1dv39ik2z5rj.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/95dc210agw1duva3z651sj.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/a1a9fb72jw1dv4cr2ivuqj.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/9740f5a2jw1dv4ovybxdaj.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/7215528fjw1durrgemy20j.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/6628711bgw1dv5p1c4kzjj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/ad818aaagw1dv1zz7cqlbj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/958d4580gw1dv0wrxay3tj.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/7ef376e6jw1dv5ovgkeh6j.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/6e5c06b1jw1dv5pqk0juoj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/7f1decd2gw1dv4l1jjv4pj.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/76591c14gw1dv4jn4ll1mj.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/61e44a60jw1dv4s2czlltj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/3c63f611jw1dv5p2hjemwj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/a9d754d6gw1duzz0ssvomj.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/9ae5562bjw1dv2hzehff0j.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/8d4f39bejw1dv1zdy4vsij.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/80ab1ad3gw1dv3bbdyphsj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/87abf23fjw1dv2cl54ggjg.gif",
                      @"http://ww2.sinaimg.cn/bmiddle/8190f68ajw1dv4rkgld0kj.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/6fd0724fjw1duzl9pc0dpj.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/91d7818cgw1dv2flqj1e0j.jpg",
                      @"http://ww1.sinaimg.cn/bmiddle/5f7f0379jw1duv8d20ufvj.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/659bc6bbtw1dv5w5t3qvgj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/3ca03128gw1dv6l8u3e0zg.gif",
                      @"http://ww3.sinaimg.cn/bmiddle/66a997b3jw1dv5pc1l4rgj.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/6f248977jw1dv741wmdn1j.jpg",
//                      @"",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)name
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"握了歌曲",
                      @"草泥马",
                      @"妹妹",
                      @"月之五",
                      @"哈里波特大",
                      @"如梦",
                      @"星际潮人",
                      @"美丽国际",
                      @"你奶奶家的胸",
                      @"hELLO123",
                      @"Fiffy",
                      @"Jessica98",
                      @"乱世佳人",
                      @"bigbig沟",
                      @"哈哈哈",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)address
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"新街口大洋百货",
                      @"新街口德基广场8楼",
                      @"金陵饭店2号楼",
                      @"上海路银城大厦",
                      @"华侨路大地建设",
                      @"珠江路金鹰",
                      @"珠江路新世界中心",
                      @"南京大学",
                      @"1912潮人",
                      @"乱世佳人",
                      @"哦w了歌曲",
                      @"希尔顿酒店",
                      @"河西万达广场",
                      @"洪武路万达广场",
                      @"金鹰新天地",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)content
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"我了阿什利的开发旅客理想才能我日流口水的经费i哦离开的经费可是立法局使地方旅客接收到风口浪尖卢萨卡对方流口水的经费老师看到街坊邻舍看对方j哦额我旅客接待室里开发我了阿什利的开发旅客理想才能我日流口水的经费i哦离开的经费可是立法局使地方旅客接收到风口浪尖卢萨卡对方流口水的经费老师看到街坊邻舍看对方j哦额我旅客接待室里开发",
                      @"数量扩大经费噢w额来看将d哦司法局为了看人家噢i的书法家w饿了科技基广场8楼数量扩大经费噢w额来看将d哦司法局为了看人家噢i的书法家w饿了科技基广场8楼数量扩大经费噢w额来看将d哦司法局为了看人家噢i的书法家w饿了科技基广场8楼",
                      @"流口水的飞机了我就佛iw饿了科技反对来说可能法律使地方来的时刻飞机离开首都附近l可w额看来今日考虑到发送量空间乐凯金陵饭店2号楼",
                      @"是克林顿附近离开圣诞节f额为你哦但双方进口量看我如今噢妇女但是快乐福建电视看了飞机呢我等级分看",
                      @"顺口溜地方建立快速电脑热哦我i发动机是离开福建为佛教旅客接待室里附近噢为福建旅客的司法",
                      @"流口水等级分离开w饿哦j发生大力开发j哦微机离开山东解放路看见w额分考虑 lksdjf lksdjf lkdsfjlk klsjdf lkjsdf lklfk  sdf kjlksdjf lksfdj lsdflk jsdfioewj nfdkslnfodf j",
                      @"sdfk jlkjl收到快乐飞机雷克萨斯司法独立空间io",
                      @"山东开发了建立；拉动内开展联系c哦噢w而为皮肉了，。项目主持",
                      @"看来技术等级分旅客j哦i家可是来得及弗兰克三等奖分离开就是离开的飞机旅客介绍",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)phoneNumber
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"4008123123",
                      @"4008517517",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)huXing
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"两室一厅",
                      @"三室一厅",
                      @"四室一厅",
                      @"一室一厅",
                      @"三室两厅",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)category
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"卫浴",
                      @"移门",
                      @"装修公司",
                      @"木门",
                      @"地板",
                      @"家居",
                      @"瓷砖",
                      @"吊顶",
                      @"橱柜",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}

+(NSString*)houseFurnishingName
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"LENS朗斯",
                      @"乐芙曼橱柜",
                      @"帝柏木作定制",
                      @"诺贝尔塞尚印象",
                      @"肯帝亚地板",
                      @"光明家具",
                      @"潇晨装饰",
                      @"云锦木门",
                      @"曲美家具",
                      nil];
    NSUInteger index = (arc4random() % array.count);
    
    return [array objectAtIndex:index];
}


+(NSString*)randomId:(NSUInteger)max
{
    NSUInteger index = arc4random();
    if (max != 0) {
        index = index % max;
    }
    return [NSString stringWithFormat:@"%@", @(index)];
}

+(NSString*)randomDateString
{
    NSDate *now = [NSDate date];
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:60*60*24*365*40];
    
    NSUInteger between = [now timeIntervalSince1970] - [start timeIntervalSince1970];
    return [FMUTestData randomId:between];
}

@end
