//
//  UIScrollView+Extension.swift
//  QNN
//
//  Created by joewang on 2018/10/8.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import Foundation

extension QNN where Base: UIScrollView {
    
    public func fixedAutomaticallyAdjustsScrollView() {
        if #available(iOS 11.0, *) {
            base.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    /// UIScrollView 及 子类 布局时伸展到整个屏幕
    ///
    /// - Parameter vc: UIScrollView所在的当前控制器
    public func fullScreen(_ vc: UIViewController?) {
        guard let vc = vc else {
            return
        }
        vc.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            base.contentInsetAdjustmentBehavior = .never
        }else {
            vc.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// UIScrollView 及 子类 布局时伸展到整个屏幕，并设置contentInset
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - showTabbar: 是否有 tabbar
    public func extendToFullScreen(_ vc: UIViewController?, _ showTabbar : Bool = false) {
        guard let vc = vc else {
            return
        }
        vc.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            base.contentInsetAdjustmentBehavior = .never
        }else {
            vc.automaticallyAdjustsScrollViewInsets = false
        }
        let tabberHeight = showTabbar ? (vc.tabBarController?.tabBar.frame.height ?? 49) : 0
        let insets = UIEdgeInsets(top: TopLayoutDefaultHeight, left: 0, bottom: tabberHeight, right: 0)
        base.contentInset = insets
        base.scrollIndicatorInsets = insets
    }
    
    
}
