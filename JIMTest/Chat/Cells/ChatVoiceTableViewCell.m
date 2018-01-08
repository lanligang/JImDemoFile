//
//  ChatVoiceTableViewCell.m
//  JIMTest
//
//  Created by Macx on 2017/12/3.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatVoiceTableViewCell.h"
#import "CDPAudioRecorder.h"

@interface ChatVoiceTableViewCell ()

@end

@implementation ChatVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
 self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 if (self)
 {
   [self.contentView addSubview:self.voiceWavesImgView];
     
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ontapAction:)];
     
   self.bubbleImageView.userInteractionEnabled = YES;
     
   [self.bubbleImageView addGestureRecognizer:tap];
     
   UILongPressGestureRecognizer *longGessture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesstureAction:)];
     
   [self.bubbleImageView addGestureRecognizer:longGessture];
 
 }
 return self;
}

-(void)longGesstureAction:(UILongPressGestureRecognizer *)longGessture
{
 [self becomeFirstResponder];
 
 if (longGessture.state == UIGestureRecognizerStateBegan) {
 UIMenuController *menuControl = [UIMenuController sharedMenuController];
 
  UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
  UIMenuItem *backItem = [[UIMenuItem alloc]initWithTitle:@"撤销" action:@selector(backAction:)];
  
  menuControl.menuItems = @[deleteItem,
									 backItem
									 ];
  [menuControl setTargetRect:self.bubbleImageView.frame inView:self.contentView];
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
-(BOOL)canBecomeFirstResponder{
 
 return YES;
 
}
 // 用于UIMenuController显示，缺一不可
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
 
 if (action ==@selector(backAction:) || action ==@selector(deleteAction:)){
  
  return YES;
  
 }
 return NO;//隐藏系统默认的菜单项
}

-(void)ontapAction:(UITapGestureRecognizer *)tap
{
 if (tap.state==UIGestureRecognizerStateEnded)
 {
   ChatBaseModel *model = self.chatModel;
 if (model.isSender) {
   [[CDPAudioRecorder shareRecorder]playAudioWithUrl:model.voiceLocalPath];
 }else{
  //下载 后播放
 }
 }
}
-(void)configerWithModel:(id)chatModel
{
 [super configerWithModel:chatModel];
 ChatBaseModel *model = chatModel;
 //设置是否是发送者
 [self configerIsSender:model.isSender];

 CGRect frame = CGRectZero;
 if (model.isSender)
  {
   frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame)-2-model.voiceImageWidth-20,
							10,
							model.voiceImageWidth+20,
							40.0f);
  self.voiceWavesImgView.image = [UIImage loadChatImg:@"voice_right@3x.png"];
  self.voiceWavesImgView.frame = CGRectMake(CGRectGetMaxX(frame)-35, 15, 30, 25);
  }else{
	 //头像在左边
	frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+5,
									  10,
									  model.voiceImageWidth+20,
									  40.0f);
	 self.voiceWavesImgView.image = [UIImage loadChatImg:@"voice_left@3x.png"];
     self.voiceWavesImgView.frame = CGRectMake(CGRectGetMinX(frame)+5, 15, 30, 25);
  }
 self.bubbleImageView.frame = frame;
}

-(UIImageView *)voiceWavesImgView
{
 if (_voiceWavesImgView==nil)
  {
  _voiceWavesImgView = [[UIImageView alloc]init];
  }
 return _voiceWavesImgView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
