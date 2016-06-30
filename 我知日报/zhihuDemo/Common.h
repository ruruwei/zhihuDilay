//
//  Common.h
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"



@interface Common : NSObject
+(void)configSet:(NSString *)key value:(id)value;//声明存数据函数
+(id)configGet:(NSString *)key;//声明读取数据函数
+ (NSString *)md5:(NSString *)str;
+(void)loadImage1:(UIImageView *)imageView url:(NSString *)url;

+(void)loadImage:(UIImageView *)imageView url:(NSString *)url;
+(void)initWithDate:(NSString *)urlStr finishedLoad:(void(^)(NSDictionary *))myBlock;


@end

