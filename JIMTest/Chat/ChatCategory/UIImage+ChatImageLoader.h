//
//  UIImage+ChatImageLoader.h
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChatImageLoader)

/**
 * 载入聊天图片chat_ios.bundle 
 */
+(UIImage *)loadChatImg:(NSString *)name;

/**
 * bundleName bundle名称
 * fileName   文件名
 * imageName  图片名称
 */
+(UIImage *)loadImageWithBundle:(NSString *)bundleName
                    andFileName:(NSString *)fileName
                   andImageName:(NSString *)imageName;



@end
