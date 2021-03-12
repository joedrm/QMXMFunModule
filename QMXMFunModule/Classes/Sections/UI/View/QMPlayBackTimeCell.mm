//
//  QMPlayBackTimeCell.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/23.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMPlayBackTimeCell.h"
#import "UIColor+LBECategory.h"
#import <Masonry/Masonry.h>
#import "QMDatePickerUtil.h"
#import "VideoFileDownloadConfig.h"

@interface QMPlayBackTimeCell() <FileDownloadDelegate>
{
    BOOL _loaded;
}
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) VideoFileDownloadConfig* downConfig;

@end

@implementation QMPlayBackTimeCell

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView {
    
    QMPlayBackTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMPlayBackTimeCell"];
    if (nil == cell) {
        cell = [[QMPlayBackTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QMPlayBackTimeCell"];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.mainTitleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightImgView];
//    self.downConfig = [[VideoFileDownloadConfig alloc] init];
//    self.downConfig.delegate = self;
//    _loaded = false;
    
//    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.height.mas_equalTo(80);
//        make.width.mas_equalTo(100);
//    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.left.mas_equalTo(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.mainTitleLabel.mas_left);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
    }];
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = [UILabel new];
        _mainTitleLabel.text = @"hahahah";
        _mainTitleLabel.font = [UIFont systemFontOfSize:15];
        _mainTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _mainTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
    }
    return _lineView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [UIImageView new];
//        _rightImgView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImgView.image = [QMBundleTool getSectionsImg:@"check"];
    }
    return _rightImgView;
}

- (void)configTimeSubArr:(NSMutableArray<TimeInfo*>*)subArr {
    
    TimeInfo* startInfo = subArr.firstObject;
    TimeInfo* endInfo = subArr.lastObject;
    NSString* start = [QMDatePickerUtil getSecondStringWithSecond:startInfo.start_Time];
    NSString* end = [QMDatePickerUtil getSecondStringWithSecond:endInfo.end_Time];
    self.mainTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
}



- (void)configVideFile:(RecordInfo *)record {
    
    NSString* path = [VideoFileDownloadConfig getThumbImageFilePath:record];
    XM_SYSTEM_TIME begin = record.timeBegin;
    XM_SYSTEM_TIME end = record.timeEnd;
    NSString *timeBegin = [NSString stringWithFormat:@"%02d:%02d:%02d",begin.hour,begin.minute,begin.second];
    NSString *timeEnd = [NSString stringWithFormat:@"%02d:%02d:%02d",end.hour,end.minute,end.second];
    self.mainTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", timeBegin, timeEnd];
    
    self.rightImgView.hidden = !record.check;
//    if (!_loaded) {
//        _loaded = true;
//        [self.downConfig downloadThumbImage:record];
//    }
//    __weak typeof(self) weakSelf = self;
//    [record startDownloadImageWithComplete:^(UIImage *thumbImage) {
//        weakSelf.iconImgView.image = thumbImage;
//    }];
}

- (void)thumbDownloadResult:(NSInteger)result path:(NSString*)thumbPath {
    NSLog(@"thumbDownloadResult = %@", thumbPath);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
