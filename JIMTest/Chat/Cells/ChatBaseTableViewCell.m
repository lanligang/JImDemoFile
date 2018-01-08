//
//  ChatBaseTableViewCell.m
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatBaseTableViewCell.h"

@implementation ChatBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.headerImageView];
        
        [self.contentView addSubview:self.bubbleImageView];
        //添加点击头像的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderImageViewAction:)];
        
        [self.headerImageView addGestureRecognizer:tap];
        
        [self configerIsSender:NO];
        [self.contentView addSubview:self.readStateLable];
    }
    return self;
}

//重写 set方法
-(void)setChatModel:(id)chatModel
{
    _chatModel= chatModel;
    [self configerWithModel:chatModel];
}

//子类调用   设置基类方法 在子类中使用
-(void)configerWithModel:(id)chatModel
{
    /**
     * 也可以在子类中直接使用不过需要 写
     * [super configerWithModel:chatModel];
     */
    _chatModel= chatModel;
}

-(void)tapHeaderImageViewAction:(UITapGestureRecognizer *)tap
{
    
}

-(void)setHeaderRaduis:(CGFloat)headerRaduis
{
    self.headerImageView.layer.cornerRadius = headerRaduis;
    self.headerImageView.clipsToBounds = YES;
}
/**
 *  这里只是修改图片 而不去对图片frame 进行修改
 */
-(void)configerIsSender:(BOOL)isSender
{
    //设置拉伸图片的参数
    UIEdgeInsets edge=UIEdgeInsetsMake(20, 10, 10,10);
    if (isSender)
    {
    //当前是发送者
        self.bubbleImageView.image = [[UIImage loadChatImg:@"chat_bubble_send_nor@3x.png"]resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        self.headerImageView.image = [UIImage loadChatImg:@"header_right.jpeg"];
    }else {
    //不是发送者  设置图片
    self.bubbleImageView.image = [[UIImage loadChatImg:@"chat_bubble_recive_press@3x.png"]resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        self.headerImageView.image = [UIImage loadChatImg:@"header_left.jpg"];
    }
    [self changeHeaderImageViewFrame:isSender];
}
//修改头像的Frame 是否是左边
-(void)changeHeaderImageViewFrame:(BOOL)right
{
    /**
     * 头像共占 60 *60  宽度 45*45  最小高度 60+上面高度 5 +下面高度 5 = 70 高度
     * 在左边  60-25 = 15 /2 = 7.5 宽度
     * 在右边 也是  7.5  屏幕宽度 - 7.5  距离上边位置为 5.0
     */
    CGFloat width  = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    CGFloat leftSpace = 7.5f;
    
    CGFloat topHeight = 5.0f;
    
    CGFloat headerWidth = 45.0f;
    
    CGRect frame = CGRectZero;
    if (right) {
        frame = CGRectMake(width-leftSpace-headerWidth, topHeight, headerWidth, headerWidth);
    }else{
        frame = CGRectMake(leftSpace, topHeight, headerWidth, headerWidth);
    }
    _headerImageView.frame = frame;
    _headerImageView.layer.cornerRadius = headerWidth/2.0f;
}

-(UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

-(UIImageView *)bubbleImageView
{
    if (!_bubbleImageView)
    {
        _bubbleImageView = [[UIImageView alloc]init];
        _bubbleImageView.userInteractionEnabled = YES;
    }
    return _bubbleImageView;
}

-(UILabel *)nickNameLable
{
    if (!_nickNameLable)
    {
        _nickNameLable = [[UILabel alloc]init];
    }
    return _nickNameLable;
}


-(UILabel *)readStateLable
{
    if (!_readStateLable)
    {
        _readStateLable = [[UILabel alloc]init];
        _readStateLable.font = [UIFont systemFontOfSize:8.0f];
        _readStateLable.textColor = [UIColor redColor];
    }
    return _readStateLable;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
