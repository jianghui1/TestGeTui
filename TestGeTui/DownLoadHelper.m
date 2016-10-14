//
//  DownLoadHelper.m
//  TestGeTui
//
//  Created by ys on 16/2/19.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "DownLoadHelper.h"

@implementation DownLoadHelper

+ (NSString *)downImageWithUrlString:(NSString *)urlString
{
    //开一个子线程下载图片
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *saveDiretory = [NSString stringWithFormat:@"%@/image",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject]];
    
    //判断文件夹是否存在
    BOOL isDirectory ;
    
    BOOL isExist = [fm fileExistsAtPath:saveDiretory isDirectory:&isDirectory];
    
    if (!isExist) {
        
        // 所在路径不存在,创建路径后写入图片...
        [fm createDirectoryAtPath:saveDiretory withIntermediateDirectories:NO attributes:nil error:nil];
        
    }else{
        // 路径存在,直接写入图片...
        
    }
    
    //写入图片
    NSString *savePath =[NSString stringWithFormat: @"%@/%@.jpg",saveDiretory,[NSUUID UUID].UUIDString];
    
    BOOL saveSuccess = [imageData writeToFile:savePath atomically:YES];
    
    if (saveSuccess) {
        return  savePath;
    } else {
        return nil;
    }
    
}

@end
