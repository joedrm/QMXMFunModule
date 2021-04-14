//
//  UIViewController+Extension.swift
//  Alamofire
//
//  Created by joewang on 2019/1/16.
//

import Foundation


// MARK: - 取列表总行数
extension QNN where Base: UIViewController{
    
    public func scrollViewOffsetIssue(_ scrollView: UIScrollView) {
        base.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    /// 设置控制器的View上为scrollView及其子类占满全屏，
    ///
    /// - Parameters:
    ///   - scrollView: scrollView及其子类
    ///   - showTabbar: 底部是否显示 Tabbar
    public func scrollViewExtendToFullScreen(_ scrollView: UIScrollView, _ showTabbar : Bool = false) {
        base.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
        let tabberHeight = showTabbar ? (base.tabBarController?.tabBar.frame.height ?? 49) : 0
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navHeight = base.navigationController?.navigationBar.frame.height ?? 0
        let insets = UIEdgeInsets(top: statusbarHeight + navHeight, left: 0, bottom: tabberHeight, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    
    func backToViewController(className: String, animated: Bool) {
        if ((base.navigationController) != nil) {
            let controllers: Array = (base.navigationController?.viewControllers) ?? []
            let res = controllers.filter { (item) -> Bool in
                guard let aClass = NSClassFromString(className) else {
                    return false
                }
                return item.isKind(of: aClass)
            }
            if (res.count > 0) {
                base.navigationController?.popToViewController(res[0], animated: animated)
            }
        }
    }
}

