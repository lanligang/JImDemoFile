//
//  ChatTimeTableViewCell.m
//  JIMTest
//
//  Created by ios2 on 2017/12/5.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatTimeTableViewCell.h"

#import "ChatBaseModel.h"

@implementation ChatTimeTableViewCell{
    UILabel *_timeLable;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont systemFontOfSize:12.0f];
        _timeLable.textColor = [UIColor lightGrayColor];
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.clipsToBounds = YES;
        [self.contentView addSubview:_timeLable];
  

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _timeLable.center = self.contentView.center;
    _timeLable.bounds = self.bounds;
}

-(void)setModel:(id)model
{
    _model = model;
    ChatBaseModel *chatModel = model;
    _timeLable.text = chatModel.timeString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
