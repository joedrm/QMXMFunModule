//
//  QMHud.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMHud.h"
#import "SVProgressHUD.h"

@implementation QMHud
+ (void) showHUD:(NSString *)msg {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

+ (void) showSuccess:(NSString *)msg {
    [SVProgressHUD showSuccessWithStatus:msg duration:1.2];
}
@end
