//
//  VoiceHud.h
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    RecorderVoiceType,
    DeleteVoiceType,
} RecoderType;


@interface VoiceHud : UIView
    //设置该值
@property(nonatomic,assign)RecoderType recorderType;
+(instancetype)show;

-(void)volumeMeters:(CGFloat)value;

-(void)hidden;
    
@end
