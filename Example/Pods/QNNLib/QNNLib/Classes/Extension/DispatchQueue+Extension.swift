//
//  DispatchQueue+Extension.swift
//  QNN
//
//  Created by joewang on 2018/11/7.
//  Copyright © 2018 qianshengqian. All rights reserved.
//

import Foundation


public extension DispatchQueue {
    
    static var `default`: DispatchQueue { return DispatchQueue.global(qos: .`default`) }
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }
    
    
    /// 延时执行
    ///
    /// - Parameters:
    ///   - delay: 延时时长
    ///   - closure: 执行函数
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    private static var _onceTracker = [String]()
    
    
    /// 单次执行
    ///
    /// - Parameters:
    ///   - token: 
    ///   - block: 执行函数
    class func once(_ token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
}
