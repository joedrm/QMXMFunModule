//
//  PrivacyTool.swift
//  QNN
//
//  Created by TifaTsubasa on 17/3/28.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation
import Photos
import AVFoundation
import AddressBook
import AddressBookUI

public class PrivacyTool {
    
    /// 是否支持相机
    public class func haveSourceCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    /// 相册权限
    public class func haveAssetsLibraryAuthorization() -> Bool {
        let author = PHPhotoLibrary.authorizationStatus()
        if author == .restricted  || author == .denied {
            return false
        }
        return true
    }
    
    /// 相机权限
    public class func haveCameraAuthorization() -> Bool {
        let author = AVCaptureDevice.authorizationStatus(for: .video)
        if author == .restricted || author == .denied {
            return false
        }
        return true
    }
    
    /// 通讯录权限
    public class func haveContactAuthorization() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        if status == .denied || status == .restricted {
            return false
        }
        return true
    }
    
    /// 权限弹窗
    public static func popPrivacyAlertView(title: String, showVc vc: UIViewController?) {
        let alertVc = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            alertVc.dismiss(animated: true, completion: nil)
        }))
        alertVc.addAction(UIAlertAction(title: "设置", style: .default, handler: { (_) in
            QNNCommonTool.openUrl(from: UIApplication.openSettingsURLString)
        }))
        vc?.present(alertVc, animated: true, completion: nil)
    }
}
