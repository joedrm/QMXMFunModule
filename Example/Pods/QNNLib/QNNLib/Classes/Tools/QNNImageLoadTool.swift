//
//  QNNImageLoadTool.swift
//  QNN
//
//  Created by joewang on 2018/9/25.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit
import SDWebImage

public class QNNImageLoadTool: NSObject {
    
    /// 下载图片，会清理之前缓存的图片
    public class func qnn_downloadImage(_ urlStr: String, completion: @escaping ((UIImage?)->())) {
        
        guard urlStr.length > 0 else {
            completion(nil)
            return
        }
        
        let url: URL = URL(string: urlStr.deleteSpace())!
        let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
        
        guard let key = cacheKey,
            key.length > 0 else {
                SDWebImageManager.shared.loadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: nil) { (image, data, error, cacheType, bool, url) in
                    completion(image)
                }
                return
        }
        
        SDImageCache.shared.removeImage(forKey: cacheKey) {
            SDWebImageManager.shared.loadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: nil) { (image, data, error, cacheType, bool, url) in
                DispatchQueue.main.async(execute: {
                    completion(image)
                })
            }
        }
    }
    
    
    // 清除图片缓存
    public class func cleanCache(completion: @escaping (()->())){
        
        SDWebImageManager.shared.imageCache.clear(with: .disk) {
            completion()
        }
    }
    
    
    /// 从mianbundle获取图片
    ///
    /// - Parameter imgName: 图片名
    /// - Returns: 图片
    public class func getImageFormMainBundle(_ imgName:String) -> UIImage{
        if let imgString = Bundle.main.path(forResource: imgName, ofType: ".png", inDirectory: nil) {
            return UIImage.init(contentsOfFile: imgString)!
        }
        return UIImage.init()
    }
    
    
    
    /// 从bundle里面获取图片
    ///
    /// - Parameters:
    ///   - bundleName: bundle名
    ///   - imgName: 图片名
    /// - Returns: 图片
    public class func getImageFromBundle(_ bundleName:String, _ imgName:String) -> UIImage{
        guard let bundle = Bundle.main.path(forResource: bundleName, ofType: "bundle"),
            let imgString = Bundle(path: bundle)?.path(forResource: imgName, ofType: ".png", inDirectory: nil)
            else {
                return UIImage.init()
        }
        return UIImage.init(contentsOfFile: imgString)!
    }
}


