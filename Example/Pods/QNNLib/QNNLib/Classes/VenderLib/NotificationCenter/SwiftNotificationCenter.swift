//
//  SwiftNotificationCenter.swift
//  SwiftNotificationCenter
//
//  Created by Mango on 16/5/5.
//  Copyright © 2016年 Mango. All rights reserved.
//

import Foundation

/***
 特性类型安全、线程安全、内存安全。
 
 类型安全：没有更多的 userInfo 字典和向下转型，只要传递具体的值给观察者。
 线程安全：你可以在任何线程中 register、notify、unregister，而不会崩溃和数据损坏。
 内存安全：SwiftNotificationCenter 将观察者存储为 zeroing-weak 引用。 没有崩溃，无需手动注销。
 
 它简单、安全、轻便、易于使用，用于一对多通信。
 */

public class Broadcaster {
    
    fileprivate static var observersDic = [String: Any]()
    
    fileprivate static let notificationQueue = DispatchQueue(label: "com.swift.notification.center.dispatch.queue", attributes: .concurrent)

    
    public static func register<T>(_ protocolType: T.Type, observer: T) {
        let key = "\(protocolType)"
        safeSet(key: key, object: observer as AnyObject)
    }
    
    public static func unregister<T>(_ protocolType: T.Type, observer: T) {
        let key = "\(protocolType)"
        safeRemove(key: key, object: observer as AnyObject)
    }
    
    
    /// Remove all observers which comform to the protocol
    public static func unregister<T>(_ protocolType: T.Type) {
        let key = "\(protocolType)"
        safeRemove(key: key)
    }
    
    public static func notify<T>(_ protocolType: T.Type, block: (T) -> Void ) {
        
        let key = "\(protocolType)"
        guard let objectSet = safeGetObjectSet(key: key) else {
            return
        }
        
        for observer in objectSet {
            if let observer = observer as? T {
                block(observer)
            }
        }
    }
}

private extension Broadcaster {
    
    static func safeSet(key: String, object: AnyObject) {
        notificationQueue.async(flags: .barrier) {
            if var set = observersDic[key] as? WeakObjectSet<AnyObject> {
                set.add(object)
                observersDic[key] = set
            }else{
                observersDic[key] = WeakObjectSet(object)
            }
        }
    }
    
    static func safeRemove(key: String, object: AnyObject) {
        notificationQueue.async(flags: .barrier) {
            if var set = observersDic[key] as? WeakObjectSet<AnyObject> {
                set.remove(object)
                observersDic[key] = set
            }
        }
    }
    
    static func safeRemove(key: String) {
        notificationQueue.async(flags: .barrier) {
            observersDic.removeValue(forKey: key)
        }
    }
    
    static func safeGetObjectSet(key: String) -> WeakObjectSet<AnyObject>? {
        var objectSet: WeakObjectSet<AnyObject>?
        notificationQueue.sync {
            objectSet = observersDic[key] as? WeakObjectSet<AnyObject>
        }
        return objectSet
    }
}
