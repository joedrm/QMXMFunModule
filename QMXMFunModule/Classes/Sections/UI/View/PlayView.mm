//
//  PlayView.m
//  XMEye
//
//  Created by XM on 2018/7/21.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "PlayView.h"
#import <Masonry/Masonry.h>
#import "UIColor+LBECategory.h"
#import "FunSDK/netsdk.h"
#import "UIImage+QMCategory.h"
#import "FunSDK/FunSDK.h"
#import "NSDate+TimeCategory.h"
#import "VideoContentDefination.h"
#import "TimeInfo.h"
#import "QMPixHeader.h"
#import <TZImagePickerController/UIView+TZLayout.h>

@interface PlayView() {
    float _add;         //每次跳转的时间
    float _standardNum;
    int _leftNum;       //左边界时间
    int _rightNum;      //边界时间
}
@property (nonatomic, assign) BOOL showPtzControlBtns;
@property (nonatomic, strong) UIButton *ptzUpBtn;
@property (nonatomic, strong) UIButton *ptzDownBtn;
@property (nonatomic, strong) UIButton *ptzLeftBtn;
@property (nonatomic, strong) UIButton *ptzRightBtn;
@property (nonatomic, strong) UILabel* startTimeLabel;
@property (nonatomic, strong) UILabel* endTimeLabel;
@property (nonatomic, strong) UISlider* progressSlider;
@property (nonatomic, strong) RecordInfo* recordInfo;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) float sliderValue;

@end

@implementation PlayView

- (id)initWithFrame:(CGRect)frame playBack:(BOOL)playBack {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _activityView.hidesWhenStopped = YES;
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    if (playBack) {
        [self crreateSlider];
    }else{
        [self createPlay];
    }
    return self;
}

- (void)createPlay {
    
    self.showPtzControlBtns = NO;
    
    UIButton * ptzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ptzBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ptzBtn setImage:[QMBundleTool getSectionsImg:@"ptz_control"] forState:UIControlStateNormal];
    [ptzBtn setImage:[QMBundleTool getSectionsImg:@"ptz_control"] forState:UIControlStateSelected];
    [ptzBtn addTarget:self action:@selector(ptzBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ptzBtn];
    [ptzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"000000" opacity:0.5];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.18);
    }];
    
    UIButton * fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [fullScreenBtn setImage:[QMBundleTool getSectionsImg:@"full_screen"] forState:UIControlStateNormal];
    [fullScreenBtn setImage:[QMBundleTool getSectionsImg:@"full_screen"] forState:UIControlStateSelected];
    self.fullScreenBtn = fullScreenBtn;
    [bottomView addSubview:fullScreenBtn];
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    UIButton * playControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [playControlBtn setImage:[QMBundleTool getSectionsImg:@"video_stop"] forState:UIControlStateNormal];
    [playControlBtn setImage:[QMBundleTool getSectionsImg:@"video_stop"] forState:UIControlStateSelected];
    [playControlBtn addTarget:self action:@selector(controlPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playControlBtn];
    [playControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 上 ▲
    UIButton * ptzUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ptzUpBtn setImage:[QMBundleTool getSectionsImg:@"ptz_up"] forState:UIControlStateNormal];
    [ptzUpBtn setImage:[QMBundleTool getSectionsImg:@"ptz_up"] forState:UIControlStateSelected];
    [ptzUpBtn addTarget:self action:@selector(ptzControlTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    [ptzUpBtn addTarget:self action:@selector(ptzControlTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    ptzUpBtn.tag = TILT_UP;
    [self addSubview:ptzUpBtn];
    [ptzUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 下 ▼
    UIButton * ptzDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* ptzDownImage = [UIImage image:[QMBundleTool getSectionsImg:@"ptz_up"] rotation:UIImageOrientationDown];
    [ptzDownBtn setImage:ptzDownImage forState:UIControlStateNormal];
    [ptzDownBtn setImage:ptzDownImage forState:UIControlStateSelected];
    [ptzDownBtn addTarget:self action:@selector(ptzControlTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    [ptzDownBtn addTarget:self action:@selector(ptzControlTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    ptzDownBtn.tag = TILT_DOWN;
    [self addSubview:ptzDownBtn];
    [ptzDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 左
    UIButton * ptzLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* ptzLeftImage = [UIImage image:[QMBundleTool getSectionsImg:@"ptz_up"] rotation:UIImageOrientationLeft];
    [ptzLeftBtn setImage:ptzLeftImage forState:UIControlStateNormal];
    [ptzLeftBtn setImage:ptzLeftImage forState:UIControlStateSelected];
    ptzLeftBtn.tag = PAN_LEFT;
    [ptzLeftBtn addTarget:self action:@selector(ptzControlTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    [ptzLeftBtn addTarget:self action:@selector(ptzControlTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ptzLeftBtn];
    [ptzLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 右
    UIButton * ptzRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* ptzRightImage = [UIImage image:[QMBundleTool getSectionsImg:@"ptz_up"] rotation:UIImageOrientationRight];
    [ptzRightBtn setImage:ptzRightImage forState:UIControlStateNormal];
    [ptzRightBtn setImage:ptzRightImage forState:UIControlStateSelected];
    ptzRightBtn.tag = PAN_RIGHT;
    [ptzRightBtn addTarget:self action:@selector(ptzControlTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    [ptzRightBtn addTarget:self action:@selector(ptzControlTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ptzRightBtn];
    [ptzRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.ptzUpBtn = ptzUpBtn;
    self.ptzDownBtn = ptzDownBtn;
    self.ptzLeftBtn = ptzLeftBtn;
    self.ptzRightBtn = ptzRightBtn;
    
    ptzUpBtn.hidden = !self.showPtzControlBtns;
    ptzDownBtn.hidden = !self.showPtzControlBtns;
    ptzLeftBtn.hidden = !self.showPtzControlBtns;
    ptzRightBtn.hidden = !self.showPtzControlBtns;
}

- (void)crreateSlider {
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"000000" opacity:0.5];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.12);
    }];
    
    UILabel* startTimeLabel = [[UILabel alloc] init];
    startTimeLabel.textColor = [UIColor whiteColor];
    startTimeLabel.font = [UIFont systemFontOfSize:11];
    startTimeLabel.textAlignment = NSTextAlignmentLeft;
    startTimeLabel.text = @"开始时间";
    [bottomView addSubview:startTimeLabel];
    self.startTimeLabel = startTimeLabel;
    [startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    
    UILabel* endTimeLabel = [[UILabel alloc] init];
    endTimeLabel.textColor = [UIColor whiteColor];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    endTimeLabel.font = [UIFont systemFontOfSize:11];
    endTimeLabel.text = @"结束时间";
    [bottomView addSubview:endTimeLabel];
    self.endTimeLabel = endTimeLabel;
    [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
    slider.tz_height = 10;
    slider.minimumValue = 0;
    slider.maximumValue = 3600; // 设置最大值
    slider.value = 0; // 设置初始值
    slider.continuous = YES; // 设置可连续变化
//    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
//    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
//    slider.thumbTintColor = [UIColor redColor]; //设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
     [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:slider];
    self.progressSlider = slider;
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.left.mas_equalTo(startTimeLabel.mas_right).offset(10);
        make.right.mas_equalTo(endTimeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(10);
    }];
    [slider setThumbImage:[UIImage createImageColor:[UIColor colorWithHexString:@"ffffff"] size:CGSizeMake(6, 6)] forState:UIControlStateNormal];
    //设置滑竿上拇指， 左边和右边的图片
//    [slider setMinimumTrackImage:imageMin forState:UIControlStateNormal];
//    [slider setMaximumTrackImage:imageMax forState:UIControlStateNormal];

}


- (void)sliderValueChanged: (UISlider *)sender{
    self.sliderValue = sender.value;
    
//    float time = sender.value / (24 * 6 * Unit_Second * 60) * 24 * 60 * 60;
    
//    NSString *timeStr = [self getSecondStringWithSecond:[NSNumber numberWithFloat:sender.value].intValue];
//
//    NSLog(@"timeStr = %@", timeStr);
//
////    _add = _add + sender.value;
//
//    NSLog(@"sliderValueChanged _add = %ld", [NSNumber numberWithFloat:_add].intValue);
    
    float seekValue = sender.value;
    if (seekValue < 0.0) {
        seekValue = 0.0;
    }
    
    if (seekValue > sender.maximumValue) {
        seekValue = sender.maximumValue;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(seekPlay:)]) {
        [self.delegate seekPlay:seekValue];
    }
}

- (void)playerAction {
    
    float value = self.sliderValue;
    if (value < self.progressSlider.maximumValue) {
        value += 1.0;
        self.sliderValue = value;
        [self.progressSlider setValue:value animated:false];
    }else {
        [self deallocTimer];
    }
}

- (void)deallocTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)initTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerAction) userInfo:nil repeats:YES];
}

- (void)ptzBtnClicked{
    self.showPtzControlBtns = !self.showPtzControlBtns;
    self.ptzUpBtn.hidden = !self.showPtzControlBtns;
    self.ptzDownBtn.hidden = !self.showPtzControlBtns;
    self.ptzLeftBtn.hidden = !self.showPtzControlBtns;
    self.ptzRightBtn.hidden = !self.showPtzControlBtns;
}

#pragma mark - 抬起云台控制的按钮
- (void)ptzControlTouchDownAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlPTZBtnTouchDownAction:)]) {
        [self.delegate controlPTZBtnTouchDownAction:(int)sender.tag];
    }
}

- (void)ptzControlTouchUpInsideAction: (UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlPTZBtnTouchUpInsideAction:)]) {
        [self.delegate controlPTZBtnTouchUpInsideAction:(int)sender.tag];
    }
}

- (void)controlPlayClicked: (UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlPlayAction:)]) {
        [self.delegate controlPlayAction:sender];
    }
}


#pragma mark  刷新界面和图标
- (void)refreshView:(int)index {
    self.tag = index;
}
- (void)playViewBufferIng { //正在缓冲
    [self.activityView startAnimating];
}
- (void)playViewBufferEnd {//缓冲完成
    [self.activityView stopAnimating];
}
- (void)playViewBufferStop {//预览失败
    [self.activityView stopAnimating];
}


+(Class)layerClass{
    return [CAEAGLLayer class];
}


#pragma mark - 录像回放时间帧回调，用来刷新label时间显示和时间轴
time_t ToTime_t(SDK_SYSTEM_TIME *pDvrTime);
-(void)refreshTimeAndProgress:(int)timeInfo{
    //刷新时间轴
    SDK_SYSTEM_TIME time = {0};
    time.year = [NSDate getYearFormDate:self.date];
    time.month = [NSDate getMonthFormDate:self.date];
    time.day = [NSDate getDayFormDate:self.date];
    time.hour = 0;
    time.second = 0;
    time.minute = 0;
    int thisTime = (int)ToTime_t(&time);
    
//    XM_SYSTEM_TIME end = self.recordInfo.timeEnd;
//
//    SDK_SYSTEM_TIME time = {0};
//    time.year = end.year;
//    time.month = end.month;
//    time.day = end.day;
//    time.hour = end.hour;
//    time.second = end.second;
//    time.minute = end.month;
//    int thisTime = (int)ToTime_t(&time);
    
    _add = timeInfo - thisTime;
    [self refreshProgress];
    //刷新时间label
    if (_add == 0) {
        return;
    }
    
    self.startTimeLabel.text = [self getSecondStringWithSecond:_add];
}


#pragma mark - 通过搜索录像返回的时间来刷新时间轴
-(void)refreshWithAddTime:(NSInteger)add {
    _add = add;
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return;
    }
    [self refreshProgress];
}

#pragma mark -根据返回的录像文件刷新时间轴
-(void)refreshProgressWithSearchResult:(NSMutableArray*)array {
    self.dataArray = [array mutableCopy];
    [self refreshProgress];
}

-(void)refreshProgress {
//    [self showProgressWithUnit:UNIT_TYPE_SECOND andMiddleSecond:_add];
//    TimeInfo *info1 = [self.dataArray objectAtIndex:_standardNum];
//    TimeInfo *info2 = [self.dataArray objectAtIndex:_rightNum];
//    TimeInfo *info3 = [self.dataArray lastObject];
}

- (void)refreshPlayProgressByRecordFile:(RecordInfo *)record {
    self.recordInfo = record;
    XM_SYSTEM_TIME   begin = record.timeBegin;
    XM_SYSTEM_TIME   end = record.timeEnd;
    NSString *timeBegin = [NSString stringWithFormat:@"%02d:%02d:%02d",begin.hour,begin.minute,begin.second];
    NSString *timeEnd = [NSString stringWithFormat:@"%02d:%02d:%02d",end.hour,end.minute,end.second];
    self.startTimeLabel.text = timeBegin;
    self.endTimeLabel.text = timeEnd;
    
    SDK_SYSTEM_TIME startTime = {0};
    startTime.year = self.recordInfo.timeBegin.year;
    startTime.month = self.recordInfo.timeBegin.month;
    startTime.day = self.recordInfo.timeBegin.day;
    startTime.hour = self.recordInfo.timeBegin.hour;
    startTime.second = self.recordInfo.timeBegin.second;
    startTime.minute = self.recordInfo.timeBegin.minute;
    int startTimeSecond = (int)ToTime_t(&startTime);

    SDK_SYSTEM_TIME endtime = {0};
    endtime.year = self.recordInfo.timeEnd.year;
    endtime.month = self.recordInfo.timeEnd.month;
    endtime.day = self.recordInfo.timeEnd.day;
    endtime.hour = self.recordInfo.timeEnd.hour;
    endtime.minute = self.recordInfo.timeEnd.minute;
    endtime.second = self.recordInfo.timeEnd.second;
    int endTimeSecond = (int)ToTime_t(&endtime);
    
    SDK_SYSTEM_TIME time = {0};
    time.year = [NSDate getYearFormDate:self.date];
    time.month = [NSDate getMonthFormDate:self.date];
    time.day = [NSDate getDayFormDate:self.date];
    time.hour = 0;
    time.second = 0;
    time.minute = 0;
    int thisTime = (int)ToTime_t(&time);
    
    int totalSeconds = endTimeSecond - startTimeSecond;
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = totalSeconds;
    
    NSLog(@"endTimeSecond = %ld; startTimeSecond = %ld", endTimeSecond, startTimeSecond);
    
    [self deallocTimer];

    [self playViewBufferEnd];
    self.sliderValue = 0.0;
    [self initTimer];
}

-(NSString *)getSecondStringWithSecond:(int)second
{
    int h = second / 3600;
    int m = (second % 3600) / 60;
    int s = ((second % 3600) % 60);
    if (s<0) {
        s=0;
    }
    NSString *str = [NSString stringWithFormat:@"%@:%@:%@",h>=10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h],m>=10?[NSString stringWithFormat:@"%i",m]:[NSString stringWithFormat:@"0%i",m],s>=10?[NSString stringWithFormat:@"%i",s]:[NSString stringWithFormat:@"0%i",s]];
    return str;
}
@end


