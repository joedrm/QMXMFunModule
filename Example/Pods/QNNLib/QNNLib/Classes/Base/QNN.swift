//
//  QNN.swift
//  QNNLib
//
//  Created by joewang on 2019/1/4.
//

import Foundation


/// https://blog.dianqk.org/2016/08/10/better-swifty-framework-namespace/

public protocol QNNProtocol {
    associatedtype Base
    var qnn: Base { get }
    static var qnn: Base.Type { get set }
}

public extension QNNProtocol {
    var qnn: QNN<Self> {
        get {
            return QNN(base: self)
        }
        set {
            
        }
    }
    
    static var qnn: QNN<Self>.Type {
        get {
            return QNN.self
        }
        set {
            
        }
    }
}

public protocol QNNStructProtocol {
    associatedtype Base
    var base: Base { get set }
    init(base: Base)
}

public struct QNN<Base>: QNNStructProtocol {
    public var base: Base
    public init(base: Base) {
        self.base = base
    }
}

extension NSObject: QNNProtocol { }
extension Bool: QNNProtocol { }
extension Character: QNNProtocol { }
extension Dictionary: QNNProtocol { }
extension String: QNNProtocol { }
extension Array: QNNProtocol { }
extension Int: QNNProtocol { }
//extension Set: QNNProtocol { }
//extension Float: QNNProtocol { }
//extension Double: QNNProtocol { }


// 使用
//extension QNN where Base: UITableView {
//
//}

//extension QNN where Base: NSAttributedString {
//
//}


//extension QNNStructProtocol where Base == String {
//
//}




/// 关于WeakProxy https://www.cnblogs.com/silence-cnblogs/p/7583289.html
public class NiceWeakObject<T: AnyObject> {
    public weak var value: T?
    init (_ value: T) {
        self.value = value
    }
}

public class NiceWeakProxy<T: NSObject>: NSObject {
    public weak var target: T?
    init(with target: T) {
        self.target = target
    }
    
    public override func isProxy() -> Bool {
        return true
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        return responds(to: aSelector)
    }
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    public override func method(for aSelector: Selector!) -> IMP! {
        return target?.method(for: aSelector)
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let t = target {
            return t.isEqual(object)
        }
        return false
    }
    
    public override var hash: Int {
        if let t = target {
            return t.hash
        }
        return Int.max
    }
    
    public override var superclass: AnyClass? {
        return target?.superclass
    }
    
    public override var classForCoder: AnyClass {
        if let t = target {
            return t.classForCoder
        }
        return self.classForCoder
    }
    
    public override func isKind(of aClass: AnyClass) -> Bool {
        if let t = target {
            return t.isKind(of: aClass)
        }
        return false
    }
    
    public override func isMember(of aClass: AnyClass) -> Bool {
        if let t = target {
            return t.isMember(of: aClass)
        }
        return false
    }
    
    public override func conforms(to aProtocol: Protocol) -> Bool {
        if let t = target {
            return t.conforms(to: aProtocol)
        }
        return false
    }
    
    public override var description: String {
        return target.debugDescription
    }
    
    public override var debugDescription: String {
        return target.debugDescription
    }
}
