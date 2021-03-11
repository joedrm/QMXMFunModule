//
//  TalkBackControl.m
//  XMEye
//
//  Created by XM on 2017/6/6.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "TalkBackControl.h"

@implementation TalkBackControl

#pragma mark - 单向对讲
- (void)startTalk{
    if (_audioRecode == nil) {
        _audioRecode = [[Recode alloc] init];
    }
    [_audioRecode startRecode:self.deviceMac];
    //先停止音频
    FUN_MediaSetSound(_handle, 0, 0);
    if (_hTalk == 0) {
        //开始对讲
       _hTalk = FUN_DevStarTalk(self.msgHandle, [self.deviceMac UTF8String], FALSE, 0, 0);
    }
    //暂停设备端上传音频数据
    const char *str = "{\"Name\":\"OPTalk\",\"OPTalk\":{\"Action\":\"PauseUpload\"},\"SessionID\":\"0x00000002\"}";
    FUN_DevCmdGeneral(self.msgHandle, [self.deviceMac UTF8String], 1430, "PauseUpload", 0, 0, (char*)str, 0, -1, 0);
    //APP停止播放设备音频
    FUN_MediaSetSound(_hTalk, 0, 0);
}
- (void)pauseTalk{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_audioRecode != nil) {
            [_audioRecode stopRecode];
            _audioRecode = nil;
        }
        //恢复设备端上传音频数据
        const char *str = "{\"Name\":\"OPTalk\",\"OPTalk\":{\"Action\":\"ResumeUpload\"},\"SessionID\":\"0x00000002\"}";
        FUN_DevCmdGeneral(self.msgHandle, [self.deviceMac UTF8String], 1430, "ResumeUpload", 0, 0, (char*)str, 0, -1, 0);
        //app播放设备端音频
        FUN_MediaSetSound(_hTalk, 100, 0);
    });
}
//停止预览->停止对讲，停止音频
-(void)closeTalk{
    if (_hTalk != 0) {
        if (_audioRecode != nil) {
            [_audioRecode stopRecode];
            _audioRecode = nil;
        }
        if (_hTalk != 0) {
            FUN_DevStopTalk(_hTalk);
            FUN_MediaSetSound(_hTalk, 0, 0);
            _hTalk = 0;
        }else{
            FUN_MediaSetSound(_handle, 0, 0);
        }
    }
}

#pragma mark - 双向对讲 (双向对讲最好做一下手机端的回音消除工作，demo中并没有做这个)
- (void)startDouTalk {
    //先停止音频
    FUN_MediaSetSound(_handle, 0, 0);
    
    if (_audioRecode == nil) {
        _audioRecode = [[Recode alloc] init];
    }
    //APP手机音频上传
    [_audioRecode startRecode:self.deviceMac];
    
    if (_hTalk == 0) {
        //开始对讲
        _hTalk = FUN_DevStarTalk(self.msgHandle, [self.deviceMac UTF8String], FALSE, 0, 0);
    }
    //app播放设备端音频
    FUN_MediaSetSound(_hTalk, 100, 0);
}
- (void)stopDouTalk {
    [self closeTalk];
}
#pragma mark - 对讲开始结果回调
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_DEV_START_TALK: {//对讲失败
            if(_hTalk != 0 && msg->param1 != EE_OK){
                [MessageUI ShowErrorInt:msg->param1];
                _hTalk = 0;
            }else{
                
            }
        }
            break;
        case EMSG_DEV_STOP_TALK: {
            
        }
            break;
        default:
            break;
    }
}
- (BOOL)isSupportTalk{
    //鱼眼灯泡不支持对讲 其他都支持 所以先直接返回ture 后期修改语言灯泡对讲
    return YES;
}
@end
