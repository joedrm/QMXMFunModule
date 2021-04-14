//
//  String+Extension.swift
//  QNN
//
//  Created by Smalla on 2017/12/18.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

public extension String {
    
    var md5: String! {
        guard let data = data(using: .utf8) else { return self }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    // 计算字符串尺寸
    func sizeWith(_ font: UIFont) -> CGSize {
        let text = self as NSString
        let size = text.size(withAttributes: [NSAttributedString.Key.font : font])
        return size
    }
    
    
    /*
     
     html字符串转成文本属性字符串
     运行环境低于 iOS 9 的时候，一运行直接crash，其它版本的系统也会偶现crash
     报错：dyld: Symbol not found: _NSCharacterEncodingDocumentOption
     
     参考：https://stackoverflow.com/questions/46484650/documentreadingoptionkey-key-corrupt-after-swift4-migration
     
    func html2AttrStrWithFontSize(fontSize:CGFloat = 12) -> NSAttributedString? {
        if #available(iOS 9.0, *) {
            //高于 iOS 9.0
            do {
                let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
                if let d = data {
                    
                    let attrString = try NSAttributedString(data: d,
                                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                                            documentAttributes: nil)
                    let myAttrString = NSMutableAttributedString.init(attributedString: attrString)
                    let myAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)] as [NSAttributedStringKey : Any]
                    myAttrString.addAttributes(myAttribute, range: NSMakeRange(0, myAttrString.length))
                    return myAttrString
                }
            } catch {
                print("error:", error)
            }
            return  nil
        } else {
            //低于 iOS 9.0
            do {
                let data = self.data(using: String.Encoding.utf32, allowLossyConversion: true)
                if let d = data {
                    
                    
                    let attrString = try NSAttributedString(data: d,
                                                            options: [.documentType: NSAttributedString.DocumentType.html],
                                                            documentAttributes: nil)
                    let myAttrString = NSMutableAttributedString.init(attributedString: attrString)
                    let myAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)] as [NSAttributedStringKey : Any]
                    myAttrString.addAttributes(myAttribute, range: NSMakeRange(0, myAttrString.length))
                    return myAttrString
                }
            } catch {
                print("error:", error)
            }
            return  nil
        }
    }
     */
    
    func getStringRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
}

/// 计算文字的宽高
extension QNNStructProtocol where Base == String {
    
    func height(maxWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(maxHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


// MARK: - 字符串的截取
extension String {
    public func subString(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(from: Int, to: Int) -> String {
        if to > from && self.count >= to {
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(self.startIndex, offsetBy: to)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func subString(range: NSRange) -> String {
        let from: Int = range.location;
        let to: Int = range.length + from
        return subString(from: from, to: to)
    }
    
    /// 过滤掉首尾空格, 根据参数判断是否过滤换行符
    /// trimNewline 是否过滤略行符，默认为false
    public func trim(trimNewline: Bool = false) -> String {
        if trimNewline {  //  忽略掉换行符
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// 过滤掉换行符
    public func trimNewlines() -> String {
        return self.trimmingCharacters(in: .newlines)
    }
}
