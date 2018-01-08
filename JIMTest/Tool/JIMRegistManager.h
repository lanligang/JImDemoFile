//
//  JIMRegistManager.h
//  JIMTest
//
//  Created by ios2 on 2017/12/4.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JIMRegistManager : NSObject

//注册
+(void)registUserWithUserName:(NSString *)userName
                        andPw:(NSString *)pw
                andCompletion:(void(^)(BOOL isSuccess,NSString *msg))completion;


//登录
+(void)loginWithUserName:(NSString *)userName
                   andPw:(NSString *)pw
           andCompletion:(void(^)(BOOL isSuccess,NSString *msg))completion;


//注册后直接登录
+(void)registUserAndLoginWithUserName:(NSString *)userName
                                andPw:(NSString *)pw
                  andRegistCompletion:(void (^)(BOOL, NSString *))registCompletion
                   andLoginCompletion:(void (^)(BOOL, NSString *))loginCompletion;

@end
