//
//  QMXMFunModuleHeader.h
//  QMXMFunModule
//
//  Created by wf on 2021/3/12.
//

#ifndef QMXMFunModuleHeader_h
#define QMXMFunModuleHeader_h

#import <Availability.h>
#import "NSString+Category.h"
#import "NSString+Path.h"
#import "LanguageManager.h"
#import "LoginShowControl.h"
//#import "CommonControl.h"
#import "NSUserDefaultData.h"
#import "MessageUI.h"
#import "DeviceControl.h"
#import "QMBundleTool.h"


// 开放平台App信息，需要在开放平台上面创建APP来生成，每一个APP对应一组不同并且唯一的平台信息，不能重复
#define APPUUID "96a2f63113ea44c0bb5bd4db060102a1"   //客户唯一标识
#define APPKEY "5d4bbe284bee4bc4baceea064ec7a156"   //APP唯一标识
#define APPSECRET "7d59101663a94211b4ddc5886099d2f7"   //内容保护参数
#define MOVECARD 4   //内容保护参数

typedef NS_ENUM(int,XM_DEV_NET_CNN_TYPE){
    XM_NET_TYPE_P2P = 0,
    XM_NET_TYPE_SERVER_TRAN = 1,
    XM_NET_TYPE_IP = 2,
    XM_NET_TYPE_DSS = 3,
    XM_NET_TYPE_TUTK = 4,  // Connected type is TUTK 这个不用管未使用
    XM_NET_TYPE_RPS = 5,  //(可靠的代理服务)
    XM_NET_TYPE_RTC_P2P = 6,      // WebRTC-P2P
    XM_NET_TYPE_RTC_PROXY = 7, // WebRTC-Transport
    XM_NET_TYPE_P2P_V2 = 8,      // P2PV2
    XM_NET_TYPE_PROXY_V2 = 9,  // ProxyV2
};

//#define UUID  "79279113d6fc4bfcbd7a4a81705b1e53"
//#define APPKEY "56f0aaa189054b4aa74ff64f35f5b957"
//#define APPSECRET "03a83c7b448f4aedb978948bd3faa826"
//#define MOVECARD 2 //4

#define SZSTR(x)    [x UTF8String]
#define NSSTR(x)    [NSString ToNSStr:x]
#define STRNCPY(x,y) strncpy(x, y, sizeof(x))
#define CSTR(x) (x==nil ? "" : [x UTF8String])
#define OCSTR(x) ([NSString stringWithUTF8String:x])

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

// 是否为 iPhoneX系列
#define QMXMDevice_Is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 获取 系统的版本 号
#define iOS_Version [UIDevice currentDevice].systemVersion.floatValue
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 导航栏颜色
#define GlobalMainColor  [UIColor colorWithRed:239/255.0 green:125/255.0 blue:56/255.0 alpha:1] //主色
#define btnTextColor [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]
#define btnBorderColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]

#define NormalFontColor [UIColor blackColor]  //通用字体色

// 屏幕的宽度 和 高度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height+20-APP_STATUSBAR_HEIGHT)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height+20-APP_STATUSBAR_HEIGHT)
#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define NavAndStatusHight  self.navigationController.navigationBar.frame.size.height+APP_STATUSBAR_HEIGHT

#define realPlayViewHeight (ScreenHeight > ScreenWidth ? ScreenWidth * 0.6 : ScreenHeight * 0.6)
//#define DeviceVersion [[CommonControl getInstance] getDeviceString]
#define NavHeight (QMXMDevice_Is_iPhoneX ? 88 :64)

#define Handle  [self MsgHandle]
#define SELF    [self MsgHandle]
#define OS_IOS 1
//
#import "SVProgressHUD.h"
//
//#import "AppDelegate.h"


//日期格式
#define DateFormatter @"yyyy-MM-dd"
//时间格式
#define TimeFormatter @"yyyy-MM-dd HH:mm:ss"
//时间格式
#define TimeFormatter2 @"HH:mm:ss"
//通知消息key
#define MasterAccount @"MasterAccount"
#define PushNotification @"PushNotification"
#define KFisheyeMode  @"Fisheye_model"
#define picturePlist  @"picture.plist"

#pragma mark - 设备类型定义
typedef NS_ENUM(NSInteger,XM_DEV_TYPE)
{
    XM_DEV_DEV          = 0,
    XM_DEV_SOCKET       = 1,   // 插座
    XM_DEV_BULB         = 2,   // 情景灯泡
    XM_DEV_BULB_SOCKET  = 3,   // 灯座
    XM_DEV_CAR          = 4,   // 汽车伴侣
    XM_DEV_BEYE         = 5,   // 大眼睛
    XM_DEV_SEYE         = 6,   // 小眼睛(小雨点)
    XM_DEV_ROBOT        = 7,   // 雄迈摇头机
    XM_DEV_SPORT_CAMERA = 8,   // 运动摄像机
    XM_DEV_FEYE         = 9,   // 鱼眼小雨点（小雨点全景摄像机）
    XM_DEV_FISH_BULB    = 10,  // 鱼眼灯泡（智能全景摄像灯泡）
    XM_DEV_BOB          = 11,  // 小黄人
    XM_DEV_MUSIC_BOX    = 12,  // wifi音乐盒
    XM_DEV_SPEAKER      = 13,  // wifi音响
    XM_DEV_INTELLIGENT_CENTER     = 14,  // 智联中心
    XM_DEV_DASH_CAMERA  = 15,  //勇士行车记录仪
    XM_DEV_STRIP        = 16,  // 插排
    XM_DEV_DOORLOCK     = 17,  // 门磁
    XM_DEV_DRIVE_BEYE   = 18,  // 大眼睛行车记录仪
    XM_DEV_CENTER_COPY  = 19,  // 智能中心
    XM_DEV_UFO       = 20,  //飞碟
    XM_DEV_DOORBELL     = 21,  // 智能门铃
    
    XM_DEV_BULLET = 22,    //E型枪机--XMJP_bullet_xxxx
    XM_DEV_DRUM = 23,     //架子鼓--xmjp_drum_xxxx
    XM_DEV_GUNLOCK_510  = 24,  // 雄迈枪机510
    XM_DEV_FEEDER = 25,      //喂食器设备--feeder_xxxx
    XM_DEV_CAT          = 26,  // 猫眼
    
    XM_DEV_NSEYE      = 601,   //直播小雨点
    
    XM_DEV_INTELLIGENT_LOCK= 286326823, // 门铃锁
    XM_DEV_DOORLOCK_V2 = 0x11110031,    // 门锁支持对讲 智联大迈
    XM_DEV_DOORBELL_A = 285409282,      // 门铃
    XM_DEV_SMALL_V = 0x11110032,        // 小V
    CZ_DOORBELL         = 286457857, // 创泽门铃
};





#endif /* QMXMFunModuleHeader_h */
