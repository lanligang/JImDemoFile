//
//  UIImage+ChatImageLoader.m
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "UIImage+ChatImageLoader.h"

@implementation UIImage (ChatImageLoader)


+(UIImage *)loadChatImg:(NSString *)name
{
    return [self loadImageWithBundle:@"chat_ios"
                         andFileName:@"Image"
                        andImageName:name
            ];
}

+(UIImage *)loadImageWithBundle:(NSString *)bundleName
                    andFileName:(NSString *)fileName
                   andImageName:(NSString *)imageName
{
 
    NSString *bundle = [NSString stringWithFormat:@"%@.bundle/%@/%@",bundleName,fileName,imageName];
    
   return  [UIImage imageNamed:bundle];
}




@end
