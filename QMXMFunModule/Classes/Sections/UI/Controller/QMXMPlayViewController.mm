//
//  QMXMPlayViewController.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMPlayViewController.h"
#import "MediaplayerControl.h"
#import "PlayView.h"
#import "TalkBackControl.h"
#import "DeviceManager.h"
#import "DoorBellModel.h"
#import <Masonry/Masonry.h>
#import "QMPlayOptionMenuView.h"
#import "UIColor+LBECategory.h"
#import "UITextView+Placeholder.h"
#import "QMXMPlayTableViewCell.h"
#import "UIImage+QMCategory.h"
#import "QMXMPlayBackViewController.h"
#import "LPActionSheet.h"
#import "CGXStringPickerView.h"
#import "QMQuestionInputView.h"
#import "QMCommitButton.h"
#import "AuthorizationService.h"
#import "AlbumService.h"
#import "QMPhotoPickerService.h"
#import "QMCreateReportTool.h"
#import "QMToast.h"
#import "QMHud.h"
#import "QMLanchScreenTool.h"
#import "UIImage+QMCategory.h"
#import "SLScrollViewKeyboardSupport.h"
#import "QMToast.h"
#import "LFPhotoEditingController.h"

#define PlayViewNumberFour [[DeviceControl getInstance] getSelectChannelArray].count == 4 ? YES : NO
#define NSNumber_Four 4

@interface QMXMPlayViewController () <MediaplayerControlDelegate,QMPlayOptionMenuViewDelegate, UITableViewDelegate, UITableViewDataSource, QMPlayViewDelegate, LFPhotoEditingControllerDelegate>
{
    QMPlayOptionMenuView *toolView; // 工具栏
    MediaplayerControl  *mediaPlayer;//播放媒体工具，
    TalkBackControl *talkControl;//对讲工具
    PlayView *playView;
}
@property (nonatomic,assign) int msgHandle;
@property (nonatomic,assign) double orginalRatio;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tableDatas;
@property (nonatomic, strong) QMPhotoPickerService* service;
@property (nonatomic, strong) QMQuestionInputView* inputView;
@property (nonatomic, strong) QMCommitButton * commitBtn;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, strong) NSMutableArray <QMUserModel*>* users;
@property (nonatomic, strong) SLScrollViewKeyboardSupport *keyBoradsSupport;
@property (nonatomic, copy) NSString *selectedTempleteID;
@property (nonatomic, copy) NSString *templeteParam;
@property (nonatomic, strong) NSMutableArray <QMScoreItemModel*>* selectedGrads;
@end

@implementation QMXMPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFull = NO;
    self.msgHandle = FUN_RegWnd((__bridge void*)self);
    [self initUI];
    [self initDataSource];
    [self startRealPlay];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AlbumService sharedContactsService].isFull = false;
    [self setOrientationLandscape:[AlbumService sharedContactsService].isFull];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeSound];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (mediaPlayer != nil && mediaPlayer.status == MediaPlayerStatusPlaying) {
        [self openSound];
    }
}

- (void)dealloc
{
    NSLog(@"============== QMXMPlayViewController dealloc ==============");
    [self popViewController];
    
}

#pragma mark - 全屏处理

- (BOOL)shouldAutorotate{
    return YES;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
//    return YES;
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscapeRight |UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutWithDeviceOrientation:toInterfaceOrientation];
}

-(void)layoutWithDeviceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL isPortrait = YES;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || \
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        isPortrait = NO;
        //        playView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.height.mas_equalTo(self.view.mas_height);
            //            make.width.mas_equalTo(self.view.mas_width);
            make.edges.mas_equalTo(self.view);
        }];
    }else{
        isPortrait = YES;
        //        playView.frame = CGRectMake(0, 0, SCREEN_WIDTH, realPlayViewHeight);
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width);
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(NavHeight);
            make.height.mas_equalTo(realPlayViewHeight);
        }];
    }
    
    [self popDisable:!isPortrait];
    self.isFull = !isPortrait;
    self.commitBtn.hidden = !isPortrait;
    self.tableView.hidden = !isPortrait;
    self.navigationController.navigationBar.hidden = !isPortrait;
    
    //    [self.tableView reloadData];
    //    [UIViewController attemptRotationToDeviceOrientation];
    //    [self.view setNeedsUpdateConstraints];
    //    [self.view updateConstraintsIfNeeded];
    //
    if (isPortrait) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(NavHeight+realPlayViewHeight);
            make.bottom.mas_equalTo(self.commitBtn.mas_top);
        }];
    }
    
    //    [self.view setNeedsUpdateConstraints];
    //    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 开始播放视频
- (void)startRealPlay {
    [playView playViewBufferIng];
    [mediaPlayer start];
    //    [self openSound];
}

#pragma mark 切换码流
-(void)changeStreamType {
    //如果正在录像、对讲、播放音频，需要先停止这几项操作
    [self stopRecord];
    [self closeSound];
    [self stopTalk];
    //先停止预览
    [mediaPlayer stop];
    //切换主辅码流
    if (mediaPlayer.stream == 0) {
        mediaPlayer.stream = 1;
    }else if (mediaPlayer.stream == 1) {
        mediaPlayer.stream = 0;
    }
    //重新播放预览
    [mediaPlayer start];
    //    [self openSound];
}

#pragma mark 停止录像
- (void)stopRecord {
    if (mediaPlayer.record == MediaRecordTypeNone) {
        [mediaPlayer stopRecord];
    }
}
#pragma mark 停止播放音频
- (void)closeSound {
    if (mediaPlayer.voice == MediaVoiceTypeVoice){
        [mediaPlayer closeSound];
        mediaPlayer.voice = MediaVoiceTypeNone;
    }
}
#pragma mark 开始播放音频
- (void)openSound {
    if (mediaPlayer.voice == MediaVoiceTypeNone){
        [mediaPlayer openSound:100];
        mediaPlayer.voice = MediaVoiceTypeVoice;
    }
}
#pragma mark - 开始预览结果回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult  {
    if (result < 0) {
        if(result == EE_DVR_PASSWORD_NOT_VALID)//密码错误，弹出密码修改框
        {
            [SVProgressHUD dismiss];
            ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
            DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("EE_DVR_PASSWORD_NOT_VALID") message:channel.deviceMac preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = TS("set_new_psd");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UITextField *passWordTextField = alert.textFields.firstObject;
                DeviceManager *manager = [DeviceManager getInstance];
                //点击确定修改密码
                [manager changeDevicePsw:channel.deviceMac loginName:device.loginName password:passWordTextField.text];
                //开始播放视频
                [self startRealPlay];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [MessageUI ShowErrorInt:result];
    }else {
        if (dssResult == XM_NET_TYPE_DSS) { //DSS 打开视频成功
            
        }else if (dssResult == XM_NET_TYPE_RPS){//RPS打开预览成功
            
        }
        [playView playViewBufferIng];
        [self openSound];
        ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
        DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
        if (devObject.nType == XM_DEV_DOORBELL || devObject.nType == XM_DEV_CAT || devObject.nType == CZ_DOORBELL || devObject.nType == XM_DEV_INTELLIGENT_LOCK || devObject.nType == XM_DEV_DOORBELL_A || devObject.nType == XM_DEV_DOORLOCK_V2) {
            // 开始开启设备信息主动上报
            [[DoorBellModel shareInstance] beginUploadData:channel.deviceMac];
            // 设备信息上报回调
            [DoorBellModel shareInstance].DevUploadDataCallBack = ^(NSDictionary *state, NSString *devMac) {
                // state 个字段表示的意思
                //                    DevStorageStatus 表示存储状态： -2：设备存储未知 -1：存储设备被拔出 0：没有存储设备 1：有存储设备 2：存储设备插入
                //                    electable 表示充电状态：0：未充电 1：正在充电 2：电充满 3：未知（表示各数据不准确）
                //                    freecapacity = 0;
                //                    percent = "-1";
                
                NSLog(@"DoorBellModel %@",state);
            };
        }
    }
}

#pragma mark - 视频缓冲中
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering ratioDetail:(double)ratioDetail{
    if (isBuffering == YES) {//开始缓冲
        [playView playViewBufferIng];
    }else{//缓冲完成
        // 预览开始时抓张设备缩略图 当背景
        
        self.orginalRatio = ratioDetail;
        NSString* thumbnailPathName = [NSString devThumbnailFile:self.deviceObj.gatewayId andChannle:0];
        FUN_MediaGetThumbnail(mediaPlayer.player, thumbnailPathName.UTF8String,1);
        [playView playViewBufferEnd];
    }
}

#pragma mark 收到暂停播放结果消息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer pauseOrResumeResult:(int)result {
    if (result == 2) { //暂停预览
        mediaPlayer.status = MediaPlayerStatusPause;
        //        [toolView refreshFunctionView:CONTROL_FULLREALPLAY_PAUSE result:YES];
    }else if (result == 1){ //恢复预览
        mediaPlayer.status = MediaPlayerStatusPlaying;
        //        [toolView refreshFunctionView:CONTROL_FULLREALPLAY_PAUSE result:NO];
    }
}
#pragma mark - 录像开始结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //开始录像成功
        mediaPlayer.record = MediaRecordTypeRecording;
        
        //        [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:YES];
    }else{
        [MessageUI ShowErrorInt:result];
        //        [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
    }
}
#pragma mark - 录像结束结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //结束录像成功
        [SVProgressHUD showSuccessWithStatus:TS("Success") duration:2.0];
        [self closeSound];
    }else{
        [MessageUI ShowErrorInt:result];
    }
    //    [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
    mediaPlayer.record = MediaRecordTypeNone;
}

#pragma mark 抓图结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer snapImagePath:(NSString *)path result:(int)result {
    if (result == EE_OK) { //抓图成功
        [SVProgressHUD showSuccessWithStatus:TS("") duration:1.0];
        //        [snapshotsView reloadSnapshotData:self.snaps];
        [self.snapshotsView addPhotoWithFilePath:path];
    }else{
        [MessageUI ShowErrorInt:result];
    }
}

#pragma mark 收到视频宽高比信息
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width htight:(int)height {
    
}
#pragma mark -鱼眼视频预览相关处理 （非鱼眼设备可以不用考虑下列几个方法）
UIPinchGestureRecognizer *twoFingerPinch;//硬解码捏合手势
#pragma mark 用户自定义信息帧回调，通过这个判断是什么模式在预览
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer Hardandsoft:(int)Hardandsoft Hardmodel:(int)Hardmodel {
    //    if (Hardandsoft == 3 || Hardandsoft == 4 || Hardandsoft == 5) {
    //        //创建鱼眼预览界面
    //        [self mediaPlayer:mediaPlayer createFeye:Hardandsoft Hardmodel:Hardmodel];
    //    }
}
#pragma mark YUV数据回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer width:(int)width height:(int)height pYUV:(unsigned char *)pYUV {
    //    [[feyeArray objectAtIndex:mediaPlayer.index]  PushData:width height:height YUVData:pYUV];
}
#pragma mark - 设备时间（鱼眼）
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer DevTime:(NSString *)time {
    //    [[feyeArray objectAtIndex:mediaPlayer.index] setTimeLabelText:time];
}
#pragma mark 鱼眼软解坐标参数
-(void)centerOffSetX:(MediaplayerControl*)mediaPlayer  offSetx:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height {
    //    [[feyeArray objectAtIndex:mediaPlayer.index] centerOffSetX:OffSetx offY:OffSetY radius:radius width:width height:height];
}
#pragma mark 鱼眼画面智能分析报警自动旋转画面
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer AnalyzelLength:(int)length site:(int)type Analyzel:(char*)area {
    
}

#pragma mark - 预览对象初始化
- (void)initDataSource {
    //    if (feyeArray == nil) {
    //        feyeArray = [[NSMutableArray alloc] initWithCapacity:0];
    //    }
    ChannelObject *channel = self.deviceObj.channelArray.firstObject;
    self.selectedChannel = channel;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.deviceObj.shopName;
    
    mediaPlayer = [[MediaplayerControl alloc] init];
    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer.channel = channel.channelNumber;//当前通道号
    mediaPlayer.stream = 1;//辅码流
    mediaPlayer.renderWnd = playView;
    mediaPlayer.delegate = self;
    
    //初始化对讲工具，这个可以放在对讲开始前初始化
    talkControl = [[TalkBackControl alloc] init];
    talkControl.deviceMac = mediaPlayer.devID;
    talkControl.channel = mediaPlayer.channel;
    
    [toolView changeChannelName:channel.channelName];
    
    //    //鱼眼工具，非全景设备用不到这个
    //    FishPlayControl *feyeControl = [[FishPlayControl alloc] init];
    //    [feyeArray addObject:feyeControl];
    
    
}

#pragma mark - 界面初始化
- (void)initUI {
    
    self.users = [NSMutableArray array];
    
    
    UIView* headerView = [[UIView alloc] init];
    //    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, realPlayViewHeight + 75 + 100 + 42 +80);
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    PlayView *pView = [[PlayView alloc] initWithFrame:CGRectZero playBack:false];
    pView.activityView.center = pView.center;
    pView.frame = CGRectMake(0, 0, SCREEN_WIDTH, realPlayViewHeight);
    [pView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    playView = pView;
    pView.delegate = self;
    [self.view addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(realPlayViewHeight);
    }];
    
    
    QMPlayOptionMenuView* toolActionView = [[QMPlayOptionMenuView alloc] init];
    toolActionView.delegate = self;
    toolView = toolActionView;
    [headerView addSubview:toolActionView];
    [toolActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(0);
    }];
    
    QMXMSnapshotsView *xmsnapshotView = [[QMXMSnapshotsView alloc] init];
    self.snapshotsView = xmsnapshotView;
    [headerView addSubview:xmsnapshotView];
    __weak typeof(self) weakSelf = self;
    xmsnapshotView.callBack = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [QMKeyWindow endEditing:true];
        if (strongSelf.snapshotsView.snaps.count > 9) {
            return;
        }
        [LPActionSheet showActionSheetWithTitle:@"请选择照片或者拍照"
                              cancelButtonTitle:@"取消"
                         destructiveButtonTitle:@""
                              otherButtonTitles:@[@"照片", @"拍照"]
                                        handler:^(LPActionSheet *actionSheet, NSInteger index) {
            
            if (index == 1) {
                [strongSelf showPhotoPicker];
            }else if (index == 2){
                [strongSelf takePhoto];
            }else {
                
            }
        }];
    };
    xmsnapshotView.itemClicked = ^(UIImage * _Nonnull img, NSInteger index) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.photoEditIndex = index;
        [strongSelf photoEditWithImg:img];
    };
    [xmsnapshotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(toolActionView.mas_bottom).offset(10);
    }];
    
    
    QMQuestionInputView* inputView = [[QMQuestionInputView alloc] init];
    [headerView addSubview:inputView];
    self.inputView = inputView;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(xmsnapshotView.mas_bottom).offset(10);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(inputView.mas_bottom).offset(10);
    }];
    
    QMCommitButton * commitBtn = [QMCommitButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    self.commitBtn = commitBtn;
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(NavHeight+realPlayViewHeight);
        make.bottom.mas_equalTo(commitBtn.mas_top);
    }];
    
    self.keyBoradsSupport = [[SLScrollViewKeyboardSupport alloc] initWithScrollView:self.tableView];
}

- (void)setOrientationLandscape:(BOOL)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation?UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)fullScreen:(UIButton *)sender{
    [QMKeyWindow endEditing:true];
    [AlbumService sharedContactsService].isFull = YES;
    self.isFull = !self.isFull;
    [self setOrientationLandscape:self.isFull];
}


- (void)showPhotoPicker{
    if (![AuthorizationService isHavePhotoAuthor]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    QMPhotoPickerService* service = [QMPhotoPickerService createServiceSelectedImage:^(UIImage * _Nonnull selectedImage) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.snapshotsView addPhoto:selectedImage];
    }];
    [service presentWithVC:self];
    self.service = service;
}

- (void)takePhoto {
    if (![AuthorizationService isHaveCameraAuthor]) {
        return;
    }
    AlbumService* service = [AlbumService sharedContactsService];
    service.sType = UIImagePickerControllerSourceTypeCamera;
    __weak typeof(self) weakSelf = self;
    [service setCallBack:^(UIImage * _Nonnull image) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.snapshotsView addPhoto:image];
    }];
    [service showAlbumInViewController:self];
}

- (void) commitAction:(UIButton *)sender {
    
    NSString* inputText = self.inputView.textView.text;
    if (self.users.count <= 0 ) {
        [QMToast show:@"请选择处理人"];
        return;
    }
    QMUserModel* user = self.users.firstObject;
    QMTempleteModel* templete = [[QMTempleteModel alloc] init];
    int score = 0;
    for (QMScoreItemModel* sc in self.selectedGrads) {
        score += int(sc.score);
    }
//    __weak typeof(self) weakSelf = self;
    [self commitScanShopTempleteVC:self
                               org:self.shopID
                           handler:user.userId
                           problem:inputText
                        templeteId:self.selectedTempleteID
                            grades:self.templeteParam
                             score:score
                            images:self.snapshotsView.snaps
                     completeBlock:^{
//        __strong typeof(self) strongSelf = weakSelf;
//        [strongSelf backAction];
    }];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[QMXMPlayTableViewCell class] forCellReuseIdentifier:QMXMPlayTableViewCellReuseId];
        self.extendedLayoutIncludesOpaqueBars = true;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    return _tableView;
}


#pragma mark 初始化鱼眼播放界面
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer createFeye:(int)Hardandsoft Hardmodel:(int)Hardmodel{
    //    [[feyeArray objectAtIndex:mediaPlayer.index] createFeye:Hardandsoft frameSize:playView.frame];
    //    GLKViewController *glkVC= [[feyeArray objectAtIndex:mediaPlayer.index] getFeyeViewController];
    //    [self addChildViewController:glkVC];
    //    [playView addSubview:glkVC.view];
    //    hardandsoft = Hardandsoft;
    //    hardmodel = Hardmodel;
    //    [[feyeArray objectAtIndex:mediaPlayer.index] refreshSoftModel:(int)Hardandsoft model:Hardmodel];
}


//#pragma mark - 跳转到设备配置界面
//- (void)pushToDeviceConfigViewController {
//    [mediaPlayer stop];
//    DeviceConfigViewController *devConfigVC = [[DeviceConfigViewController alloc] init];
//    [self.navigationController pushViewController:devConfigVC animated:YES];
//}

#pragma mark - 显示云台控制器
//-(void)showPTZControl{
//    if (ptzView == nil) {
//        ptzView = [[PTZView alloc] initWithFrame:CGRectMake(0, ScreenHeight-150, ScreenWidth, 150)];
//        ptzView.PTZdelegate = self;
//        ptzView.speedDelegate = self;
//    }
//    [self.view addSubview:ptzView];
//}

#pragma mark - QMPlayViewDelegate

//方向控制点击
-(void)controlPTZBtnTouchDownAction:(int)sender{
    [mediaPlayer controZStartlPTAction:(PTZ_ControlType)sender];
}

//方向控制抬起
-(void)controlPTZBtnTouchUpInsideAction:(int)sender{
    [mediaPlayer controZStopIPTAction:(PTZ_ControlType)sender];
}

#pragma mark - 播放/暂停
-(void)controlPlayAction:(UIButton *)sender {
    if (mediaPlayer.status == MediaPlayerStatusPause) {
        [sender setImage:[QMBundleTool getSectionsImg:@"video_stop"] forState:UIControlStateNormal];
        [sender setImage:[QMBundleTool getSectionsImg:@"video_stop"] forState:UIControlStateSelected];
        [mediaPlayer resumue];
        return;
    }
    if (mediaPlayer.status == MediaPlayerStatusPlaying) {
        [sender setImage:[QMBundleTool getSectionsImg:@"play"] forState:UIControlStateNormal];
        [sender setImage:[QMBundleTool getSectionsImg:@"play"] forState:UIControlStateSelected];
        [mediaPlayer pause];
        return;
    }
}


#pragma mark - QMPlayOptionMenuViewDelegate
-(void)btnClickWithIndex:(QMXMControlType)controlType{
    NSLog(@"index = @%", index);
    switch (controlType) {
        case QM_CONTROL_REALPLAY_SNAP:
            [mediaPlayer snapImage];
            break;
        case QM_CONTROL_REALPLAY_STREAM:
            [self changeStreamType];
            break;
        case QM_CONTROL_REALPLAY_TALK:
            
            break;
        case QM_CONTROL_REALPLAY_VIDEO:
            [self presentPlayBackViewController];
            break;
        case QM_CONTROL_REALPLAY_CHANNLE:
            [self showActionSheet];
            break;
        default:
            break;
    }
}

// 开始双向对讲  (对讲和双向对讲同时只能打开一个) (双向对讲最好做一下手机端的回音消除工作     demo中并没有做这个)
- (void)startDouTalk {
    [QMToast show:@"按住开始对讲"];
    [talkControl startDouTalk];
}

//结束双向对讲
- (void)stopDouTalk {
    [talkControl stopDouTalk];
}




#pragma mark - 云台控制按钮的代理  云台控制方法没有回调

//点击控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchDownAction:(int)sender{
    [mediaPlayer controZStartlPTAction:(PTZ_ControlType)sender];
}
//抬起控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchUpInsideAction:(int)sender{
    [mediaPlayer controZStopIPTAction:(PTZ_ControlType)sender];
}

#pragma mark  停止对讲
- (void)stopTalk {
    //停止对讲
    [talkControl closeTalk];
    //    if (talkView) {
    //        [talkView cannelTheView];
    //    }
}

#pragma mark - 跳转到视频回放界面
-(void)presentPlayBackViewController {
    [self toPlayBackVC];
}

#pragma mark - 打开预览，获取视频YUV数据进行处理
- (void)playYUVBtnClick {
    //第一个通道返回YUV数据
    [playView playViewBufferIng];
    //开始获取YUV数据回调
    [mediaPlayer startYUVBack];
}

#pragma mark - 跳转到控制view
-(void)changeToControlVC
{
    //现获取配置看下支不支持
    ChannelObject *channel = [[[DeviceControl getInstance] getSelectChannelArray] firstObject];
    FUN_DevGetConfig_Json(self.msgHandle, [channel.deviceMac UTF8String], "SystemFunction", 1024,-1,5000,0);
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeNone];
}

#pragma mark - 返回设备列表界面
- (void)popViewController {
    // 停止设备主动上报
    [self cleanMedia];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cleanMedia{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    [[DoorBellModel shareInstance] beginStopUploadData:devObject.deviceMac];
    [talkControl closeTalk]; //停止对讲
    [mediaPlayer closeSound]; //停止音频
    [mediaPlayer stop];
    [[DeviceControl getInstance] cleanSelectChannel];
}

-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch (msg->id) {
        case EMSG_DEV_GET_CONFIG_JSON:{
            if (msg->param1 <0) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%i",(int)msg->param1]];
            }
            else
            {
                [SVProgressHUD dismiss];
                if (msg->pObject == nil) {
                    return;
                }
                SDK_CameraParam *pParam = (SDK_CameraParam *)msg->pObject;
                
                NSData *data = [[[NSString alloc]initWithUTF8String:msg->pObject] dataUsingEncoding:NSUTF8StringEncoding];
                if ( data == nil )
                    break;
                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ( appData == nil) {
                    break;
                }
                NSString* strConfigName = appData[@"Name"];
                
                
                if([strConfigName containsString:@"SystemFunction"])
                {
                    NSLog(@"OtherFunction");
                    
                    BOOL remoteCtrl = [appData[@"SystemFunction"][@"OtherFunction"][@"SupportSysRemoteCtrl"] boolValue];
                    
                    //支持远程控制
                    if (remoteCtrl)
                    {
                        ChannelObject *channel = [[[DeviceControl getInstance] getSelectChannelArray] firstObject];
                        
                        //                        RealPlayControlViewController *vc = [[RealPlayControlViewController alloc]init];
                        //                        vc.devMac = channel.deviceMac;
                        //                        vc.allChannelNum = (int)[[DeviceControl getInstance] allChannelNum];
                        //                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:TS("TR_Not_Support_Function") duration:1.5];
                    }
                }
                
            }
        }
            break;
        default:
            break;
    }
}


- (void) showActionSheet {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.deviceObj.channelArray.count];
    for (int i = 0; i < self.deviceObj.channelArray.count; i ++ ) {
        ChannelObject* channel = self.deviceObj.channelArray[i];
        [titles addObject:channel.channelName];
    }
    __weak typeof(self) weakSelf = self;
    [CGXStringPickerView showStringPickerWithTitle:@"选择通道" DataSource:titles DefaultSelValue:0 IsAutoSelect:false ResultBlock:^(NSInteger index, id selectRow) {
        __strong typeof(self) strongSelf = weakSelf;
        ChannelObject* channel = self.deviceObj.channelArray[index];
        
        [toolView changeChannelName:channel.channelName];
        
        self.selectedChannel = channel;
        mediaPlayer.devID = channel.deviceMac;//设备序列号
        mediaPlayer.channel = channel.channelNumber;//当前通道号
        
        talkControl.deviceMac = mediaPlayer.devID;
        talkControl.channel = mediaPlayer.channel;
        
        [[DeviceControl getInstance] cleanSelectChannel];
        [[DeviceControl getInstance] setSelectChannel:channel];
        
        [self stopRecord];
        [self closeSound];
        [self stopTalk];
        [mediaPlayer stop];
        [mediaPlayer start];
    }];
}

#pragma mark - UITableview delegate & dataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMXMPlayTableViewCell *cell = [QMXMPlayTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.mainTitleLabel.text = @"问题分类";
        cell.subTitleLabel.text = @"请选择";
        cell.iconImgView.image = [QMBundleTool getSectionsImg:@"mine_heaer_task_icon"];
    }
    if (indexPath.row == 1) {
        cell.mainTitleLabel.text = @"处理人";
        cell.subTitleLabel.text = @"请选择";
        cell.iconImgView.image = [QMBundleTool getSectionsImg:@"handler"];
    }
    [cell configWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [QMKeyWindow endEditing:true];
    QMXMPlayTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        [self pushChooseTempleteVCOrg:self.shopID selectedTempleteID:self.selectedTempleteID selectedGrads:self.selectedGrads callBack:^(NSString * _Nonnull templeteID, NSString * _Nonnull param, NSArray<QMScoreItemModel *> * _Nonnull selectedGrads) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.selectedTempleteID = templeteID;
            strongSelf.selectedGrads = selectedGrads;
            strongSelf.templeteParam = param;
            cell.subTitleLabel.text = @"已选择";
        }];
    }
    if (indexPath.row == 1) {
        [self pushReportHandlerVCWithOrg:self.shopID selectedUsers:self.users callBack:^(NSArray<QMUserModel *> * _Nonnull selectedUsers) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString* titleString = @"";
            [self.users removeAllObjects];
            for (int i = 0; i < selectedUsers.count; i ++) {
                QMUserModel* user = selectedUsers[i];
                if (user.name.length <= 0) {
                    titleString = [titleString stringByAppendingFormat:@"%@", user.username];
                }else{
                    titleString = [titleString stringByAppendingFormat:@"%@", user.name];
                }
                if (i < selectedUsers.count - 1) {
                    titleString = [titleString stringByAppendingFormat:@"、"];
                }
                [self.users addObject:user];
            }
            cell.subTitleLabel.text = titleString;
        }];
    }
}


#pragma mark - LFPhotoEditingControllerDelegate
//- (void)lf_PhotoEditingControllerDidCancel:(LFPhotoEditingController *)photoEditingVC {
//    [photoEditingVC.navigationController popViewControllerAnimated:true];
//}
//
//- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhotoEdit:(LFPhotoEdit *)photoEdit {
//    if (photoEdit != nil) {
//        [self.snapshotsView replacePhotoImageIndex:self.photoEditIndex editedImage:photoEdit.editPreviewImage];
//    }
//    [photoEditingVC.navigationController popViewControllerAnimated:true];
//}



#pragma mark - 子类实现
- (void)pushReportHandlerVCWithOrg:(NSString *)org selectedUsers:(NSArray<QMUserModel *> *)users callBack:(ReportHandlerBlock)saveBlock {
    
}

- (void)pushChooseTempleteVCOrg:(NSString *)org selectedTempleteID:(NSString *)templeteID selectedGrads:(NSArray<QMScoreItemModel *> *)selectedGrads callBack:(ChooseTempleteBlock)saveBlock {
    
}

- (void)commitScanShopTempleteVC:(UIViewController *)vc org:(NSString *)org handler:(NSString *)handler problem:(NSString *)problem templeteId:(NSString *)templeteId grades:(NSString *)grades score:(int)score images:(NSArray<UIImage *> *)images completeBlock:(ReportCommitComplete)completeBlock {
    
}

- (void)photoEditWithImg:(UIImage *)currentImage {
    
}

- (void)toPlayBackVC {
    
}
@end
