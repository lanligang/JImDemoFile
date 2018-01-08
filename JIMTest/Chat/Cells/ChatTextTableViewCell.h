//
//  ChatTextTableViewCell.h
//  JIMTest
//
//  Created by ios2 on 2017/12/1.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

/**
 * 聊天文字类型的气泡
 */

#import "ChatBaseTableViewCell.h"

@interface ChatTextTableViewCell : ChatBaseTableViewCell

//这里我们用YYLable来实现 ------

@property (nonatomic,strong)YYLabel *messageLable;


@end
