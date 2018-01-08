//
//  TL_MACRO.h
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#ifndef TL_MACRO_h
#define TL_MACRO_h

#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define APPDELEGETE         ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#pragma mark - Frame
#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height


#define HEIGHT_NAVBAR       44 // 导航

#define HEIGHT_CHATBOXVIEW  215// 更多 view

#pragma mark - Color
#define     DEFAULT_NAVBAR_COLOR             WBColor(20.0, 20.0, 20.0, 0.9)
#define     DEFAULT_BACKGROUND_COLOR         WBColor(239.0, 239.0, 244.0, 1.0)

#define     DEFAULT_CHAT_BACKGROUND_COLOR    WBColor(235.0, 235.0, 235.0, 1.0)
#define     DEFAULT_CHATBOX_COLOR            WBColor(244.0, 244.0, 246.0, 1.0)
#define     DEFAULT_SEARCHBAR_COLOR          WBColor(239.0, 239.0, 244.0, 1.0)
#define     DEFAULT_GREEN_COLOR              WBColor(2.0, 187.0, 0.0, 1.0f)
#define     DEFAULT_TEXT_GRAY_COLOR         [UIColor grayColor]
#define     DEFAULT_LINE_GRAY_COLOR          WBColor(188.0, 188.0, 188.0, 0.6f)

#define     PATH_DOCUMENT                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define     PATH_CHATREC_IMAGE              [PATH_DOCUMENT stringByAppendingPathComponent:@"ChatRec/Images"]

//获取当前顶部高度
#define HEIGHT_STATUSBAR  [[UIApplication sharedApplication] statusBarFrame].size.height

#define NavBarHeight 44.0

#define HEIGHT_TABBAR  ([[UIApplication sharedApplication] statusBarFrame].size.height>30?83:49)


#define TopHeight (HEIGHT_STATUSBAR + NavBarHeight)




#endif /* TL_MACRO_h */
