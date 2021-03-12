//
//  QMQuestionInputView.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/9.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMQuestionInputView.h"
#import <Masonry/Masonry.h>
#import "UIColor+LBECategory.h"
#import "UITextView+Placeholder.h"

@interface QMQuestionInputView ()<UITextViewDelegate>

@end

@implementation QMQuestionInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *questionLabel = [[UILabel alloc] init];
        questionLabel.text = @"问题描述";
        questionLabel.layer.masksToBounds = YES;
        questionLabel.font = [UIFont systemFontOfSize:15];
        questionLabel.textAlignment = NSTextAlignmentLeft;
        questionLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:questionLabel];
        [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字录入" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[[UIColor lightGrayColor] colorWithAlphaComponent:1.0]}];
        textView.placeholderColor = [UIColor lightGrayColor]; // optional
        [self addSubview:textView];
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor colorWithHexString:@"E0E0E0"].CGColor;
        textView.layer.cornerRadius = 4.0;
        textView.clipsToBounds = true;
        textView.delegate = self;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(questionLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(70);
        }];
        self.textView = textView;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(115);
        }];
    }
    return self;
}

- (void) registKeyborad {
    
}

@end
