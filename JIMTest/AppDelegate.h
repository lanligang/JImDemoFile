//
//  AppDelegate.h
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,JMessageDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)BOOL isDBMigrating;

@end

