//
//  QMCommitButton.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMCommitButton.h"
#import "UIColor+LBECategory.h"
#import "UIImage+QMCategory.h"
#import <Masonry/Masonry.h>

@implementation QMCommitButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitle:@"提交" forState:UIControlStateNormal];
        UIImage *img = [UIImage createImageColor:[UIColor colorWithHexString:@"#D93124"] size:CGSizeMake(1, 1)];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:img forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    return self;
}

@end
