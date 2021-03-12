//
//  QMToast.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMToast.h"
#import <Toast/Toast.h>
#import "QMPixHeader.h"

@implementation QMToast

+ (void)show:(NSString *)msg {
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setDefaultDuration:1.2];
    [QMKeyWindow makeToast:msg];
}

@end
