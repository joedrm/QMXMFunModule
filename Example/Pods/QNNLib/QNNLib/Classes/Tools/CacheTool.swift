//
//  CacheTool.swift
//  QNN
//
//  Created by ymy on 2017/7/4.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import UIKit

public class CacheTool: NSObject {
    
    /// 获取缓存路径
    public class func getCachFolderpath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first
        let cachePath = (documentsDirectory! as NSString).appendingPathComponent("Caches")
        let fileManagers = FileManager.default
        if !fileManagers.fileExists(atPath: cachePath) {
            do {
                try fileManagers.createDirectory(atPath: cachePath, withIntermediateDirectories: false, attributes: nil)
            } catch  {
                _ = error as NSError
            }
        }
        return cachePath
    }
    
    /// 缓存中读取数据
    public class func read (path: String) -> NSData? {
        
        if FileManager.default.fileExists(atPath: path) {
            return NSData(contentsOfFile: path)
        }
        return nil
    }
    
    /// 向指定路径中缓存数据
    public class func cache(withfilePath filePath: String, data: Data) {
        if !FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
        // 清除文件，再存入
        do {
            try FileManager.default.removeItem(atPath: filePath)
            try (data as NSData).write(toFile: filePath, options: .atomicWrite)
        } catch _ {
        }
    }
    
    /// 图片缓存路径
    public class func imageCachePath(imageName: String) -> String {
        let imageCacheFolderPath = (CacheTool.getCachFolderpath() as NSString).appendingPathComponent("imageCatchs")
        let imageCachePath = (imageCacheFolderPath as NSString).appendingPathComponent(imageName)
        return imageCachePath
    }
    
    /// 获取头像缓存地址
    public class func imageUserAvatarCachePath() -> String {
        return CacheTool.imageCachePath(imageName: "head.jpg")
    }
}
