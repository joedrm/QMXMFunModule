//
//  UIImage+Extension.swift
//  QNN
//
//  Created by Smalla on 2017/12/19.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    /// 获取视图快照图片
    /// 必须在主线程上执行
    ///
    /// - Parameter view: 需要生成快照的视图
    /// - Returns: 快照图片
    static func qnn_snapshot(_ view: UIView) -> UIImage? {
        if !Thread.isMainThread {
            assert(false, "UIImage.\(#function) must be called from main thread only.")
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片进行裁剪
    ///
    /// - Parameters:
    ///   - image: image: 需要处理图片
    ///   - maxSize: 最大尺寸
    ///   - maxDataSize: 图片数据最大值 maxDataSize = 12 代表不超过过12k
    ///   - reduceFrequency: 压缩图片时降低频率
    /// - Returns: 图片data值
    class func generateImageData(image: UIImage, maxSize: CGSize, maxDataSize: Int, reduceFrequency: Double) -> NSData? {
        if ( maxSize.width <= 0 || maxSize.height <= 0)
        {
            return nil;
        }
        
        var tempImage = image.copy() as! UIImage
        
        tempImage = tempImage.imageWithSize(size: maxSize)
        
        var imageData = Data()
        
        for index in stride(from: 1.0, to: 0.0, by: -reduceFrequency) {
            let tepresentationImageData = tempImage.jpegData(compressionQuality: CGFloat(index))
            guard let _ =  tepresentationImageData else {
                return nil
            }
            imageData = tepresentationImageData!
            if ((imageData as NSData).length < maxDataSize * 1024)
            {
                break
            }
        }
        
        if ((imageData as NSData).length  > maxDataSize * 1024)
        {
            return UIImage .generateImageData(image: image, maxSize: CGSize(width: maxSize.width * 0.9, height: maxSize.height * 0.9), maxDataSize: maxDataSize, reduceFrequency: -0.2)
        }
        return imageData as NSData?
    }
    
}


extension UIImage{
    // 图片处理
    // 指定大小缩放图片 返回图片
    
    public func imageCompressForSizeToTargetSize(sourceImage:UIImage,targetSize:CGSize) ->UIImage{
        // 创建新的图片
        var newImage:UIImage = UIImage()
        let imageSize:CGSize = sourceImage.size
        // 旧图片的宽 高
        let width = imageSize.width
        let height = imageSize.height
        //  新图片的宽 高
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        // 缩放比例
        var scaleFactor:CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint.zero
        
        
        if imageSize.equalTo(size) {
            return sourceImage
        }else{
            // 缩放比例
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                // 为了避免图片缩放后被拉伸，缩放比例 按照长的进行计算
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        // 绘制图形
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in:thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    // 指定宽度按比例缩放
    public func imageCompressForWidth( targetWidth:CGFloat) ->UIImage{
        // 创建新的图片
        var newImage:UIImage = UIImage()
        let imageSize:CGSize = self.size
        // 旧图片的宽 高
        let width = imageSize.width
        let height = imageSize.height
        //  新图片的宽 高
        let targetWidth = targetWidth
        let targetHeight = height / width * targetWidth
        let size = CGSize(width: targetWidth, height: targetHeight)
        
        // 缩放比例
        var scaleFactor:CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint.zero
        if imageSize.equalTo(size) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(size)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        self.draw(in:thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
    
}
