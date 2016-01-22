//
//  AppDelegate.m
//  XG-Demo
//
//  Created by xiangchen on 13-11-6.
//
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //角标清0

    //清除所有通知(包含本地通知)
    //[application cancelAllLocalNotifications];

    //初始化app
    //[XGPush startWithAppkey:@"IN421FX97FUT"];
    //[XGPush startAppForMSDK:354 appKey:@"xg354key"];
    //[XGPush startApp:101 appKey:@"akey"];
    [XGPush startApp:2200022728 appKey:@"IMJ34Y25JN4I"]; //[XGPush startApp:2290000353 appKey:@"key1"];

    //注销之后需要再次注册前的准备
    [XGPush initForReregister:^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus]) {
            if ([UIUserNotificationAction class] == Nil) {
                [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)]; // iOS 7
                return;
            }
            // iOS 8 and later
            //Actions
            UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
            acceptAction.activationMode = UIUserNotificationActivationModeForeground;
            acceptAction.authenticationRequired = NO;
            acceptAction.destructive = NO;
            acceptAction.identifier = @"ACCEPT_IDENTIFIER";
            acceptAction.title = @"Accept";

            //Categories
            UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
            [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
            [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
            inviteCategory.identifier = @"INVITE_CATEGORY";
            NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];

            UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
            [application registerUserNotificationSettings:mySettings];
            [application registerForRemoteNotifications];
        }
    }];

    //推送反馈(app不在前台运行时，点击推送激活时)
    // [XGPush handleLaunching:launchOptions]; // 无回调版本
    [XGPush handleLaunching:launchOptions successCallback:^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    } errorCallback:^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    }];

    //本地推送示例
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
    [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:@{@"clockID" : @"myid"}];

    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //	[XGPush setAccount:@"test"]; // 设置账号，registerDevice之前调用
    //注册设备
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken]; // 如果不需要回调
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
    } errorCallback:^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    }];
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@", deviceTokenStr);
}
// 如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"[XGPush Demo]%@", str);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

// 注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
}

// 按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
}



- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    [XGPush handleReceiveNotification:userInfo]; // 推送反馈(app运行时)

    // 回调版本示例
    [XGPush handleReceiveNotification:userInfo successCallback:^(void){
        // 成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
    } errorCallback:^(void){
        // 失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    } completion:^(void){
        // 失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@", userInfo);
    }];
    
}

@end
