//
//  ChatListViewController.m
//  JIMTest
//
//  Created by ios2 on 2017/12/4.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatListViewController.h"

#import "JIMRegistManager.h"


#import <JMessage/JMessage.h>


#import "ViewController.h"

#import "ChatImageView.h"



@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
// asdfg123456
// asdfg123456    zhangSan12345678   123456
    
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:button];
        button.frame = CGRectMake(i*100.0f+80, 100, 80, 80);
        button.tag = i+10;
        [button addTarget:self action:@selector(buttonCliced:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    ChatImageView *chatImageView = [[ChatImageView alloc]init];
    [self.view addSubview:chatImageView];
    chatImageView.frame = CGRectMake(10, 200, 200, 200);

    [chatImageView configerWithImageSize:(CGSize){200,200} andIsRight:YES];
    
    chatImageView.image = [UIImage imageNamed:@"12345.jpg"];
    
    
    ChatImageView *chatImageView2 = [[ChatImageView alloc]init];
    
    [self.view addSubview:chatImageView2];
    
    chatImageView2.frame = CGRectMake(10, 400, 200, 300);
    
    [chatImageView2 configerWithImageSize:(CGSize){200,300} andIsRight:NO];
    
    chatImageView2.image = [UIImage imageNamed:@"12345.jpg"];
    
    
}
-(void)buttonCliced:(UIButton *)button
{
    if (button.tag==10) {
        [self registUser:@"asdfg123456" loginUserName:@"zhangSan33333"];
    }else if (button.tag==11){
        [self registUser:@"zhangSan33333" loginUserName:@"asdfg123456"];
    }else {
        
    }
}

-(void)registUser:(NSString *)userName loginUserName:(NSString *)loginUserName
{
    [JIMRegistManager loginWithUserName:loginUserName andPw:@"asdfg123456" andCompletion:^(BOOL isSuccess, NSString *msg) {
        if (!isSuccess) {
            [JIMRegistManager registUserAndLoginWithUserName:loginUserName andPw:@"asdfg123456" andRegistCompletion:^(BOOL aisSuccess, NSString * amsg) {
                
            } andLoginCompletion:^(BOOL bisSuccess, NSString * bmsg) {
                  [self creactSigleChat:userName];
            }];
        }else{
            [self creactSigleChat:userName];
        }
    }];
}

-(void)creactSigleChat:(NSString *)userName
{
    [JMSGConversation createSingleConversationWithUsername:userName completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            JMSGConversation *conversation = (JMSGConversation *)resultObject;
            //可以拿到会话的参数
            ViewController *vc = [[ViewController alloc]init];
            vc.conversation = conversation;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
