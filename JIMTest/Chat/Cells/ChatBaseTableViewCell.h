//
//  ChatBaseTableViewCell.h
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//
/**
 * 聊天消息 cell 基类
 * chatModel  接收到的数据 model
 * headerRaduis 头像的圆角
 * headerImageView 头像图片
 * bubbleImageView 气泡图片
 */

#import <UIKit/UIKit.h>
//引入第三方头文件
#import <YYText.h>
#import <YYImage.h>
#import "ChatBaseModel.h"
#import <JMessage/JMessage.h>
#import "UIImage+ChatImageLoader.h"



@interface ChatBaseTableViewCell : UITableViewCell

@property (nonatomic,strong)id chatModel;

//头像的圆切角 头像大小为 45*45

@property(nonatomic,assign)CGFloat headerRaduis;
//头像
@property (nonatomic,strong)UIImageView *headerImageView;

//气泡
@property (nonatomic,strong)UIImageView *bubbleImageView;

//昵称
@property (nonatomic,strong)UILabel *nickNameLable;
// 已读字符串为 @“”  未读 显示字符串 为 @“未读”
@property (nonatomic,strong)UILabel *readStateLable;

//设置是否是发送者 这里在子类里面调用 只是用来修改头像的frame

-(void)configerIsSender:(BOOL)isSender;


//子类继承的方法  用于设置model
-(void)configerWithModel:(id)chatModel;




@end
