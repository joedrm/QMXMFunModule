//
//  UIImageView+Extension.swift
//  QNN
//
//  Created by Smalla on 2018/11/29.
//  Copyright © 2018 qianshengqian. All rights reserved.
//

import Foundation
import SDWebImage
//import KNSpecs

public extension UIImageView {
    
    /// 用 SDWebImage 加载网络图片，回调加载完成的图片
    ///
    /// - Parameters:
    ///   - urlString: 图片的url
    ///   - placeholder: 占位图片
    ///   - completionImage: 下载完成回调
    ///
    func qnn_load(_ urlString: String, _ placeholder: UIImage? = nil, completionImage: ((UIImage)->())? = nil) {
        
        if urlString.length <= 0 {
            return
        }
        let url = URL(string: urlString)
        if let img = placeholder {
            self.sd_setImage(with: url, placeholderImage: img) { (image, error, type, url) in
                if let currentImage = image {
                    completionImage?(currentImage)
                }
            }
        }else{
            self.sd_setImage(with: url) { (image, error, type, url) in
                if let currentImage = image {
                    completionImage?(currentImage)
                }
            }
        }
    }
    
    /// image fade in time is 0.65
    ///
    /// - Parameter urlString: image url string
    func image(urlString: String) {
        if let url = URL(string: urlString) {
            self.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                let animation = CATransition()
                animation.duration = 0.65
                animation.type = CATransitionType.fade
                animation.isRemovedOnCompletion = true
                self.layer.add(animation, forKey: "transition")
            })
        }
    }
    
    func loadImage(urlStr: String) {
        let url = URL(string: urlStr)
        if let url = url {
            self.sd_setImage(with: url)
        }
    }
    
    func loadImage(urlStr: String, placeholderImage image: UIImage?) {
        let url = URL(string: urlStr)
        if let _ = image {
            self.sd_setImage(with: url, placeholderImage: image!)
        } else {
            self.loadImage(urlStr: urlStr)
        }
    }
    
}
