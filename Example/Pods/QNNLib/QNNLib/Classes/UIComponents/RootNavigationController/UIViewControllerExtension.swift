//
//  UIViewControllerExtension.swift
//  QNNLib_Example
//
//  Created by joewang on 2019/3/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//


import UIKit

fileprivate var WZConfigKey:UInt8 = 0
fileprivate var WZSnapshotkey:UInt8 = 0

@IBDesignable
extension UIViewController:RootNavigationItemCustomProtocol {
    
    /// 转场动画保存tabbar截图
    public var qnn_tabbarSnapshot:UIView?{
        get{
            return objc_getAssociatedObject(self, &WZSnapshotkey) as? UIView
        }
        set{
            objc_setAssociatedObject(self, &WZSnapshotkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 针对 UITabbarController 主导层级tabbar截图功能
    internal func qnn_getTabbarSnapshot()->UIView?{
        guard let fromTabbarController = self.navigationController?.tabBarController  else {
            return nil
        }
        let tabbarFrame = fromTabbarController.tabBar.frame.inset(by: UIEdgeInsets(top: -0.5, left: 0.0, bottom: 0.0, right: 0.0))
        let fromTabbarSnapshot = fromTabbarController.view.resizableSnapshotView(from: tabbarFrame, afterScreenUpdates: false, withCapInsets: .zero)
        fromTabbarSnapshot?.frame = tabbarFrame
        return fromTabbarSnapshot
    }
    
    @IBInspectable @objc public var qnn_rootContentConfig:RootContentConfigProtocol {
        get {
            guard let value = objc_getAssociatedObject(self, &WZConfigKey) as? RootContentConfigProtocol else {
                self.qnn_rootContentConfig = RootContentConfig()
                return self.qnn_rootContentConfig
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &WZConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 获取navigationController WZRootNavigationController
    @objc public var qnn_navigationController:RootNavigationController? {
        var vc:UIViewController? = self
        while vc != nil && ( vc is RootNavigationController ) == false {
            vc = vc?.navigationController
        }
        return vc as? RootNavigationController
    }
    
    @IBInspectable open var qnn_navigationBarClass: UINavigationBar.Type? {
        get {
            return qnn_rootContentConfig.navigationBarClass
        }
        set {
            qnn_rootContentConfig.navigationBarClass = newValue
        }
    }
    
    @IBInspectable public var qnn_popEdge: UIRectEdge {
        get {
            return qnn_rootContentConfig.popEdge
        }
        set {
            qnn_rootContentConfig.popEdge = newValue
        }
    }
    
    @IBInspectable public var qnn_popAllowedEdge: UIEdgeInsets {
        get {
            return qnn_rootContentConfig.popAllowedEdge
        }
        set {
            qnn_rootContentConfig.popAllowedEdge = newValue
        }
    }
    
    @IBInspectable public var qnn_popGestureProcessing: GestureRecognizerDelegate {
        get {
            return qnn_rootContentConfig.popGestureProcessing
        }
        set {
            qnn_rootContentConfig.popGestureProcessing = newValue
        }
    }
    
    @IBInspectable public var qnn_animationProcessing: TransitionAnimationConvert {
        get {
            return qnn_rootContentConfig.animationProcessing
        }
        set {
            qnn_rootContentConfig.animationProcessing = newValue
        }
    }
    
    @IBInspectable public var qnn_prefersNavigationBarHidden: Bool {
        get {
            return qnn_rootContentConfig.prefersNavigationBarHidden
        }
        set {
            qnn_rootContentConfig.prefersNavigationBarHidden = newValue
        }
    }
    
}





extension CGPoint{
    
    public func wz_direction() -> UIRectEdge{
        if abs(self.x) >= abs(self.y){
            return self.x > 0.0 ? .left : .right
        }else{
            return self.y > 0.0 ? .top : .bottom
        }
    }
}

extension UIPanGestureRecognizer {
    
    @objc public var wz_direction:UIRectEdge{
        return self.translation(in: self.view).wz_direction()
    }
    
    @objc public func wz_direction(in view:UIView?) -> UIRectEdge{
        return self.translation(in: view).wz_direction()
    }
}

extension UIView {
    
    @objc public var wz_scrollView:UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        return superview?.wz_scrollView ?? nil
    }
    
    /// 是否在 view 范围内
    @objc public func wz_isContains(inView view:UIView) -> Bool{
        if isHidden {
            return false
        }
        guard let _ = superview else {
            return false
        }
        let rect = convert(bounds, to: view)
        return view.bounds.contains(rect)
    }
}

extension UIScrollView {
    /// 滑动到最顶部
    @objc public var wz_isSlidingToEdgeTop:Bool {
        if isScrollEnabled == false { return true }
        if contentOffset.y <= 0.0 {
            return superview?.wz_scrollView?.wz_isSlidingToEdgeTop ?? true
        }
        return false
    }
    /// 滑动到最左侧
    @objc public var wz_isSlidingToEdgeLeft:Bool {
        if isScrollEnabled == false { return true }
        if contentOffset.x <= 0.0 {
            return superview?.wz_scrollView?.wz_isSlidingToEdgeLeft ?? true
        }
        return false
    }
    /// 滑动到最底部
    @objc public var wz_isSlidingToEdgeBottom:Bool {
        if isScrollEnabled == false { return true }
        if contentOffset.y >= contentSize.height - frame.height {
            return superview?.wz_scrollView?.wz_isSlidingToEdgeBottom ?? true
        }
        return false
    }
    /// 滑动到最右侧
    @objc public var wz_isSlidingToEdgeRight:Bool {
        if isScrollEnabled == false { return true }
        if contentOffset.x >= contentSize.width - frame.width {
            return superview?.wz_scrollView?.wz_isSlidingToEdgeRight ?? true
        }
        return false
    }
}
