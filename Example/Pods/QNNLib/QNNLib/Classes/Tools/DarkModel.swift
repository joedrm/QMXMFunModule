//
//  DarkModel.swift
//  QNN
//
//  Created by Smalla on 2019/10/18.
//  Copyright © 2019 qianshengqian. All rights reserved.
//

import Foundation

// MARK: -- iOS13颜色适配 --

/// 是否为深色模式
public func isDarkMode() -> Bool {
    if #available(iOS 13.0, *) {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

/// 根据不同场景适应不同自定义颜色值，注意，：该方法返回 UIColor
public func adaptColor(with light: UIColor, dark: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
        let resultColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else {
                return light
            }
        })
        return resultColor
    }
    return light
}

/// 根据不同场景适应不同自定义颜色值，注意，：该方法返回十六进制Color颜色值
public func adaptColorStr(with light: String, dark: String) -> String {
    if isDarkMode() {
        return dark
    } else {
        return light
    }
}

/// 获取当前图片
public func getCurrentImage(with name: String) -> UIImage {
    return UIImage(named: name) ?? UIImage()
}

/// 根据系统模式适配图片透明度
public func adaptImage(with lightAlpha: CGFloat, darkAlpha: CGFloat) -> CGFloat {
    if isDarkMode() {
        return darkAlpha
    } else {
        return lightAlpha
    }
}
