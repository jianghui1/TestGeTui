//
//  ViewController.m
//  TestGeTui
//
//  Created by ys on 16/1/15.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "ViewController.h"

#import "DownLoadHelper.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加3D-Touch
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSString *iconString = [DownLoadHelper downImageWithUrlString:@"http://cdn1.liqu.cc/upload/chonggou/ad/4550975b-d05c-4d27-a525-53daf3c68024.jpg"];
    UIApplicationShortcutIcon *icon;
    if (iconString != nil) {
        icon = [UIApplicationShortcutIcon iconWithTemplateImageName:iconString];
        NSLog(@"下载图片成功");
    } else {
        icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
    }
    
    NSArray *iconArray = @[@(UIApplicationShortcutIconTypeCompose),                                                                @(UIApplicationShortcutIconTypePlay),];
//                          @(UIApplicationShortcutIconTypePause),
//                          @(UIApplicationShortcutIconTypeAdd),
//    @(UIApplicationShortcutIconTypeLocation),
//                          @(UIApplicationShortcutIconTypeSearch),
//                          @(UIApplicationShortcutIconTypeShare),
//                          @(UIApplicationShortcutIconTypeProhibit),@(UIApplicationShortcutIconTypeContact),@(UIApplicationShortcutIconTypeHome),@(UIApplicationShortcutIconTypeMarkLocation),@(UIApplicationShortcutIconTypeFavorite),@(UIApplicationShortcutIconTypeLove),@(UIApplicationShortcutIconTypeCloud),@(UIApplicationShortcutIconTypeInvitation),@(UIApplicationShortcutIconTypeConfirmation),@(UIApplicationShortcutIconTypeMail),@(UIApplicationShortcutIconTypeMessage),@(UIApplicationShortcutIconTypeDate),@(UIApplicationShortcutIconTypeTime),@(UIApplicationShortcutIconTypeCapturePhoto),@(UIApplicationShortcutIconTypeCaptureVideo),@(UIApplicationShortcutIconTypeTask),@(UIApplicationShortcutIconTypeTaskCompleted),@(UIApplicationShortcutIconTypeAlarm),@(UIApplicationShortcutIconTypeBookmark),@(UIApplicationShortcutIconTypeShuffle),@(UIApplicationShortcutIconTypeAudio),@(UIApplicationShortcutIconTypeUpdate)];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue < 9.0) {
        return;
    }
    NSMutableArray *shortcutItmes = [NSMutableArray array];
    for (int i = 0; i < iconArray.count; i++) {
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"two" localizedTitle:@"第二个标签" localizedSubtitle:@"看我哦" icon:[UIApplicationShortcutIcon iconWithType:((NSNumber *)(iconArray[i])).integerValue] userInfo:nil];
        [shortcutItmes addObject:item];
        
    }
    self.array = shortcutItmes;
    // 添加
    [UIApplication sharedApplication].shortcutItems = shortcutItmes;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:iconString];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [imageView addGestureRecognizer:tap];
}

- (void)tapAction
{
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"two" localizedTitle:@"新增加的" localizedSubtitle:@"看我哦" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [self.array addObject:item];
    [UIApplication sharedApplication].shortcutItems = self.array;
}

@end
