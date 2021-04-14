//
//  UINavigationBar+Rainbow.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

import Foundation
import UIKit

private var kRainbowAssociatedKey = "kRainbowAssociatedKey"

public class Rainbow: NSObject {
    
    var navigationBar: UINavigationBar
    
    init(navigationBar: UINavigationBar) {
        self.navigationBar = navigationBar
        
        super.init()
    }
    
    fileprivate var navigationView: UIView?
    fileprivate var statusBarView: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var titleForImageView: UIImageView?
    
    public var backgroundColor: UIColor? {
        get {
            return navigationView?.backgroundColor
        }
        set {
            
            if navigationView == nil {
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
                navigationView = UIView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.bounds.width, height: navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height))
                navigationView?.isUserInteractionEnabled = false
                navigationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                //navigationBar.insertSubview(navigationView!, at: 0)
                navigationBar.addSubview(navigationView!)
                navigationBar.bringSubviewToFront(navigationView!)
            }
            
            if titleLabel == nil {
                titleLabel = UILabel(frame: CGRect(x: 0, y: -navigationBar.bounds.height, width: navigationBar.bounds.width, height: navigationBar.bounds.height))
                //titleLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                titleLabel?.textAlignment = .center
                titleLabel?.textColor = UIColor.white
                navigationView?.addSubview(titleLabel!)
            }
            
            if titleForImageView == nil {
                titleForImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
                titleForImageView?.centerX = navigationBar.centerX
                titleForImageView?.centerY = navigationBar.centerY
                navigationView?.addSubview(titleForImageView!)
            }
            navigationView!.backgroundColor = newValue
            navigationView?.isHidden = false
        }
    }
    
    public var navigationTitle: String? {
        get {
            return titleLabel?.text
        }
        set {
            if let str = newValue {
                titleLabel?.text = str
            }else{
                titleLabel?.isHidden = true
            }
        }
    }
    
    public func setTitleImage(_ imgStr: String?) {
        if let str = imgStr {
            titleForImageView?.qnn_load(str)
        }else{
            titleForImageView?.isHidden = true
        }
    }
    
    public func setNavigationViewAlpha (alpha : CGFloat?) {
        navigationView?.alpha = alpha ?? 1
    }
    
    public var statusBarColor: UIColor? {
        get {
            return statusBarView?.backgroundColor
        }
        set {
            if statusBarView == nil {
                statusBarView = UIView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.bounds.width, height: UIApplication.shared.statusBarFrame.height))
                statusBarView?.isUserInteractionEnabled = false
                statusBarView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                if let navigationView = navigationView {
                    navigationBar.insertSubview(statusBarView!, aboveSubview: navigationView)
                } else {
                    navigationBar.insertSubview(statusBarView!, at: 0)
                }
            }
            statusBarView?.backgroundColor = newValue
        }
    }
    public func clear() {
        navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        navigationBar.shadowImage = UIImage.init()
        
        navigationView?.isHidden = true
        //        navigationView?.removeFromSuperview()
        //        navigationView = nil
        //
        //        statusBarView?.removeFromSuperview()
        //        statusBarView = nil
        //
        //        titleLabel?.removeFromSuperview()
        //        titleLabel = nil
        //
        //        titleForImageView?.removeFromSuperview()
        //        titleForImageView = nil
    }
}

public extension UINavigationBar {
    var rb: Rainbow {
        get {
            if let rainbow = objc_getAssociatedObject(self, &kRainbowAssociatedKey) as? Rainbow {
                return rainbow
            }
            let rainbow = Rainbow(navigationBar: self)
            objc_setAssociatedObject(self, &kRainbowAssociatedKey, rainbow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return rainbow
        }
    }
}
