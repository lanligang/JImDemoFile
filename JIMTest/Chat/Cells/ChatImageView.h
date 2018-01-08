//
//  ChatImageView.h
//  JIMTest
//
//  Created by ios2 on 2017/12/6.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatImageView : UIImageView


@property (nonatomic,copy)void(^didSeletedAction)(id sender);


-(void)configerWithImageSize:(CGSize)size andIsRight:(BOOL)isRight;

@end
