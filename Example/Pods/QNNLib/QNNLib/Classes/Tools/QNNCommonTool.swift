//
//  QNNCommonTool.swift
//  QNNLib
//
//  Created by joewang on 2019/1/3.
//

import Foundation

public class QNNCommonTool: NSObject {
    
    
}


// MARK: - 打开外部APP
public extension QNNCommonTool {
    
    static func openUrl(from urlStr: String) {
        guard urlStr.length > 0 else {
            return
        }
        
        guard let url = URL(string: urlStr.deleteSpace()) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}



// MARK: - 系列化 和 反系列化
public extension QNNCommonTool {
    
    /// 字符串类型转json
    static func stringToDicData(_ param: String) -> [AnyHashable : Any]? {
        let data = param.data(using: .utf8)
        if let _ = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [AnyHashable: Any]
                return json
            } catch {
                print("Serializat json error: \(error)")
            }
        }
        return nil
    }
    
    /// 字符串类型转json
    static func stringToArrData(_ param: String) -> [Any]? {
        let data = param.data(using: .utf8)
        if let _ = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [Any]
                return json
            } catch {
                print("Serializat json error: \(error)")
            }
        }
        return nil
    }
    
    /// 字典转JSON字符串
    static func convertDictionaryToString(_ params: [String:String]) -> String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
}


extension QNNCommonTool {
    
    
    /// 获取当前bundle中的图片
    ///
    /// - Parameters:
    ///   - aClass: 所在的类
    ///   - imgName: 图片名
    /// - Returns: 图片
    public class func image(for aClass: AnyClass?, _ imgName: String?) -> UIImage {
        guard let cls = aClass else {
            return UIImage()
        }
        guard let imgN = imgName else {
            return UIImage()
        }
        let bundle = Bundle(for: cls)
        let scale = Int(UIScreen.main.scale)
        let imgStr = "\(imgN)@\(scale)x.png"
        if let imgFilePath = bundle.path(forResource: imgStr, ofType: nil, inDirectory: QNNLibBundle) {
            return UIImage.init(contentsOfFile: imgFilePath) ?? UIImage()
        }
        return UIImage()
    }
    
    
}
