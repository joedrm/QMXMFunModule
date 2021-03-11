//
//  TalkBackControl.h
//  XMEye
//
//  Created by XM on 2017/6/6.
//  Copyright © 2017年 Megatron. All rights reserved.
//
/***
 
 视频预览时的对讲功能控制器，继承自 FunMsgListener
 *手机端听筒播放和扬声器播放选择需要根据自己的情况进行选择修改
* 对讲功能和双向对讲功能同一时间只能打开一个
 *
 *对讲功能说明
 *  1、打开对讲前需要先关闭音频  FUN_MediaSetSound(_handle, 0, 0);
 *  2、按下开始对讲时，除了对讲接口，还需要关闭音频 FUN_MediaSetSound(_hTalk, 0, 0);
 *  3、松开对讲时，除了对讲接口，还需要打开音频 FUN_MediaSetSound(_hTalk, 100, 0);
 *   4、关闭对讲时，除了关闭对讲接口，还需要关闭音频  FUN_MediaSetSound(_hTalk, 0, 0);
 *
 *
 FUN_MediaSetSound 参数说明：
 第一个参数是播放或者对讲句柄，关闭视频音频时需要传入视频播放句柄，关闭对讲音频时需要传入对讲句柄。
 第二个参数是音量，1～100为打开，0为关闭音频。
 第三个参数默认为0
 FUN_MediaSetSound(_handle, 0, 0);
 *
 *****/

#import "FunMsgListener.h"
#import "Recode.h"
@interface TalkBackControl : FunMsgListener
{
    Recode *_audioRecode;
    int _hTalk;
}

@property (nonatomic, strong) NSString *deviceMac;
@property (nonatomic) int channel;
@property (nonatomic) int handle;

#pragma mark - 单向对讲
//开始对讲，停止音频
-(void)startTalk;
//松开停止对讲，播放音频
-(void)pauseTalk;
- (void)closeTalk;//关闭对讲
 //(对讲和双向对讲同时只能打开一个)
#pragma mark - 双向对讲 (双向对讲最好做一下手机端的回音消除工作，demo中并没有做这个)
- (void)startDouTalk;
- (void)stopDouTalk;
@end
