//
//  QMXMPlayViewController.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMBaseViewController.h"
#import "DeviceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMXMPlayViewController : QMBaseViewController
@property(nonatomic, strong) DeviceObject *deviceObj;
@property(nonatomic, copy) NSString * shopID;
@end

NS_ASSUME_NONNULL_END
