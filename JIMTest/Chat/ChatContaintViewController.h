//
//  ChatContaintViewController.h
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JMessage/JMessage.h>

@protocol ChatContaintVcDelegate<NSObject>


-(void)didTapChatMessageView:(id)sender;



@end

@interface ChatContaintViewController : UIViewController

@property (nonatomic,strong)JMSGConversation *conversation;

@property(nonatomic,assign)id <ChatContaintVcDelegate>delegate;

-(void)sendMessage:(id)message;

@end
