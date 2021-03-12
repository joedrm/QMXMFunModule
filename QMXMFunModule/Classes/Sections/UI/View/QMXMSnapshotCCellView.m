//
//  QMXMSnapshotItemView.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMSnapshotCCellView.h"
#import <Masonry/Masonry.h>

@interface QMXMSnapshotCCellView ()
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation QMXMSnapshotCCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.snapImageView];
        [self.snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.deleteBtn];
        [self bringSubviewToFront:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.right.mas_equalTo(-4);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.snapImageView.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.snapImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    _maskLayer.frame = self.snapImageView.bounds;
    _maskLayer.path = maskPath.CGPath;
}

- (UIImageView *)snapImageView {
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.contentMode = UIViewContentModeScaleAspectFill;
        _maskLayer = [[CAShapeLayer alloc]init];
        _snapImageView.layer.mask = _maskLayer;
    }
    return _snapImageView;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *iconImage = [QMBundleTool getSectionsImg:@"xm_play_snap_del"];
        [_deleteBtn setBackgroundImage:iconImage forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:iconImage forState:UIControlStateSelected];
    }
    return _deleteBtn;
}


@end
