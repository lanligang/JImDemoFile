//
//  AppDelegate.m
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ChatListViewController.h"
#import "AppDelegate+JImCategory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startJIMSDKWithLaunchOptions:launchOptions];
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    window.backgroundColor = [UIColor whiteColor];
    
    self.window = window;
    
    [self.window makeKeyWindow];
    
    [self.window makeKeyAndVisible];
    
    ChatListViewController *rootVc = [[ChatListViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootVc];
    
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    [self resetBadgeWithApplication:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self resetBadgeWithApplication:application];
}
/**
 * 进入后台时候重置 icon 标识数
 */
-(void)resetBadgeWithApplication:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JMessage resetBadge];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
