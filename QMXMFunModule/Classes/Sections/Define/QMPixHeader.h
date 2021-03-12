//
//  QMPixHeader.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#ifndef QMPixHeader_h
#define QMPixHeader_h


#import <UIKit/UIKit.h>

#define Test_Api    @"https://central.dev.goqomo.com/api/" //@"http://192.168.197.191:8801/api/"
#define Release_Api @"https://central.dev.goqomo.com/api/"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define QMKeyWindow [UIApplication sharedApplication].keyWindow
#define QMDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define QMDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define QMDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define QMDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define QMScreen_Bounds [UIScreen mainScreen].bounds
#define QMScreen_Height [UIScreen mainScreen].bounds.size.height
#define QMScreen_Width [UIScreen mainScreen].bounds.size.width


// 是否为 iPhoneX系列
#define kDevice_Is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

//  获取状态栏/导航栏/Tabbar栏的高度
#define IPX_STATUSBAROFFSETHEIGHT   ((kDevice_Is_iPhoneX) ? 24.0 : 0.0)
#define IPX_HOMEINDICATORHEIGHT     ((kDevice_Is_iPhoneX) ? 34.0 : 0.0)

#define STATUSBARHEIGHT             (20.0 + IPX_STATUSBAROFFSETHEIGHT)
#define NAVIBARHEIGHT               44.0
#define NaviAndStatusBarHeight      STATUSBARHEIGHT + NAVIBARHEIGHT
#define tabBarItemHeight            ((kDevice_Is_iPhoneX) ? 83.0 : 49.0)

#endif /* QMPixHeader_h */
