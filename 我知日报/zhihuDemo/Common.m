//
//  Common.m
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Common



+(void)configSet:(NSString *)key value:(id)value{
    NSUserDefaults *saveData=[NSUserDefaults standardUserDefaults];
    [saveData setObject:value forKey:key];
    [saveData synchronize];
}

+(id)configGet:(NSString *)key{
    NSUserDefaults *readData=[NSUserDefaults standardUserDefaults];
    return [readData arrayForKey:key];
}


//md5 16位加密 （大写）
+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+(void)loadImage:(UIImageView *)imageView url:(NSString *)url{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

+(void)loadImage1:(UIImageView *)imageView url:(NSString *)url{
    if (!url) {
        return;
    }
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[self md5:url]];
    NSData *imageDate=[[NSData alloc]initWithContentsOfFile:fullPath];
    if (imageDate) {
        imageView.image=[UIImage imageWithData:imageDate];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *urlImages=[NSURL URLWithString:url];
            NSData *ImDate=[NSData dataWithContentsOfURL:urlImages];
            imageView.image=[UIImage imageWithData:ImDate];
            NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[self md5:url]];
            [ImDate writeToFile:fullPath atomically:NO];
        });
    }
 }

+(void)initWithDate:(NSString *)urlStr finishedLoad:(void(^)(NSDictionary *))myBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url=[NSURL URLWithString:urlStr];
        NSData *data=[NSData dataWithContentsOfURL:url];
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            myBlock(json);
        });
    });
}
@end
