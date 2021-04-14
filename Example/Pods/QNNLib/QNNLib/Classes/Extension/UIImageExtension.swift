//
//  UIImageExtension.swift
//  QQT
//
//  Created by 张霄男 on 15/9/17.
//  Copyright (c) 2015年 qianshengqian.com. All rights reserved.
//

import UIKit

@objc public extension UIImage {
    
    @objc class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     缩放图片
     */
    @objc func imageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return currentImage!
    }
    
    @objc func resizeToSize(_ targetSize: CGSize, padding: CGFloat = 0) -> UIImage? {
        let newSize = self.size.scaledSize(targetSize)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect.insetBy(dx: padding, dy: padding))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @objc class func snapshot(_ view: UIView) -> UIImage? {
        if !Thread.isMainThread {
            assert(false, "UIImage.\(#function) must be called from main thread only.")
        }
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
