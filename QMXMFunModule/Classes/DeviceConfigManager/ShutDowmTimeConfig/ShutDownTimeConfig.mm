//
//  ShutDownTimeConfig.m
//  FunSDKDemo
//
//  Created by XM on 2019/3/18.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "ShutDownTimeConfig.h"

@implementation ShutDownTimeConfig


//获取设备休眠时间
-(void)getShutDownTime {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevCmdGeneral(self.msgHandle, SZSTR(channel.deviceMac), 1042, "System.ManageShutDown", 0, 5000, NULL, 0, -1, 2);
}

//设置休眠时间
-(void)setSutDownTime:(int)shutDownTime {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    char szCfg[512] = {0};
    sprintf(szCfg, "{ \"Name\":\"System.ManageShutDown\",\"System.ManageShutDown\" : {\"ShutDownMode\":%d}}", shutDownTime);
    FUN_DevCmdGeneral(self.msgHandle, SZSTR(channel.deviceMac), 1040, "System.ManageShutDown", 0, 5000, szCfg, (int)strlen(szCfg), -1, 0);
}

-(void)OnFunSDKResult:(NSNumber *)pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    if(msg->param3 == 1040) {
        if ([self.delegate respondsToSelector:@selector(getShutDownTimeConfigResult:)]) {
            [self.delegate setShutDownTimeConfigResult:msg->param1];
        }
    }
    if(msg->param3 == 1042) {
        if (msg->param1 >= 0) {
            NSData *jsonData = [NSData dataWithBytes:msg->pObject length:strlen(msg->pObject)];
            NSError *error;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            self.time = [jsonDic[@"System.ManageShutDown"][@"ShutDownMode"] intValue];
            if (self.time <= 0 ) {
                self.time = 15;
            }
        }
        if ([self.delegate respondsToSelector:@selector(setShutDownTimeConfigResult:)]) {
            [self.delegate getShutDownTimeConfigResult:msg->param1];
        }
    }
}

@end
