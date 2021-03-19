//
//  QMXMPlayBackViewController.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/13.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMPlayBackViewController.h"
#import "PlayView.h"
#import "VideoFileConfig.h"
#import "MediaPlaybackControl.h"
#import "NSDate+TimeCategory.h"
#import <Masonry/Masonry.h>
#import "QMDatePickerUtil.h"
#import "QMPlayBackTimeCell.h"
#import "NSDate+TimeCategory.h"
#import "VideoFileDownloadConfig.h"

//basePlayFunctionViewDelegate, DateSelectViewDelegate
@interface QMXMPlayBackViewController()
<VideoFileConfigDelegate,MediaplayerControlDelegate,MediaPlayBackControlDelegate, UITableViewDelegate, UITableViewDataSource, QMPlayViewDelegate>
{
    PlayView *pVIew;                    //播放画面
    MediaPlaybackControl *mediaPlayer;  //播放媒体工具
    VideoFileConfig *videoConfig;       //录像文件管理器
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <RecordInfo *> *videoArray;
@property (nonatomic, strong) RecordInfo* recordInfo;
@end

@implementation QMXMPlayBackViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"远程回放";
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedDate = [NSDate date];
    
    self.videoArray = [NSMutableArray array];

    CGRect rect = CGRectMake(0, NavAndStatusHight, ScreenWidth, realPlayViewHeight);
    pVIew = [[PlayView alloc] initWithFrame:rect playBack:true];
    [pVIew refreshView:0];
    pVIew.delegate = self;
    pVIew.date = self.selectedDate;
    [self.view addSubview:pVIew];
    [pVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(NavAndStatusHight);
        make.height.mas_equalTo(realPlayViewHeight);
    }];

//    //创建时间轴背景view
//    pBackView = [[ProgressBackView alloc] initWithFrame:CGRectMake(0, NavHeight + realPlayViewHeight + 60, ScreenWidth, ScreenHeight - NavHeight - realPlayViewHeight - NavHeight)];
//    [self.view addSubview:pBackView];
//    //滑动时间轴之后的回调
//    __weak typeof(self) weakSelf = self;
//    pBackView.TouchSeektoTime = ^ (NSInteger _add){
//        [weakSelf touchAndSeekToTime:_add];
//    };

    //获取要播放的设备信息
    mediaPlayer = [[MediaPlaybackControl alloc] init];
    mediaPlayer.devID = self.channel.deviceMac;//设备序列号
    mediaPlayer.channel = self.channel.channelNumber;//当前通道号
    mediaPlayer.stream = 1;//辅码流
    mediaPlayer.renderWnd = pVIew;
    mediaPlayer.delegate = self;
    mediaPlayer.playbackDelegate = self;

    videoConfig = [[VideoFileConfig alloc] init];
    videoConfig.delegate = self;

    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 60, NavHeight);
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [saveBtn setImage:[QMBundleTool getSectionsImg:@"play_back_pick_date"] forState:UIControlStateNormal];
    [saveBtn setImage:[QMBundleTool getSectionsImg:@"play_back_pick_date"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(pVIew.mas_bottom);
    }];
    
    //开始搜索录像文件
    [self startSearchFile];
}

- (void)dealloc {

    NSLog(@"============== QMXMPlayBackViewController dealloc ==============");
    
    [self stopRecord];
    [self closeSound];
    [mediaPlayer stop];
}

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
        [_tableView registerClass:[QMPlayBackTimeCell class] forCellReuseIdentifier:@"QMPlayBackTimeCell"];
        self.extendedLayoutIncludesOpaqueBars = true;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    return _tableView;
}


- (void)chooseDate:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    [QMDatePickerUtil showDatePicker:@"请选择时间" callBack:^(NSDate * _Nonnull date) {
//        __strong typeof(self) strongSelf = weakSelf;
//        strongSelf.selectedDate = date;
//        [strongSelf dateSelectedAction];
//    }];
    [self showDatePicker];
}

- (void)showDatePicker {
    
}


-(void)dateSelectedAction{
    //判断是否为同一天
    if ([NSDate checkDate:pVIew.date WithDate:self.selectedDate]) {
        return;
    }
    
    pVIew.date = self.selectedDate;
    [mediaPlayer stopRecord];
    [self closeSound];
    [mediaPlayer refresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mediaPlayer stop];
    });

    [self startSearchFile];
}

#pragma mark - 开始播放视频
- (void)startSearchFile {
    NSDateFormatter* formater = [self defaultFormatter];
    NSString* str = [formater stringFromDate:self.selectedDate];
    NSLog(@"self.selectedDate -- str = %@", str);
    [videoConfig getDeviceVideoByFile:self.selectedDate];
//    [pVIew setEndTimeLabelTitle:self.selectedDate];
}

#pragma mark - 返回设备列表界面
- (void)popViewController {
    [self stopRecord];
    [self closeSound];
    [mediaPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSDateFormatter *)defaultFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}

#pragma mark - funsdk回调
#pragma mark  录像按文件查询查询回调
- (void)getVideoResult:(NSInteger)result{
    if (result >= 0) {
        NSMutableArray *array = [[videoConfig getVideoFileArray] mutableCopy];
//        int size = 60;
//        unsigned long count = array.count / size;
//        if (array.count % size == 0) {
//            count = array.count / size;
//        }else{
//            count = (array.count / size) + 1;
//        }
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (int i = 0; i < count; i ++) {
//            NSMutableArray *arr1 = [NSMutableArray array];
//            [arr1 removeAllObjects];
//            int index = i * size;
//            int j = index;
//            while (j < size*(i + 1) && j < array.count) {
//                TimeInfo* timeInfo = array[j];
//                [arr1 addObject:timeInfo];
//                j ++;
//            }
//            [tempArr addObject:[arr1 mutableCopy]];
//        }
        for (RecordInfo* info in array) {
            info.check = NO;
        }
        self.videoArray = [array mutableCopy];
        self.recordInfo = array.firstObject;
        self.recordInfo.check = YES;
        [mediaPlayer playVideoWithRecord:self.recordInfo];
        [pVIew refreshPlayProgressByRecordFile:self.recordInfo];
        [self.tableView reloadData];
    } else{
        [SVProgressHUD showErrorWithStatus:TS("Video_Not_Found")];
    }
}


time_t ToTime_t(SDK_SYSTEM_TIME *pDvrTime);
- (void)seekPlay: (float)value {
//    NSLog(@"seekPlay - value = %.2f", value);
    SDK_SYSTEM_TIME startTime = {0};
    startTime.year = self.recordInfo.timeBegin.year;
    startTime.month = self.recordInfo.timeBegin.month;
    startTime.day = self.recordInfo.timeBegin.day;
    startTime.hour = self.recordInfo.timeBegin.hour;
    startTime.second = self.recordInfo.timeBegin.second;
    startTime.minute = self.recordInfo.timeBegin.minute;
    long startTimeSecond = (long)ToTime_t(&startTime);
    NSInteger palyValue = [NSNumber numberWithFloat:value].integerValue;
    unsigned long long addTime = (long long)((startTimeSecond + palyValue)*1000);
    [mediaPlayer seekToTime:addTime];
}

#pragma mark 通过搜索录像返回的时间来刷新时间轴
- (void)addTimeDelegate:(NSInteger)add{
//    if (pBackView != nil) {
//        [pBackView refreshWithAddTime:add];
//    }
}

#pragma mark 录像回放时间帧回调，用来刷新label时间显示和时间轴
-(void)mediaPlayer:(MediaplayerControl *)mediaPlayer timeInfo:(int)timeinfo{
    if (pVIew != nil) {
        [pVIew refreshTimeAndProgress:timeinfo];
    }
}

#pragma mark - 开始预览结果回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult {
    if (result < 0) {
        [MessageUI ShowErrorInt:result];
    }else {
        if (dssResult == XM_NET_TYPE_DSS) { //DSS 打开视频成功

        }else if (dssResult == XM_NET_TYPE_RPS){//RPS打开预览成功

        }
        [self openSound];
//        [pVIew playViewBufferIng];
    }
}

#pragma mark - 视频缓冲中
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering {
    if (isBuffering == YES) {//开始缓冲
        [pVIew playViewBufferIng];
    }else{//缓冲完成
        [pVIew playViewBufferEnd];
    }
}

#pragma mark - 录像开始结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //开始录像成功
        mediaPlayer.record = MediaRecordTypeRecording;
    }else{
        [MessageUI ShowErrorInt:result];
    }
}
#pragma mark - 录像结束结果
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //结束录像成功
        [SVProgressHUD showSuccessWithStatus:TS("Success") duration:2.0];
    }else{
        [MessageUI ShowErrorInt:result];
    }
    mediaPlayer.record = MediaRecordTypeNone;
}

#pragma mark 设置速度结果
-(void)setPlaySpeedResult:(int)result{
    if (result >= 0) {
        if(result == 0){
            mediaPlayer.speed = MediaSpeedStateNormal;
        }else{
            mediaPlayer.speed = MediaSpeedStateAdd;
        }
    }else{
        [MessageUI ShowErrorInt:result];
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

#pragma mark 停止录像
- (void)stopRecord {
    if (mediaPlayer.record == MediaRecordTypeNone) {
        [mediaPlayer stopRecord];
    }
}

#pragma mark  - 拖动时间轴切换播放时间，并且刷新播放状态
-(void)touchAndSeekToTime:(NSInteger)addTime
{
//    pBackView.ifSliding = NO;
    [pVIew playViewBufferIng];
    [mediaPlayer seekToTime:addTime];
}


#pragma mark - UITableview delegate & dataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.videoArray != nil && self.videoArray.count > 0) {
        return self.videoArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMPlayBackTimeCell *cell = [QMPlayBackTimeCell cellWithTableView:tableView];
    if (self.videoArray != nil && self.videoArray.count > 0) {
        RecordInfo* info = self.videoArray[indexPath.row];
        [cell configVideFile:info];
    }
    
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
    
    self.recordInfo.check = false;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:self.recordInfo] inSection:0];
    QMPlayBackTimeCell* lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    [lastCell configVideFile:self.recordInfo];
    
    RecordInfo* info = self.videoArray[indexPath.row];
    info.check = YES;

    QMPlayBackTimeCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell configVideFile:info];
    
    self.recordInfo = info;
    
    [self stopRecord];
    [self closeSound];
    [mediaPlayer stop];
    
    [mediaPlayer playVideoWithRecord:info];
    [pVIew refreshPlayProgressByRecordFile:info];
}

@end
