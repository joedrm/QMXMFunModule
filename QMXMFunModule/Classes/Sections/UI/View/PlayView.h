//
//  PlayView.h
//  XMEye
//
//  Created by XM on 2018/7/21.
//  Copyright © 2018年 Megatron. All rights reserved.
//

/******
 *
 *播放窗口界面view
 *如果想要自定义这个类，那么必须要有 +(Class)layerClass 方法
 *
 */

#import <UIKit/UIKit.h>
#import "RecordInfo.h"

@protocol QMPlayViewDelegate <NSObject>

#pragma mark - 点击云台控制的按钮
-(void)controlPTZBtnTouchDownAction:(int)sender;

#pragma mark - 抬起云台控制的按钮
-(void)controlPTZBtnTouchUpInsideAction:(int)sender;

#pragma mark - 播放/暂停
-(void)controlPlayAction:(UIButton *)sender;

#pragma mark - 全屏
-(void)fullScreenAction;

- (void)seekPlay: (float)value;
@end

@interface PlayView : UIView

@property (strong, nonatomic) UIButton *fullScreenBtn;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;  // 加载状态图标
@property (nonatomic, strong) NSDate *date;
@property (nonatomic,strong) NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame playBack:(BOOL)playBack;
#pragma mark  刷新界面图标
- (void)refreshView:(int)index;
- (void)playViewBufferIng; //正在缓冲
- (void)playViewBufferEnd;//缓冲完成
- (void)playViewBufferStop;//预览失败

@property (nonatomic,weak) id <QMPlayViewDelegate> delegate;

- (void) setEndTimeLabelTitle: (NSDate *)date;
-(void)refreshTimeAndProgress:(int)timeInfo;
-(void)refreshProgressWithSearchResult:(NSMutableArray*)array;
- (void)refreshPlayProgressByRecordFile:(RecordInfo *)record;
@end
