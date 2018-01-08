//
//  ViewController.m
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ViewController.h"

#import "ZXChatBoxController.h"

#import "ChatContaintViewController.h"


#import "CategaryHeader_TL.h"


@interface ViewController ()<ZXChatBoxViewControllerDelegate,ChatContaintVcDelegate>

@property (nonatomic,strong)ZXChatBoxController * chatBoxVC;

@property (nonatomic,strong)ChatContaintViewController *chatContainVc;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //监听连接状态  正在连接中
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(linkingNotification:) name:kJMSGNetworkIsConnectingNotification object:nil];
    //建立连接
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(linkbuildSuccessNotification:) name:kJMSGNetworkDidSetupNotification object:nil];
    //关闭连接
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeLinkNotification:) name:kJMSGNetworkDidCloseNotification object:nil];
    //连接成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(linkSuccessNotification:) name:kJMSGNetworkDidLoginNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view  addSubview:self.chatContainVc.view];
    
    [self.view  addSubview:self.chatBoxVC.view];
    //传入 会话的类型
    self.chatContainVc.conversation = self.conversation;
    [self addChildViewController:self.chatBoxVC];
    
    [self addChildViewController:self.chatContainVc];
    
    self.navigationItem.title = @"张三";
    
}
//状态发生改变
-(void)linkingNotification:(NSNotification *)noti
{
    self.navigationItem.title = @"连接中..";
}
-(void)linkbuildSuccessNotification:(NSNotification *)noti
{
     self.navigationItem.title = @"连接中..";
}
-(void)closeLinkNotification:(NSNotification *)noti
{
     self.navigationItem.title = @"连接中..";
}
-(void)linkSuccessNotification:(NSNotification *)noti
{
        self.navigationItem.title = @"张三";
}

    // chatBoxView 高度改变
- (void)chatBoxViewController:(ZXChatBoxController *)chatboxViewController
       didChangeChatBoxHeight:(CGFloat)height
{
    self.chatBoxVC.view.originY =HEIGHT_SCREEN - height;
    [UIView animateWithDuration:0.2 animations:^{
        self.chatContainVc.view.frameHeight =HEIGHT_SCREEN-height-TopHeight;
    }];
}
    // 发送消息
- (void) chatBoxViewController:(ZXChatBoxController *)chatboxViewController
                   sendMessage:(id)message
{
    [self.chatContainVc sendMessage:message];
}

-(ZXChatBoxController *) chatBoxVC
    {
        if (_chatBoxVC == nil) {
            
            _chatBoxVC = [[ZXChatBoxController alloc] init];
            
            [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN - HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN)];
            
            [_chatBoxVC setDelegate:self];
        }
        
        return _chatBoxVC;
}

-(ChatContaintViewController *)chatContainVc
{
    if (!_chatContainVc)
    {
        _chatContainVc = [[ChatContaintViewController alloc]init];
        _chatContainVc.delegate = self;
        [_chatContainVc.view setFrame:CGRectMake(0, TopHeight, WIDTH_SCREEN,HEIGHT_SCREEN - HEIGHT_TABBAR-TopHeight)];
    }
    return _chatContainVc;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)didTapChatMessageView:(id)sender
{
    [self.chatBoxVC resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
