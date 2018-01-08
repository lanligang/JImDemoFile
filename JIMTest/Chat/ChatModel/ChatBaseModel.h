//
//  ChatBaseModel.h
//  JIMTest
//
//  Created by ios2 on 2017/12/1.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//



#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <JMessage/JMessage.h>


//会话的类型
typedef enum : NSUInteger {
    TextType,                      //文字类型
    voiceType,                     //声音类型
    photoType,                     //图片类型
    timeLineType                   //时间戳类型
} MessageType;


@interface ChatBaseModel : NSObject
//当前用户的id
@property (nonatomic,copy) NSString * userId;
//自己是不是发送者
@property(nonatomic,assign)BOOL isSender;
//发送者的ID
@property (nonatomic,copy) NSString *fromId;
//接收者的ID
@property (nonatomic,copy) NSString *toId;
//当前会话ID
@property (nonatomic,strong)NSString  *conversationId;
//消息类型
@property(nonatomic,assign)MessageType messageType;

//得到的cell高度数据  计算cell的高度
@property(nonatomic,assign)CGFloat  cellHeight;


//--------------------------文本消息属性---------------------------------
//会话的消息内容  文字
@property (nonatomic,strong)NSString *message;
//富文本  该富文本适配的是 YYLable  排版引擎
@property (nonatomic,strong)NSAttributedString *attributedStr;
//文本的frame
@property(nonatomic,assign)CGRect textFrame;
//点击连接的回调
@property (nonatomic,copy)void(^clickedUrlBlock)(NSString *url);

//-------------------------语音属性--------------------------------------
/**
 * 语音消息
 * voiceLocalPath 语音消息的本地路径
 * voiceDuration  语音消息的时长
 * voiceServerPath 语音消息的服务器地址
 */

//语音消息的本地地址
@property (nonatomic,strong)NSString *voiceLocalPath;

//语音消息的时长
@property(nonatomic,assign)NSInteger voiceDuration;

//语音消息的服务器地址
@property (nonatomic,strong)NSString *voiceServerPath;
/**
 * 声音的宽度
 */
@property (nonatomic, assign) CGFloat voiceImageWidth;

/**
 *  用来记录极光的model 参数
 */
@property (nonatomic,strong)JMSGMessage *jMessage;

/**
 *  保证滑动就会更新该值 以及刷新也会更新
 */
@property (nonatomic,readonly)NSString *timeString;



@end
