//
//  QMPlayOptionMenuView.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMPlayOptionMenuView.h"
#import <Masonry/Masonry.h>
#import "UIButton+ImageTextButton.h"
//#import <QNNLib/QNNLib-Swift.h>

@interface QMPlayOptionMenuView ()
@property (nonatomic, strong) NSMutableArray* btns;
@end

@implementation QMPlayOptionMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self initUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void) initUI{
    
    self.userInteractionEnabled = true;
    self.backgroundColor = UIColor.whiteColor;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(75);
    }];
    
    NSArray *datas = @[
        @{@"title":@"抓拍", @"icon":@"xm_play_option_snapshot"},
        @{@"title":@"码流切换", @"icon":@"xm_play_option_switch_stream"},
        @{@"title":@"对讲", @"icon":@"xm_play_option_speak"},
        @{@"title":@"录像回放", @"icon":@"xm_play_option_play_back"},
        @{@"title":@"通道1", @"icon":@"xm_play_option_road"}
    ];
    _btns = [NSMutableArray array];
    for (int i = 0; i < datas.count; i ++) {
        NSDictionary *dict = datas[i];
        UIButton * btn = [self createBtnWithTitle:dict[@"title"] icon:dict[@"icon"] tag: i + QM_CONTROL_REALPLAY_SNAP];
        [_btns addObject:btn];
    }
    
    [self makeEqualWidthViews:_btns inView:self LRpadding:20 viewPadding:5];
}

-(void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding {
    UIView *lastView;
    for (UIView *view in views) {
        [containerView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        }else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(LRpadding);
                make.top.bottom.equalTo(containerView);
            }];
        }
        
        lastView=view;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-LRpadding);
    }];
}

- (UIButton *)createBtnWithTitle:(NSString *)title icon:(NSString *)icon tag:(NSInteger)index {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:[[UIColor alloc] initWithRed:0/255 green:0/255 blue:0/255 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitle:title forState:UIControlStateNormal];
    UIImage *iconImage = [QMBundleTool getSectionsImg:icon];
    [btn setImage:iconImage forState:UIControlStateNormal];
    [btn setImage:iconImage forState:UIControlStateSelected];
    if (index == QM_CONTROL_REALPLAY_TALK) {
        [btn addTarget:self action:@selector(talkTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(talkTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(talkTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }else {
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

- (void)clickedBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(btnClickWithIndex:)]) {
        [self.delegate btnClickWithIndex:sender.tag];
    }
}

- (void)talkTouchDown:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(startDouTalk)]) {
        [self.delegate startDouTalk]; //开始双向对讲
    }
}

- (void)talkTouchUpInside:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(stopDouTalk)]) {
        [self.delegate stopDouTalk]; //结束双向对讲
    }
}

- (void)talkTouchUpOutside:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(stopDouTalk)]) {
        [self.delegate stopDouTalk]; //结束双向对讲
    }
}

- (void) changeChannelName:(NSString *)channelName {
    UIButton *btn = (UIButton *)[self viewWithTag:QM_CONTROL_REALPLAY_CHANNLE];
    NSString *title = [NSString stringWithFormat:@"通道:%@",channelName];
    [btn setTitle:title forState:UIControlStateNormal];
//    UIEdgeInsets inset = btn.titleEdgeInsets;
//    inset.left = 10;
//    inset.right = 10;
//    btn.clipsToBounds = true;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIButton *but in _btns) {
        CGFloat titleLeft = (but.frame.size.width - but.titleLabel.intrinsicContentSize.width)/2 - but.imageView.frame.size.width;
        if (titleLeft < -but.frame.size.width*0.5) {
            titleLeft = -but.frame.size.width*0.5;
        }
        CGFloat titleRight = (but.frame.size.width - but.titleLabel.intrinsicContentSize.width)/2;
        if (titleRight < -but.frame.size.width*0.5) {
            titleRight = -but.frame.size.width*0.5;
        }
        [but setTitleEdgeInsets:
         UIEdgeInsetsMake(but.frame.size.height/2,
                          titleLeft,
                          0,
                          titleRight)];
        [but setImageEdgeInsets:
         UIEdgeInsetsMake(
                          0,
                          (but.frame.size.width-but.imageView.frame.size.width)/2,
                          but.titleLabel.intrinsicContentSize.height,
                          (but.frame.size.width-but.imageView.frame.size.width)/2)];
    }
}

@end
