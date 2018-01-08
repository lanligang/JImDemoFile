//
//  JTool.m
//  JIMTest
//
//  Created by ios2 on 2017/12/4.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "JTool.h"
#import "sys/utsname.h"
#import <JMessage/JMessage.h>

@implementation JTool
+ (NSString *)errorAlert:(NSError *)error
{
    NSString *errorAlert = nil;
    
    switch (error.code) {
        case kJMSGErrorSDKNetworkDownloadFailed:
            errorAlert = @"下载失败";
            break;
        case kJMSGErrorSDKNetworkUploadFailed:
            errorAlert = @"上传资源文件失败";
            break;
        case kJMSGErrorSDKNetworkUploadTokenVerifyFailed:
            errorAlert = @"上传资源文件Token验证失败";
            break;
        case kJMSGErrorSDKNetworkUploadTokenGetFailed:
            errorAlert = @"获取服务器Token失败";
            break;
        case kJMSGErrorSDKDBDeleteFailed:
            errorAlert = @"数据库删除失败";
            break;
        case kJMSGErrorSDKDBUpdateFailed:
            errorAlert = @"数据库更新失败";
            break;
        case kJMSGErrorSDKDBSelectFailed:
            errorAlert = @"数据库查询失败";
            break;
        case kJMSGErrorSDKDBInsertFailed:
            errorAlert = @"数据库插入失败";
            break;
        case kJMSGErrorSDKParamAppkeyInvalid:
            errorAlert = @"appkey不合法";
            break;
            
        case kJMSGErrorSDKParamUsernameInvalid:
            errorAlert = @"用户名不合法";
            break;
        case kJMSGErrorSDKParamPasswordInvalid:
            errorAlert = @"用户密码不合法";
            break;
        case kJMSGErrorSDKUserNotLogin:
            errorAlert = @"用户没有登录";
            break;
        case kJMSGErrorSDKNotMediaMessage:
            errorAlert = @"这不是一条媒体消息";
            break;
        case kJMSGErrorSDKMediaResourceMissing:
            errorAlert = @"下载媒体资源路径或者数据意外丢失";
            break;
        case kJMSGErrorSDKMediaCrcCodeIllegal:
            errorAlert = @"媒体CRC码无效";
            break;
        case kJMSGErrorSDKMediaCrcVerifyFailed:
            errorAlert = @"媒体CRC校验失败";
            break;
        case kJMSGErrorSDKMediaUploadEmptyFile:
            errorAlert = @"上传媒体文件时, 发现文件不存在";
            break;
        case kJMSGErrorSDKParamContentInvalid:
            errorAlert = @"无效的消息内容";
            break;
        case kJMSGErrorSDKParamMessageNil:
            errorAlert = @"空消息";
            break;
        case kJMSGErrorSDKMessageNotPrepared:
            errorAlert = @"消息不符合发送的基本条件检查";
            break;
        case kJMSGErrorSDKParamConversationTypeUnknown:
            errorAlert = @"未知的会话类型";
            break;
        case kJMSGErrorSDKParamConversationUsernameInvalid:
            errorAlert = @"会话 username 无效";
            break;
        case kJMSGErrorSDKParamConversationGroupIdInvalid:
            errorAlert = @"会话 groupId 无效";
            break;
        case kJMSGErrorSDKParamGroupGroupIdInvalid:
            errorAlert = @"groupId 无效";
            break;
        case kJMSGErrorSDKParamGroupGroupInfoInvalid:
            errorAlert = @"group 相关字段无效";
            break;
        case kJMSGErrorSDKMessageNotInGroup:
            errorAlert = @"你已不在该群，无法发送消息";
            break;
        case 810009:
            errorAlert = @"超出群上限";
            break;
        case kJMSGErrorHttpServerInternal:
            errorAlert = @"服务器端内部错误";
            break;
        case kJMSGErrorHttpUserExist:
            errorAlert = @"用户已经存在";
            break;
        case kJMSGErrorHttpUserNotExist:
            errorAlert = @"用户不存在";
            break;
        case kJMSGErrorHttpPrameterInvalid:
            errorAlert = @"参数无效";
            break;
        case kJMSGErrorHttpPasswordError:
            errorAlert = @"密码错误";
            break;
        case kJMSGErrorHttpUidInvalid:
            errorAlert = @"内部UID 无效";
            break;
        case kJMSGErrorHttpMissingAuthenInfo:
            errorAlert = @"Http 请求没有验证信息";
            break;
        case kJMSGErrorHttpAuthenticationFailed:
            errorAlert = @"Http 请求验证失败";
            break;
        case kJMSGErrorHttpAppkeyNotExist:
            errorAlert = @"Appkey 不存在";
            break;
        case kJMSGErrorHttpTokenExpired:
            errorAlert = @"Http 请求 token 过期";
            break;
        case kJMSGErrorHttpServerResponseTimeout:
            errorAlert = @"服务器端响应超时";
            break;
        case kJMSGErrorTcpUserNotRegistered:
            errorAlert = @"用户名还没有被注册过";
            break;
        case kJMSGErrorTcpUserPasswordError:
            errorAlert = @"密码错误";
            break;
        case kJMSGErrorTcpUserInBlacklist:
            errorAlert = @"您已被加入黑名单";
            break;
        default:
            errorAlert = nil;
            break;
    }
    return errorAlert;
}

@end
