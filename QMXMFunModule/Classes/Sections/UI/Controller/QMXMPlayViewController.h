//
//  QMXMPlayViewController.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMBaseViewController.h"
#import "DeviceObject.h"
#import "QMUserModel.h"
#import "QMTempleteModel.h"
#import "QMXMSnapshotsView.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^ReportHandlerBlock)(NSArray <QMUserModel*> *selectedUsers);
typedef void(^ChooseTempleteBlock)(NSString *templeteID, NSString* param, NSArray <QMScoreItemModel*> *selectedGrads);
typedef void(^ReportCommitComplete)(void);


@interface QMXMPlayViewController : QMBaseViewController
@property(nonatomic, strong) DeviceObject *deviceObj;
@property(nonatomic, strong) ChannelObject* selectedChannel;
@property(nonatomic, copy) NSString * shopID;
@property(nonatomic, strong) QMXMSnapshotsView* snapshotsView;
@property(nonatomic, assign) NSInteger photoEditIndex;

/// 跳转到选择处理人页面
/// @param org 组织ID
/// @param users 已经选中的用户
/// @param saveBlock 右上角保存按钮的回调
- (void)pushReportHandlerVCWithOrg:(NSString *)org
                     selectedUsers:(NSArray<QMUserModel*> *)users
                          callBack:(ReportHandlerBlock)saveBlock;



/// 跳转到选择评分模版页面
/// @param org 组织ID
/// @param templeteID 已经选中模版ID
/// @param selectedGrads 已经选中评分项
/// @param saveBlock 右上角保存按钮的回调
- (void)pushChooseTempleteVCOrg:(NSString *)org
             selectedTempleteID:(nullable NSString *)templeteID
                  selectedGrads:(nullable NSArray <QMScoreItemModel*>*)selectedGrads callBack:(ChooseTempleteBlock)saveBlock;


///  提交巡店模版
/// @param vc 当前控制器
/// @param org 当前组织
/// @param handler 选中的处理人
/// @param problem 输入的文本
/// @param templeteId 选中的模版ID
/// @param grades 模版内容字符串
/// @param score 得分
/// @param images 图片数组
/// @param completeBlock 完成回调
- (void) commitScanShopTempleteVC:(UIViewController *)vc
                              org:(NSString *)org
                          handler:(NSString *)handler
                          problem:(NSString *)problem
                       templeteId:(NSString *)templeteId
                           grades:(NSString *)grades
                            score:(int)score
                           images:(NSArray <UIImage*>*)images
                    completeBlock:(ReportCommitComplete)completeBlock;

- (void)photoEditWithImg:(UIImage *)currentImage;

- (void)toPlayBackVC;
@end

NS_ASSUME_NONNULL_END
