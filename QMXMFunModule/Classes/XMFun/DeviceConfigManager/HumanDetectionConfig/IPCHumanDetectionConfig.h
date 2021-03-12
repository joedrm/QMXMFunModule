//
//  IPCHumanDetectionConfig.h
//  FunSDKDemo
//
//  Created by zhang on 2019/7/4.
//  Copyright © 2019 zhang. All rights reserved.
//

/******
* 人形检测配置 IPC
* 需要先获取能力级，判断是否支持人形检测  SystemFunction.AlarmFunction.PEAInHumanPed
 *****/
@protocol IPCHumanDetectionDelegate <NSObject>

@optional
//获取能力级回调信息
- (void)IPCHumanDetectionConfigGetResult:(NSInteger)result;
//设置人形检测开关回调
- (void)IPCHumanDetectionConfigSetResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPCHumanDetectionConfig : ConfigControllerBase

@property (nonatomic, assign) id <IPCHumanDetectionDelegate> delegate;

//检查数据是否有效
- (BOOL)checkConfig;

#pragma mark - 获取人形检测配置
- (void)getHumanDetectionConfig;

#pragma mark - 读取人形检测报警功能开关状态
-(int)getHumanDetectEnable;
#pragma mark 读取人形检测报警轨迹开关状态
-(int)getHumanDetectShowTrack;
#pragma mark 读取人形检测报警规则开关状态
-(int)getHumanDetectShowRule;

#pragma mark - 设置人形检测报警功能开关状态
-(void)setHumanDetectEnable:(int)enable;
#pragma mark 设置人形检测报警轨迹开关状态
-(void)setHumanDetectShowTrack:(int)ShowTrack;
#pragma mark 设置人形检测报警规则开关状态
-(void)setHumanDetectShowRule:(int)showrule;
@end

NS_ASSUME_NONNULL_END
