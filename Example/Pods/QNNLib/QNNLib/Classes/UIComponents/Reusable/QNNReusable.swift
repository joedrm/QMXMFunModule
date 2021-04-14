//
//  QNNReusable.swift
//  QNNLib
//
//  Created by joewang on 2019/1/29.
//

import Foundation
import UIKit

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}


extension UITableViewCell:Reusable {}
extension UICollectionViewCell:Reusable {}


extension Reusable where Self : NSObject {
    public static var reuseIdentifier: String {
        let classString : String = NSStringFromClass(self.classForCoder())
        return classString.components(separatedBy: ".").last!
    }
}


extension QNN where Base: UITableView {
    public func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        base.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        base.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: Reusable {
        return base.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
}



extension QNN where Base: UICollectionView {
    
    public func registerReusableCell<T: UICollectionViewCell>(_: T.Type) {
        base.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    
    public func registerReusableSupplementaryView<T: Reusable>(elementKind: String, _: T.Type) {
        base.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath) -> T where T: Reusable {
        return base.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
