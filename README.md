# QMXMFunModule

[![CI Status](https://img.shields.io/travis/wangfang/QMXMFunModule.svg?style=flat)](https://travis-ci.org/wangfang/QMXMFunModule)
[![Version](https://img.shields.io/cocoapods/v/QMXMFunModule.svg?style=flat)](https://cocoapods.org/pods/QMXMFunModule)
[![License](https://img.shields.io/cocoapods/l/QMXMFunModule.svg?style=flat)](https://cocoapods.org/pods/QMXMFunModule)
[![Platform](https://img.shields.io/cocoapods/p/QMXMFunModule.svg?style=flat)](https://cocoapods.org/pods/QMXMFunModule)

## 安装使用

雄迈SDK组件，方便项目解耦，目前还不支持远程依赖，

1. Download 到本地后，在 `Podfile` 添加本地依赖：
    ```ruby
    pod 'QMXMFunModule', :path => 'QMXMFunModule'
    ```

2. 在 `QMXMFunModuleHeader.h` 配置初始化SDK使用的参数:
    ```Objc
    #define APPUUID ""   //客户唯一标识
    #define APPKEY ""   //APP唯一标识
    #define APPSECRET ""   //内容保护参数
    ```

3. 调用 `QMXMDeviceTool` 的 `loginWithUserName:(NSString *)username pwd:(NSString *)pwd mac:(NSString *)mac ` 登录， 传入参数，具体使用可查看示例工程 `Example` 中 `QMViewController.mm`实现。
    

## 实现功能
1. 远程播放视频巡店，包括暂停、横竖屏切换、全屏、PTZ方向控制（需要设备支持）等。
2. 抓拍、码流切换、远程对讲、通道切换等。
3. 历史视频回放，可切换当天时间段和日期，拖到进度条播放等。
4. 支持对抓拍的图片进行编辑，也可以拍照或者选择本地图片来编辑。
5. 支持模拟器和真机上播放。

## Author

wf_pinbo@163.com

## License

QMXMFunModule is available under the MIT license. See the LICENSE file for more info.
