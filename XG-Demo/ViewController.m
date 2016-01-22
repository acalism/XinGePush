//
//  ViewController.m
//  XG-Demo
//
//  Created by xiangchen on 13-11-6.
//
//

#import "ViewController.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[XGSetting getInstance] enableDebug:self->swShowLog.on];
    //btnLogoutDevice.enabled = false;
}

- (IBAction)setTag:(id)sender {
    //为不同的"用户"设置标签
    [XGPush setTag:@"name:sean" successCallback:^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"设置标签成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } errorCallback:^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"设置标签失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    //[XGPush setTag:@"name:sean"];
}

- (IBAction)delTag:(id)sender {
    [XGPush delTag:@"age:10" successCallback:^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"删除标签成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } errorCallback:^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"删除标签失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    //[XGPush delTag:@"age:10"];
}

- (IBAction)logoutDevice:(id)sender {
    [XGPush unRegisterDevice:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"注销设备success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } errorCallback:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送" message:@"注销设备fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)toggleDebug:(id)sender {
    [[XGSetting getInstance] enableDebug:self->swShowLog.on];
}

@end
