//
//  AppDelegate+JImCategory.m
//  JIMTest
//
//  Created by ios2 on 2017/12/4.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "AppDelegate+JImCategory.h"

#import "JIMMacro.h"


@implementation AppDelegate (JImCategory)

-(void)startJIMSDKWithLaunchOptions:(NSDictionary *)launchOptions
{
    
    /// Required - 添加 JMessage SDK 监听。这个动作放在启动前
    [JMessage addDelegate:self withConversation:nil];
    
    
    BOOL isProduction = YES;
    
#ifdef DEBUG
       [JMessage setDebugMode];
       isProduction = NO;
#else
      [JMessage setLogOFF];
#endif
    

    /**  Required - 启动 JMessage SDK
     *  apsForProduction  配置环境
     *  messageRoaming    是否启用消息漫游
     * channel            应用的渠道名称 --将来在 网站上有显示 比如 ---iOS ---或者其他
     */
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:isProduction
                   category:nil
             messageRoaming:NO];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
//        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                      UIRemoteNotificationTypeSound |
//                                                      UIRemoteNotificationTypeAlert)
//                                          categories:nil];
    }
    

    
}

/**
 *  得到deviceToken  传给极光
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JMessage registerDeviceToken:deviceToken];
}
/**
 * 注册远程通知失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}
#pragma mark - JMessageDelegate
/**
 * DB 数据正在升级
 */
- (void)onDBMigrateStart
{
    self.isDBMigrating = YES;
}
/**
 * DB数据库升级结束
 */
- (void)onDBMigrateFinishedWithError:(NSError *)error
{
        self.isDBMigrating = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDBMigrateFinishNotification object:nil];
}

- (void)onReceiveMessageRetractEvent:(JMSGMessageRetractEvent *)retractEvent
{
    NSLog(@"onReceiveMessageRetractEvent");
    //消息撤回事件
    NSLog(@"retract message:%@",retractEvent.retractMessage);
}

- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
            /// 事件类型: 收到好友邀请
        case kJMSGEventNotificationReceiveFriendInvitation:
            /// 事件类型: 对方接受了你的好友邀请
        case kJMSGEventNotificationAcceptedFriendInvitation:
            /// 事件类型: 对方拒绝了你的好友邀请
        case kJMSGEventNotificationDeclinedFriendInvitation:
            /// 事件类型: 对方将你从好友中删除
        case kJMSGEventNotificationDeletedFriend:
        {
            /**
             *  添加好友------收到好友邀请-----对方拒绝你的好友邀请 -----对方将你从好友中删除 的通知方法
             */
            //JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[NSNotificationCenter defaultCenter] postNotificationName:kFriendInvitationNotification object:event];
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            /// 事件类型：非客户端修改好友关系收到好友更新事件
            NSLog(@"Receive Server Friend update Notification Event");
            break;
            
        case kJMSGEventNotificationLoginKicked:
            /// 事件类型: 登录被踢
            NSLog(@"LoginKicked Notification Event ");
        case kJMSGEventNotificationServerAlterPassword:{
            /// 事件类型: 非客户端修改密码强制登出事件
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"AlterPassword Notification Event ");
            }
            // 事件类型：用户登录状态异常事件（需要重新登录）
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"User login status unexpected Notification Event ");
            }
        }
            break;
            
        default:
            break;
    }
}



/*!
 * @abstract 发送消息结果返回回调
 *
 * @param message 原发出的消息对象
 * @param error 不为nil表示发送消息出错
 *
 * @discussion 应检查 error 是否为空来判断是否出错. 如果未出错, 则成功.
 */

- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error
{
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    if (error) {
        [dic setObject:error forKey:@"error"];
    }else if (message){
       [dic setObject:message forKey:@"message"];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"messageSendCallBack" object:dic];
}
/*!
 * @abstract 接收消息(服务器端下发的)回调
 *
 * @param message 接收到下发的消息
 * @param error 不为 nil 表示接收消息出错
 *
 * @discussion 应检查 error 是否为空来判断有没有出错. 如果未出错, 则成功.
 * 留意的是, 这里的 error 不包含媒体消息下载文件错误. 这类错误有单独的回调 onReceiveMessageDownloadFailed:
 *
 * 收到的消息里, 也包含服务器端下发的各类消息事件, 比如有人被加入了群聊. 这类消息事件处理为特殊的 JMSGMessage 类型.
 *
 * 事件类的消息, 基于 JMSGMessage 类里的 contentType 属性来做判断,
 * contentType = kJMSGContentTypeEventNotification.
 */

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error
{
    
    NSMutableDictionary *dic = [@{
                                  @"message":message
                                  } mutableCopy];
    if (error) {
        [dic setObject:error forKey:@"error"];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"receiveMessage" object:dic];
}

/*!
 * @abstract 接收消息媒体文件下载失败的回调
 *
 * @param message 下载出错的消息
 *
 * @discussion 因为对于接收消息, 最主要需要特别做处理的就是媒体文件下载, 所以单列出来. 一定要处理.
 *
 * 通过的作法是: 如果是图片, 则 App 展示一张特别的表明未下载成功的图, 用户点击再次发起下载. 如果是语音,
 * 则不必特别处理, 还是原来的图标展示. 用户点击时, SDK 发现语音文件在本地没有, 会再次发起下载.
 */
- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message
{
//文件下载失败
//    NSDictionary *dic = @{
//                          @"message":message,
//                          };
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"fileDownLoadFailMessage" object:dic];
}


@end
