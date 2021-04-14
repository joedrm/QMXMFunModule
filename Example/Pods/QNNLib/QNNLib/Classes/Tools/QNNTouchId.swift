//
//  QNNTouchID.swift
//  SwiftCocoa
//
//  Created by 王振宇 on 7/4/16.
//  Copyright © 2016 王振宇. All rights reserved.
//

import LocalAuthentication
import Toast


@objc
public protocol touchIDDelegate: class {
    @objc optional func touchIDSuccess()
    @objc optional func touchIDFail()
}

@available(iOS 8.0, *)
public class QNNTouchID: NSObject {
    
    public static let shareInstance = QNNTouchID()
    public var context = LAContext()
    public var error: NSError?
    public let reasonString = "需要验证您的指纹来确认您的身份信息"
    
    public weak var delegate: touchIDDelegate?
    
    private override init() {
        
    }
    
    /**
     是否可以使用 touchID
     - failback: 失败回调
     - returns: Bool
     */
    public func isEnbaleTouchID(faileCallBack:(()-> Void)? = nil) -> Bool {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            // 以下情况，指纹解锁不会出现
            switch error!.code {
            case LAError.touchIDNotAvailable.rawValue:
                debugPrintOnly("NO QNNTouchID on device")
            case LAError.touchIDNotEnrolled.rawValue:
                debugPrintOnly("No fingers enrolled")
                faileCallBack?()
            case LAError.passcodeNotSet.rawValue:
                debugPrintOnly("NO password set")
            default:
                if #available(iOS 9.0, *) {
                    if error!.code == LAError.touchIDLockout.rawValue {
                        return true
                    }
                }
                debugPrintOnly("something went wrong getting local auth")
            }
        }
        return false
    }
    
    
    /*
     * 重置TouchID
     */
    public func resetTouchID() {
        context = LAContext()
    }
    
    /*
     * 设置 TouchID
     */
    public func setTouchID(fallbackTitle: String = "", successs: (() -> ())?, fail: ((NSError?) ->())?) {
        if isEnbaleTouchID() {
            self.resetTouchID()
            let reason = "需要验证您的指纹来确认您的身份信息"
            self.context.localizedFallbackTitle = fallbackTitle
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if let _ = error {
                    if (error! as NSError).code == LAError.touchIDNotEnrolled.rawValue {
                        DispatchQueue.main.async {
                            QNNWindow?.toast(string: "您没有可验证的指纹，请去“设置”->“Touch ID”设置指纹",position: CSToastPositionCenter as String)
                        }
                        return
                    }
                    
                    if BasicTool.currentVersionIsgteSystem(systemVersion: 10.0) {
                        if #available(iOS 9.0, *) {
                            if (error! as NSError).code == LAError.touchIDLockout.rawValue {
                                self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                                    if success {
                                        self.setTouchID(successs: successs, fail: fail)
                                    } else {
                                        debugPrintOnly("指纹识别失败")
                                        fail?(error as NSError?)
                                    }
                                })
                            } else {
                                debugPrintOnly("指纹识别失败")
                                fail?(error as NSError?)
                            }
                        } else {
                            // Fallback on earlier versions
                            debugPrintOnly("指纹识别失败")
                            fail?(error as NSError?)
                        }
                    } else {
                        if #available(iOS 9.0, *) {
                            if (error! as NSError).code == LAError.touchIDLockout.rawValue {
                                DispatchQueue.main.async {
                                    self.setTouchID(successs: successs, fail: fail)
                                }
                                
                            } else {
                                debugPrintOnly("指纹识别失败")
                                fail?(error as NSError?)
                            }
                        }
                    }
                } else {
                    debugPrintOnly("指纹识别成功")
                    successs?()
                }
                
            })
        }
    }
    
    /**
     使用 touchID 解锁
     */
    public func showTouchID(fallbackTitle: String = "") {
        // 重置 touchID, 因为当 touchID 第一次验证通过之后，之后将不会再验证
        resetTouchID()
        if isEnbaleTouchID() {
            context.localizedFallbackTitle = fallbackTitle
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, error) in
                
                if success {
                    self.delegate?.touchIDSuccess?()
                    debugPrintOnly("解锁成功")
                } else {
                    debugPrintOnly("解锁失败，请重新尝试")
                    if BasicTool.currentVersionIsgteSystem(systemVersion: 10.0) {
                        if #available(iOS 9.0, *) {
                            let reason = "需要验证您的指纹来确认您的身份信息"
                            if (error! as NSError).code == LAError.touchIDLockout.rawValue {
                                self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                                    if success {
                                        self.showTouchID(fallbackTitle: fallbackTitle)
                                    } else {
                                        debugPrintOnly("指纹识别失败")
                                        self.delegate?.touchIDFail?()
                                    }
                                })
                            } else {
                                debugPrintOnly("指纹识别失败")
                                self.delegate?.touchIDFail?()
                            }
                        }
                    } else {
                        self.delegate?.touchIDFail?()
                    }
                    
                    debugPrintOnly(error.debugDescription)
                    switch (error! as NSError).code {
                    case LAError.systemCancel.rawValue: debugPrintOnly("Authentication was cancelled by the system")
                    case LAError.userCancel.rawValue : debugPrintOnly("Authentication was cancelled by the user")
                    case LAError.userFallback.rawValue: debugPrintOnly("User selected to enter custom password")
                    default:
                        debugPrintOnly("Authentication faill")
                    }
                }
            })
        }
    }
}

