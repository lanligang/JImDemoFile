//
//  ChatBaseModel.m
//  JIMTest
//
//  Created by ios2 on 2017/12/1.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatBaseModel.h"
#import <YYText.h>

#import "ChatFace.h"
//用来加载表情的
#import "ChatFaceHeleper.h"

@implementation ChatBaseModel

-(void)setMessage:(NSString *)message
{
    _message = message;
    self.messageType = TextType;
    if (_message)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_message];
        text.yy_font = [UIFont systemFontOfSize:16.0f];
	 //设置行间距
	     text.yy_lineSpacing  = 8.0f;
        text.yy_color = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        NSError *error;
        NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        //检测是否带有网址  设置网页蓝色
        NSArray *arrayOfAllMatches=[dataDetector matchesInString:_message options:NSMatchingReportProgress range:NSMakeRange(0, _message.length)];
        __weak ChatBaseModel* weakSelf = self;
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
              [text yy_setTextHighlightRange:match.range
                                         color:[UIColor blueColor]
                               backgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]
                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                         //调用点击网址的位置
                                         [weakSelf clickUrl:[_message substringWithRange:range]];
                                     }];
        }
        //检测 表情
        NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
        NSError *emojiError = nil;
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&emojiError];
        if (re) {
            NSArray *resultArray = [re matchesInString:_message options:0 range:NSMakeRange(0, text.length)];
            //3、获取所有的表情以及位置
            //用来存放字典，字典中存储的是图片和图片对应的位置
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
            //根据匹配范围来用图片进行相应的替换
            for(NSTextCheckingResult *match in resultArray) {
                //获取数组元素中得到range
                NSRange range = [match range];
                //获取原字符串中对应的值
                NSString *subStr = [_message substringWithRange:range];
                ChatFaceGroup   *group = [[[ChatFaceHeleper  sharedFaceHelper] faceGroupArray] objectAtIndex:0];
                for (ChatFace *face in group.facesArray) {
                    if ([face.faceName isEqualToString:subStr]) {
                        //把图片和图片对应的位置存入字典中
                        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                         UIImage *image =  [UIImage imageNamed:face.faceName];
                        if (image) {
                            [imageDic setObject:image forKey:@"image"];
                        }
                        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                        //把字典存入数组中
                        [imageArray addObject:imageDic];
                    }
                }
            }
            //4、从后往前替换，否则会引起位置问题
            for (int i = (int)imageArray.count -1; i >= 0; i--)
            {
                NSRange range;
                [imageArray[i][@"range"] getValue:&range];
                UIFont *font = [UIFont systemFontOfSize:14.0f];
                @try {
                UIImage *image = imageArray[i][@"image"];
                if (image)
                {
                 NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [text replaceCharactersInRange:range withAttributedString:attachText];
                }
                } @catch (NSException *exception) {
                    NSLog(@"----------|class %@  |%s line %d",self.class,__func__,__LINE__);
                }
            }
        }
        //在这里存储改值
        self.attributedStr = text;
        CGSize size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-130, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
        CGFloat height =   layout.textBoundingSize.height+30.0f;
        //如果比55小 是 55 高度
        if (height<55.0f)
        {
            height = 55.0f;
        }
    //记录文字的frame
        self.textFrame =  CGRectMake(10, 10, layout.textBoundingSize.width, layout.textBoundingSize.height);
        self.cellHeight = height;
    }
}
-(void)clickUrl:(NSString *)urlStr
{
    //点击了连接
    if (urlStr) {
        if (_clickedUrlBlock) {
            _clickedUrlBlock(urlStr);
        }
    }
}

//设置语音消息的时长 单位秒后面的参数
-(void)setVoiceDuration:(NSInteger)voiceDuration
{
    _voiceDuration = voiceDuration;
    
    self.messageType = voiceType;
    self.cellHeight = 52.0f;
 //屏幕宽度
    CGRect rect = [UIScreen mainScreen].bounds;
 //当前语音的最大宽度
    CGFloat maxWidth = CGRectGetWidth(rect)-100.0f;
 //最大1分40‘
   self.voiceImageWidth = voiceDuration/100.0f*maxWidth/60.0f;
 if (_voiceImageWidth<25.0f) {
    _voiceImageWidth = 25.0f;
 }
    
}

-(NSString *)timeString
{

       double  timeLine =  [self.jMessage.timestamp doubleValue];
        
        NSDate *date =   [NSDate dateWithTimeIntervalSince1970:timeLine/1000.0f];
        double sinceNowTimeLine =   [[NSDate date] timeIntervalSinceDate:date];
        
        NSDateFormatter *formart = [[NSDateFormatter alloc]init];
    
        if (sinceNowTimeLine>(12*3600-1))
        {
            [formart setDateFormat:@"MM月 dd日 HH:mm"];
        }else{
            [formart setAMSymbol:@"上午"];
            [formart setPMSymbol:@"下午"];
            [formart setDateFormat:@"aaa HH:mm"];
        }
       NSString *timeStr =  [formart stringFromDate:date];
    
    return  timeStr;
}

-(void)setMessageType:(MessageType)messageType
{
    _messageType = messageType;
    if (_messageType==timeLineType)
    {
        self.cellHeight = 35.0f;
    }else if (_messageType==photoType){
        JMSGImageContent *imageContent = (JMSGImageContent *)self.jMessage.content;
        CGSize imgSize = imageContent.imageSize;
        //现在让图片的宽度为屏幕宽度的三分之一
        CGFloat imageWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/3.0f;
        CGFloat imageHeight = imageWidth*imgSize.height/imgSize.width;
        self.cellHeight = imageHeight+20.0f;
    }
}

@end
