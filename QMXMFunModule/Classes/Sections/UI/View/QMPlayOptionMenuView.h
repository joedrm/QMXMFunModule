//
//  QMPlayOptionMenuView.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum QMXMControlType{ //工具栏类型
    //视频预览功能
    QM_CONTROL_REALPLAY_SNAP = 2000, // 抓拍
    QM_CONTROL_REALPLAY_STREAM, //切换码流
    QM_CONTROL_REALPLAY_TALK, // 对讲
    QM_CONTROL_REALPLAY_VIDEO, // 录像回放
    QM_CONTROL_REALPLAY_CHANNLE, // 通道1
    
    
    
    //回放
    QM_CONTROL_TYPE_STOP = 3000,
    QM_CONTROL_TYPE_VOICE,
    QM_CONTROL_TYPE_SPEED,
    QM_CONTROL_TYPE_CAPTURE,
    QM_CONTROL_TYPE_RECORD,
    //全屏预览
    QM_CONTROL_FULLREALPLAY_PAUSE = 4000,
    QM_CONTROL_FULLREALPLAY_VOICE,
    QM_CONTROL_FULLREALPLAY_SNAP,
    QM_CONTROL_FULLREALPLAY_VIDEO,
    QM_CONTROL_FULLREALPLAY_REFRESH,
    QM_CONTROL_FULLREALPLAY_PTZ,
    //全屏回放
    QM_FUNCTIONENUM_FULLPLAYBACK_CLOSECHANNLE = 5000,
    QM_FUNCTIONENUM_FULLPLAYBACK_VOIDE,
    QM_FUNCTIONENUM_FULLPLAYBACK_SPEED,
    QM_FUNCTIONENUM_FULLPLAYBACK_SNAP,
    QM_FUNCTIONENUM_FULLPLAYBACK_VIDEO
    
}QMXMControlType;

//当前的播放类型
typedef enum QMXMPlayMode{
    QM_REALPLAY_MODE = 0,              //实时预览
    QM_PLAYBACK_MODE,                  //远程回放
    QM_FULL_SCREEN_REALPLAY_MODE,      //全屏实时预览
    QM_FULL_SCREEN_PLAYBACK_MODE,      //全屏远程回放
}QMXMPlayMode;

@protocol QMPlayOptionMenuViewDelegate <NSObject>
@optional
-(void)btnClickWithIndex:(QMXMControlType)controlType;

//双向对讲
- (void)startDouTalk;
- (void)stopDouTalk;
@end

@interface QMPlayOptionMenuView : UIView
@property (nonatomic,weak) id <QMPlayOptionMenuViewDelegate> delegate;
@property (nonatomic) QMXMPlayMode playMode;

- (void) changeChannelName:(NSString *)channelName;
@end

NS_ASSUME_NONNULL_END
