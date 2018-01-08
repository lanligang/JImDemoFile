//
//  ChatImageTableViewCell.m
//  JIMTest
//
//  Created by ios2 on 2017/12/6.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatImageTableViewCell.h"
#import "MSSBrowseLocalViewController.h"

@implementation ChatImageTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.bubbleImageView addSubview:self.chatImageView];
        //点击 图片时候
        __weak ChatImageTableViewCell *weakSelf = self;
        [_chatImageView setDidSeletedAction:^(id sender) {
            ChatBaseModel *model = weakSelf.chatModel;
            JMSGImageContent *imageContaint = (JMSGImageContent *)model.jMessage.content;
            [imageContaint largeImageDataWithProgress:^(float percent, NSString *msgId) {
                //加载大图的进度
                
            } completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
                            browseItem.bigImage = image;// 大图赋值
                            browseItem.smallImageView = weakSelf.chatImageView;// 小图
                    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:@[browseItem] currentIndex:0];
                    [bvc showBrowseViewController];
                }
            }];
        }];
    }
    return self;
}

-(void)configerWithModel:(id)chatModel
{
    [super configerWithModel:chatModel];
    ChatBaseModel *model = chatModel;
    //设置是否是发送者
    [self configerIsSender:model.isSender];
    //图片的内容
    JMSGImageContent *imageContaint = (JMSGImageContent *)model.jMessage.content;
    
    __weak ChatImageTableViewCell *weakSelf = self;
    
    [imageContaint thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error) {
            self.chatImageView.image = [UIImage loadChatImg:@"load_error_img@3x.png"];
        }else{
            weakSelf.chatImageView.image = [UIImage imageWithData:data];
        }
    }];
    
    CGSize imgSize = imageContaint.imageSize;
    //现在让图片的宽度为屏幕宽度的三分之一
    CGFloat imageWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/3.0f;
    CGFloat imageHeight = imageWidth*imgSize.height/imgSize.width;
    CGRect frame = CGRectZero;
    if (model.isSender)
    {
        frame = CGRectMake(CGRectGetMinX(self.headerImageView.frame)-2-imageWidth,
                           10,
                           imageWidth,
                           imageHeight+20);
        self.chatImageView.frame = CGRectMake(0, 5, imageWidth, imageHeight);
        [self.chatImageView configerWithImageSize:(CGSize){imageWidth,imageHeight} andIsRight:model.isSender];
    }else{
        //头像在左边
        frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+5,
                           10,
                           imageWidth,
                           imageHeight+20);
       self.chatImageView.frame = CGRectMake(0, 5, imageWidth, imageHeight);
       [self.chatImageView configerWithImageSize:(CGSize){imageWidth,imageHeight} andIsRight:model.isSender];
    }
    self.bubbleImageView.image = nil;
    self.bubbleImageView.frame = frame;
}

-(UIImageView *)chatImageView
{
    if (!_chatImageView)
    {
        _chatImageView = [[ChatImageView alloc]init];
    }
    return _chatImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
