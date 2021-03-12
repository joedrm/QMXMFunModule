//
//  QMXMDeviceTool.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginSuccess)(DeviceObject *object);

@interface QMXMDeviceTool : NSObject
- (void) loginWithUserName:(NSString *)username pwd:(NSString *)pwd mac:(NSString *)mac callBack:(LoginSuccess)callBack;
- (void) initDeviceManager;
- (void)getDeviceChannel:(NSString *)deviceMac;
@end

NS_ASSUME_NONNULL_END
