//
//  AppDelegate.m
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainBIaoQianVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //使用
    
    MainBIaoQianVC *vc = [[MainBIaoQianVC alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    naVC.navigationBar.translucent = NO;
    
    vc.subviewControllerClass = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        //这里添加的是类名不是控制器对象
        [vc.subviewControllerClass addObject:[ViewController class]];
    }
    vc.topScrollViewTitleArray = [@[@"今日新闻",@"音乐",@"歌曲",@"我的娱乐电台",@"我收藏的小说栏目字数够多了吗",@"好的够多了"] mutableCopy];
    
    vc.isSpecial = YES; //以指定为准,默认为NO   &&&&   YES为顶部scrollView可滑动状态
    self.window.rootViewController = naVC;
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
