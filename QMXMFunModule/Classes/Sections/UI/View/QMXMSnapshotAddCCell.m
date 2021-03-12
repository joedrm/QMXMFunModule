//
//  QMXMSnapCollectionFooterView.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/13.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMSnapshotAddCCell.h"
#import <Masonry/Masonry.h>

@implementation QMXMSnapshotAddCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *iconImage = [QMBundleTool getSectionsImg:@"xm_play_snap_add"];
        [_addBtn setBackgroundImage:iconImage forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:iconImage forState:UIControlStateSelected];
        [self addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
    }
    return self;
}

@end
