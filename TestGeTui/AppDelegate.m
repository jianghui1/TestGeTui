//
//  AppDelegate.m
//  TestGeTui
//
//  Created by ys on 16/1/15.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "AppDelegate.h"

#import "GeTuiSdk.h"

#import "NextViewController.h"

#import "NotificationSound.h"
#import <MBProgressHUD.h>

#define KGTAppId @"YX50Bo9qjv9ysmAo0JEy77"
#define kGTAppKey @"7d2mlpbskbAUQvfrZui3f2"
#define kGTAppSecret @"5p49re59BE6BRLRV85N1J1"

#define NotifyActionKey @"NotifyAction"
NSString *const NotificationCategoryIdent = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"ACTION_ONE";
NSString *const NotificationActionTwoIdent = @"ACTION_TWO";


@interface AppDelegate ()<GeTuiSdkDelegate>

// 是否需要播放声音
@property (nonatomic, assign) BOOL notNeedSound;
// 重新启动
@property (nonatomic, assign) BOOL reLaunch;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    NSLog(@"launchOptions == %@", launchOptions);
    
    // 通过个推平台分配的appId、appKey、appSecret启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:KGTAppId appKey:kGTAppKey appSecret:kGTAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
    
    NSLog(@"蒋增辉--%s", __FUNCTION__);
    
    self.reLaunch = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    NSLog(@"蒋增辉--%s", __FUNCTION__);
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    NSLog(@"蒋增辉--%s", __FUNCTION__);
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    NSLog(@"蒋增辉--%s", __FUNCTION__);
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"蒋增辉--%s", __FUNCTION__);
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"蒋增辉--%s", __FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"蒋增辉--%s", __FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    
    [MBProgressHUD showHUDAddedTo:self.window animated:YES].labelText = [@([UIApplication sharedApplication].applicationIconBadgeNumber) stringValue];
    if (self.reLaunch) {
        [UIApplication sharedApplication].applicationIconBadgeNumber--;
    }
    
    NSLog(@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    
    [self performSelector:@selector(delaySEL) withObject:nil afterDelay:5];
    
    
    
    NSLog(@"蒋增辉--%s", __FUNCTION__);
}

- (void)delaySEL
{
    [MBProgressHUD showHUDAddedTo:self.window animated:YES].labelText = [@([UIApplication sharedApplication].applicationIconBadgeNumber) stringValue];
}

#pragma mark - appDelegate中集成个推
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:myToken];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}
// 接收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *record = [NSString stringWithFormat:@"didReceiveRemoteNotification->%@", userInfo];
    NSLog(@"%@", record);
    self.notNeedSound = YES;
}
// 已登记用户通知
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}
// 远程通知注册失败委托
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // 如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
    NSLog(@"\n>>>[DevieToken Error]:%@\n\n", error.description);
}
// 远程通知后台刷新数据
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Background Fetch 回复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 推送代理方法
// SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSDK RegisterClient]:%@\n\n", clientId);
}
// SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知
    NSLog(@"\n>>>[GeTuiSDK error]:%@\n\n", [error localizedDescription]);
}
// SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId
{
    // 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payloadId) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    NSString *msg = [NSString stringWithFormat:@"payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@", payloadId, taskId, aMsgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSDK ReceivePayload]:%@\n\n", msg);
    
    /**
     * 汇报个推自定义事件
     * actionId: 用户自定义的actionId，int类型，取值90001-90999.
     * taskId: 下发任务的任务ID。
     * msgId: 下发任务的消息ID。
     * 返回值: BOOL, YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表用服务器收到该条命令
     */
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
    
    if (!self.notNeedSound) {
        NotificationSound *sound = [[NotificationSound alloc] initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
        [sound play];
    }
    self.notNeedSound = NO;
}
// SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@, result=%d", messageId, result];
    NSLog(@"\n>>>[GeTuiSDK DidSendMessage]:%@\n\n", msg);
}
// SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    // 通知SDK运行状态
    NSLog(@"\n>>>[GeTuiSDK SDKState]:%u\n\n", aStatus);
}
// SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error
{
    if (error) {
        NSLog(@"\n>>>[GeTuiSDK SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"\n>>>[GeTuiSDK SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}


#pragma mark - 注册APNS
- (void)registerUserNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2] forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

#pragma mark - 处理远程通知启动APP
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions
{
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSData data], userInfo];
        NSLog(@"userInfo->record:%@", record);
    }
    self.notNeedSound = YES;
}


#pragma mark - 3D-touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    // 判断先前我们设置的唯一标识
    if ([shortcutItem.type isEqualToString:@"-11.UITouchText.share"]) {
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
        // 设置当前的vc为rootVC
        vc.view.backgroundColor = [UIColor redColor];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    if ([shortcutItem.type isEqualToString:@"two"]) {
        NextViewController *nextVC = [[NextViewController alloc] init];
        [self.window.rootViewController presentViewController:nextVC animated:YES completion:nil];
    }
}

@end
