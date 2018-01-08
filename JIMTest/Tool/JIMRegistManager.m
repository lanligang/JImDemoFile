//
//  JIMRegistManager.m
//  JIMTest
//
//  Created by ios2 on 2017/12/4.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "JIMRegistManager.h"
#import <JMessage/JMessage.h>
#import "JTool.h"

@implementation JIMRegistManager

//专门负责注册 登录

+(void)registUserWithUserName:(NSString *)userName
                        andPw:(NSString *)pw
                andCompletion:(void(^)(BOOL isSuccess,NSString *msg))completion
{
    //JMSGUserInfo  也是可以用
    if (pw==nil)
    {
        pw = @"ppxiiiooo";
    }
    [JMSGUser registerWithUsername:userName password:pw userInfo:nil completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            //注册成功
            if (completion) {
                completion(YES,@"注册成功");
            }
        }else{
            //注册失败
            if (completion) {
                NSString *errorMsg = [JTool errorAlert:error];
                completion(NO,errorMsg);
            }
        }
    }];
}

/**
 * userName 注册的用户名称  * 在极光注册的唯一用户名
 * pw        用户密码
 */
+(void)loginWithUserName:(NSString *)userName
                   andPw:(NSString *)pw
                andCompletion:(void(^)(BOOL isSuccess,NSString *msg))completion
{
    if (pw==nil) {
        pw = @"ppxiiiooo";
    }
    [JMSGUser loginWithUsername:userName password:pw completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
        NSLog(@"登录成功");
            if (completion) {
                completion(YES,@"登录成功");
            }
        }else{
            //登录失败
            if (completion) {
                NSString *errorMsg = [JTool errorAlert:error];
                completion(NO,errorMsg);
            }
        }
    }];
}

+(void)registUserAndLoginWithUserName:(NSString *)userName
                                andPw:(NSString *)pw
                        andRegistCompletion:(void (^)(BOOL, NSString *))registCompletion
                   andLoginCompletion:(void (^)(BOOL, NSString *))loginCompletion
{
    [self registUserWithUserName:userName andPw:pw andCompletion:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            if (registCompletion){
                registCompletion(YES,msg);
            }
            [self loginWithUserName:userName andPw:pw andCompletion:^(BOOL aIsSuccess, NSString *aMsg) {
                if (aIsSuccess) {
                    //登录成功
                    if (loginCompletion) {
                        loginCompletion(YES,aMsg);
                    }
                }else{
                    //登录失败
                    if (loginCompletion) {
                        loginCompletion(NO,aMsg);
                    }
                }
            }];
        }else{
            if (registCompletion) {
                registCompletion(NO,msg);
            }
        }
    }];
}




@end
