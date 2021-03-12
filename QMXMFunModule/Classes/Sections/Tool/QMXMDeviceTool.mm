//
//  QMXMDeviceTool.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMDeviceTool.h"
#import "DeviceManager.h"
#import "UserAccountModel.h"

@interface QMXMDeviceTool() <DeviceManagerDelegate, UserAccountModelDelegate>
{
    UserAccountModel* accountModel;
    LoginSuccess loginCallBack;
}
@end

@implementation QMXMDeviceTool

- (void) loginWithUserName:(NSString *)username pwd:(NSString *)pwd mac:(NSString *)mac callBack:(LoginSuccess)callBack {
    [SVProgressHUD show];
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    loginCallBack = callBack;
    [accountModel loginWithTypeAP:username pwd:pwd mac:mac];
}

- (void) initDeviceManager {
    
    DeviceManager *manager = [DeviceManager getInstance];
    manager.delegate = self;
}

- (void)getDeviceChannel:(NSString *)deviceMac {
    [[DeviceManager getInstance] getDeviceChannel:deviceMac];
}

- (void)loginWithTypeAP {
    NSLog(@"loginWithTypeAP");
}


- (void)loginWithNameDelegate:(long)reslut {
    if (reslut >= 0) {
        NSMutableArray* deviceArray = [[DeviceControl getInstance] currentDeviceArray];
        NSLog(@"deviceArray.count = %lu",(unsigned long)deviceArray.count);
        if (deviceArray == nil) {
            deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        DeviceObject *devObject = [deviceArray objectAtIndex:0];
        [[DeviceManager getInstance] getDeviceChannel:devObject.deviceMac];
    }
}

#pragma - mark -- 刷新设备列表
- (void)refreshDeviceList {
    //    [self getdeviceState:nil];
}
#pragma - mark 获取设备在线状态结果
- (void)getDeviceState:(NSString *)sId result:(int)result {
    //    [self.devListTableView reloadData];
}
#pragma - mark 设备唤醒结果
- (void)deviceWeakUp:(NSString *)sId result:(int)result {
    //    if (result < 0) {
    //        [MessageUI ShowErrorInt:result];
    //        return;
    //    }
    //    [SVProgressHUD dismiss];
    //    DeviceObject *object = [[DeviceControl getInstance] GetDeviceObjectBySN:sId];
    //    object.info.eFunDevState = 1;
    //    [self.devListTableView reloadData];
}

#pragma mark 获取设备通道结果
- (void)getDeviceChannel:(NSString *)sId result:(int)result {
    if (result <= 0) {
        if(result == EE_DVR_PASSWORD_NOT_VALID)//密码错误，弹出密码修改框
        {
            [SVProgressHUD dismiss];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("EE_DVR_PASSWORD_NOT_VALID") message:sId preferredStyle:UIAlertControllerStyleAlert];
                        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = TS("set_new_psd");
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UITextField *passWordTextField = alert.textFields.firstObject;
//                            DeviceObject *devObject = [deviceArray objectAtIndex:selectNum];
//                            DeviceManager *manager = [DeviceManager getInstance];
//                            //点击确定修改密码
//                            [manager changeDevicePsw:sId loginName:devObject.loginName password:passWordTextField.text];
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:okAction];
//                        [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [MessageUI ShowErrorInt:result];
        return;
    }
    [SVProgressHUD dismiss];
    [[DeviceControl getInstance] setAllChannelNum:result];
    [[DeviceControl getInstance] cleanSelectChannel];
    DeviceObject *object = [[DeviceControl getInstance] GetDeviceObjectBySN:sId];
    [[DeviceControl getInstance] setSelectChannel:[object.channelArray firstObject]];
    if (loginCallBack != nil) {
        loginCallBack(object);
    }
    
}
@end
