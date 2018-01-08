//
//  VoiceHud.m
//  JIMTest
//
//  Created by ios2 on 2017/11/29.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "VoiceHud.h"
#import "VolumeMetersView.h"

@interface VoiceHud()
    {
        //按的时长 单位 s
        NSInteger  _progressTimes;
        //定时器
        NSTimer *  _timer;

    }
@property (nonatomic,strong)UIImageView * voiceImageView;
@property (nonatomic,strong)UILabel * bottomTxtLable;
@property (nonatomic,strong)UILabel *timeLable;
@property (nonatomic,strong)VolumeMetersView * volumeMetersView;

    
@end


@implementation VoiceHud
    
    
    +(instancetype)show
    {
        VoiceHud *hud = [[VoiceHud alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
 
      UIWindow * window =   [[UIApplication sharedApplication].delegate window];
        hud.center = window.center;
        [window addSubview:hud];
        return hud;
    }
    
    -(instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self){
            [self addSubview:self.voiceImageView];
            
            _voiceImageView.bounds = CGRectMake(0, 0, 40.0f, 60);
            _voiceImageView.contentMode = UIViewContentModeScaleAspectFit;
            _voiceImageView.center = CGPointMake(CGRectGetWidth(frame)/2.0f, 60.0f/2.0f+15.0f);
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
            [self addSubview:self.bottomTxtLable];
            _bottomTxtLable.frame = CGRectMake(10.0f, CGRectGetMaxY(_voiceImageView.frame)+20.0f, CGRectGetWidth(frame)-20.0f, 20.0f);
            _bottomTxtLable.text = @"手指上滑取消发送";
            self.layer.cornerRadius = 5.0f;
            self.clipsToBounds = YES;
            
            [self addSubview:self.timeLable];
            
            _timeLable.frame =CGRectMake(0, CGRectGetMaxY(_voiceImageView.frame)+5, CGRectGetWidth(frame), 10.0f);
            
           _timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer fire];
            _progressTimes = -10;
            _volumeMetersView = [[VolumeMetersView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomTxtLable.frame), CGRectGetWidth(frame), CGRectGetHeight(frame)-CGRectGetMaxY(_bottomTxtLable.frame))];
            
            [self addSubview:self.volumeMetersView];
            
            
        }
        return self;
    }
    -(void)onTime:(id)sender
    {
        _progressTimes +=10;
        _timeLable.text = [self secondToTime];
        
    }
    -(void)hidden
    {
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview];
    }
    
    -(UIImageView *)voiceImageView
    {
        if (!_voiceImageView)
        {
            _voiceImageView = [[UIImageView alloc]init];
            _voiceImageView.image = [UIImage imageNamed:@"com_icon_record"];
        }
        return _voiceImageView;
    }
    
 
    -(UILabel *)bottomTxtLable
    {
        if (!_bottomTxtLable)
        {
            _bottomTxtLable = [[UILabel alloc]init];
            _bottomTxtLable.font = [UIFont systemFontOfSize:12.0f];
            _bottomTxtLable.textColor = [UIColor whiteColor];
            _bottomTxtLable.textAlignment = NSTextAlignmentCenter;
            _bottomTxtLable.layer.cornerRadius = 3.0f;
            _bottomTxtLable.clipsToBounds = YES;
        }
        return _bottomTxtLable;
    }
    
    -(UILabel *)timeLable
    {
        if (!_timeLable)
        {
            _timeLable = [[UILabel alloc]init];
            _timeLable.font = [UIFont systemFontOfSize:10.0f];
            _timeLable.textColor = [UIColor whiteColor];
            _timeLable.textAlignment = NSTextAlignmentCenter;
            _timeLable.clipsToBounds = YES;
        }
        return _timeLable;
    }

    -(void)setRecorderType:(RecoderType)recorderType
    {
        switch (recorderType) {
            case RecorderVoiceType:
               _bottomTxtLable.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
                _voiceImageView.image = [UIImage imageNamed:@"com_icon_record"];
                _bottomTxtLable.text = @"手指上滑取消发送";
            break;
            case DeleteVoiceType:
                _bottomTxtLable.text = @"松开手指取消发送";
                 _bottomTxtLable.backgroundColor = [UIColor redColor];
                _voiceImageView.image = [UIImage imageNamed:@"com_icon_record_cancel"];
            break;
        }
    }

    -(NSString *)secondToTime
    {
        NSInteger   minutes =  (_progressTimes)/(60*100);

        NSInteger second = (_progressTimes -minutes*60*100) /100;
        
        NSInteger f      =(_progressTimes)-second*100-minutes*60*100;
        NSString *timeStr = nil;
        if (minutes<=0&&second<=0) {
            timeStr = [NSString stringWithFormat:@"%ld‘",(long)f];
        }else if (minutes<=0){
            timeStr  = [NSString stringWithFormat:@"%ld:%ld‘",(long)second,(long)f];
        }else{
            timeStr  = [NSString stringWithFormat:@"%ld:%ld:%ld‘",(long)minutes,(long)second,(long)f];
        }
        
        return timeStr;
        
    }


-(void)volumeMeters:(CGFloat)value{
    //更新hud 上面的音量大小
    [_volumeMetersView changeVoiceValue:value];
    
    
}
    
@end
