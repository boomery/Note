//
//  AppDelegate.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "AppDelegate.h"
#import "CXDataBaseUtil.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "TestView.h"
#import "NavViewController.h"
#import "WXGMainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarTintColor:THEME_COLOR];
    
    [CXDataBaseUtil creatTable];
    
    [self gotoLoginVC];
    //随便加的注释ASDSAD
    return YES;
}

+ (AppDelegate *)delegate
{
    return [[UIApplication sharedApplication] delegate];
}
- (void)gotoMainVC
{
    //用户选择输入密码，切换主线程处理
    WXGMainViewController *vc = [[WXGMainViewController alloc] init];
//    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = vc;
}
- (void)gotoLoginVC
{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = nav;
}

- (void)addBlurView
{
    //添加
    TestView *view = [[TestView alloc] initWithFrame:self.window.frame];
    view.tag = 11111;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [window addSubview:view];
        }
    }
}
- (void)removeBlurView
{
    //移除
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (window.windowLevel == UIWindowLevelNormal)
        {
            for (UIView *view in window.subviews)
            {
                if ([view isKindOfClass:[TestView class]])
                {
                    [view removeFromSuperview];
                }
            }
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self addBlurView];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self removeBlurView];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
