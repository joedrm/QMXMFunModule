//
//  AuthorizationService.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "AuthorizationService.h"

#import "AuthorizationService.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@implementation AuthorizationService
/**
 判断是否有相机权限
 */
+ (BOOL)isHaveCameraAuthor {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        return NO;
    }
    return YES;
}
/**
 判断是否有相册访问权限
 */
+ (BOOL)isHavePhotoAuthor{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        return NO;
        
    }
    return YES;
}
@end
