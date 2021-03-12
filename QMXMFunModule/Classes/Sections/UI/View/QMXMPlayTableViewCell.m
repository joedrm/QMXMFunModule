//
//  QMXMPlayTableViewCell.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMPlayTableViewCell.h"
#import "UIColor+LBECategory.h"
#import <Masonry/Masonry.h>

@interface QMXMPlayTableViewCell ()
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation QMXMPlayTableViewCell

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView {
    
    QMXMPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QMXMPlayTableViewCellReuseId];
    if (nil == cell) {
        cell = [[QMXMPlayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QMXMPlayTableViewCellReuseId];
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
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.mainTitleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.contentView);
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(11);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.contentView);
        make.right.equalTo(self.arrowImgView.mas_left).offset(-5);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self.contentView);
        make.left.equalTo(self.iconImgView.mas_left);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = [UILabel new];
        _mainTitleLabel.font = [UIFont systemFontOfSize:15];
        _mainTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _mainTitleLabel;
}


- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _subTitleLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.layer.masksToBounds = YES;
        _arrowImgView.image = [QMBundleTool getSectionsImg:@"arrow_right"];
    }
    return _arrowImgView;
}


- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
    }
    return _lineView;
}


- (void)configWithIndexPath:(NSIndexPath *)indexPath {
    self.lineView.hidden = (indexPath.row == 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
