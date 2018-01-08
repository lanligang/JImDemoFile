//
//  ChatTextTableViewCell.m
//  JIMTest
//
//  Created by ios2 on 2017/12/1.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatTextTableViewCell.h"

#import <YYImage/YYAnimatedImageView.h>
#import <YYImage/YYImage.h>

@implementation ChatTextTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.bubbleImageView addSubview:self.messageLable];
        UILongPressGestureRecognizer *longGessture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesstureAction:)];
        
        [self.messageLable addGestureRecognizer:longGessture];
    }
    return self;
}

-(void)configerWithModel:(id)chatModel
{
    [super configerWithModel:chatModel];
    //设置是否是发送者来设置头像的位置
    ChatBaseModel *model = chatModel;
    self.messageLable.frame = model.textFrame;
    self.messageLable.attributedText = model.attributedStr;
    
    [self configerIsSender:model.isSender];
    
    [model setClickedUrlBlock:^(NSString *url) {
        if (![url hasPrefix:@"http"])
        {
            url = [NSString stringWithFormat:@"http://%@",url];
        }
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]])
        {
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }
    }];
    //设置气泡位置
}
/**
 * 子类继续使用父类的方法
 */
-(void)configerIsSender:(BOOL)isSender
{
    [super configerIsSender:isSender];
    
    if (isSender) {
       //头像在右边
        CGRect frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame)-2-CGRectGetWidth(self.messageLable.bounds)-20,
                                  10,
                                  CGRectGetWidth(self.messageLable.bounds)+20,
                                  CGRectGetHeight(self.messageLable.bounds)+20);
        
        self.bubbleImageView.frame = frame;
    }else{
        //头像在左边
        CGRect frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+5,
                                  10,
                                  CGRectGetWidth(self.messageLable.bounds)+20,
                                  CGRectGetHeight(self.messageLable.bounds)+20);
        self.bubbleImageView.frame =frame;
    }
}


-(YYLabel *)messageLable
{
    if (!_messageLable)
    {
        _messageLable = [[YYLabel alloc]init];
        _messageLable.numberOfLines = 0;
    }
    return _messageLable;
}

/**
 * 如果存在网址 点击网址的情况
 */
-(void)clickUrl:(NSString *)urlStr
{
    
    NSLog(@"点击了网址---| %@",urlStr);
}

-(void)longGesstureAction:(UILongPressGestureRecognizer *)longGessture
{
    [self becomeFirstResponder];
    if (longGessture.state == UIGestureRecognizerStateBegan)
    {
        UIMenuController *menuControl = [UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
//        UIMenuItem *backItem = [[UIMenuItem alloc]initWithTitle:@"撤销" action:@selector(backAction:)];
        
         UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];

        menuControl.menuItems = @[deleteItem,
//                                  backItem,
                                  copyItem
                                  ];
        [menuControl setTargetRect:self.messageLable.frame inView:self.bubbleImageView];
        //设置显示
        [menuControl setMenuVisible:YES animated:YES];
    }
}
//删除
-(void)deleteAction:(id)sender
{
    
}
//撤回
-(void)backAction:(id)sender
{
    
}
//拷贝
-(void)copyAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.chatModel message];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
// 用于UIMenuController显示，缺一不可
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action ==@selector(deleteAction:) || action ==@selector(backAction:)||action == @selector(copyAction:)){
        return YES;
    }
    return NO;//隐藏系统默认的菜单项
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
