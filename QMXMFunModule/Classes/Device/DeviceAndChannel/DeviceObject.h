//
//  DeviceObject.h
//  XMEye
//
//  Created by XM on 2018/4/13.
//  Copyright © 2018年 Megatron. All rights reserved.
//
/***
 
设备对象类
 
 *****/
#import "ObjectCoder.h"
#import "ChannelObject.h"

#import "ObSysteminfo.h"
#import "ObSystemFunction.h"

@interface DeviceObject : ObjectCoder

@property (nonatomic, copy) NSString *deviceMac; //设备序列号
@property (nonatomic, copy) NSString *deviceName; //设备名称
@property (nonatomic, copy) NSString *loginName; //登录名
@property (nonatomic, copy) NSString *loginPsw; //登录密码
@property (nonatomic, copy) NSString *deviceIp;  //设备的IP

@property (nonatomic) int state;     //在线状态
@property (nonatomic) int nPort;     //端口号
@property (nonatomic) int nType;     //设备类型
@property (nonatomic) int nID;      //扩展

@property (nonatomic, strong) ObSysteminfo *info; //设备信息
@property (nonatomic, strong) ObSystemFunction *sysFunction; //设备能力级

@property (nonatomic, strong) NSMutableArray *channelArray; //通道数组

@property (nonatomic, copy) NSString *gatewayId;
@property (nonatomic, copy) NSString *shopName;

@end
