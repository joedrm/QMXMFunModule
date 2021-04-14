//
//  QNNHTMLToAttrString.swift
//  QNN
//
//  Created by joewang on 2018/10/11.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit
import Fuzi

public class QNNCSSStyleModel: NSObject {
    
    @objcMembers
    public class QNNCSSElementModel: NSObject {
        public var color : String?
        public var fontSize : String?
        public var backgroundColor : String?
        public var string : String?
        public var range : NSRange?
        public var bold = false
        
    }
    
    public var totalString : String?
    public var attrString : NSMutableAttributedString?
    public var elements :Array<QNNCSSElementModel> = []
}



/// 利用libxml2 来解析 html 标签
public class QNNHTMLParseTool: NSObject {
    
    
    /// 将 html 字符串转化为 NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - html: html格式字符串
    ///   - fontSize: 字体大小
    ///   - textColor: 文字颜色
    /// - Returns: NSMutableAttributedString
//    public class func htmlToAttrString(_ html:String?, fontSize:CGFloat, bold: Bool, textColor:String?) -> NSMutableAttributedString {
//        let finalHTMLStr = html?.replaceStr(ofStr: "<br />", withStr: "\n")
//        let styleModel = htmlToCSSStyleModel(finalHTMLStr, fontSize, bold, textColor)
//        if let str = styleModel.attrString {
//            return str
//        }
//        return NSMutableAttributedString.init()
//    }
//
//
//
//    public class func htmlToCSSStyleModel(  _ html:String?,
//                                          _ fontSize:CGFloat = 12,
//                                          _ bold: Bool = false,
//                                          _ textColor: String?) -> QNNCSSStyleModel {
//
//        let styleModel = QNNCSSStyleModel()
//
//        guard let html = html else {
//            return styleModel;
//        }
//
//        do {
//            let doc = try HTMLDocument(string: "<p>\(html)</p>", encoding: .utf8)
//
//            if let firstChild = doc.firstChild(xpath: "body/p") {
//
//                styleModel.totalString = firstChild.stringValue
//
//                let myAttrString = NSMutableAttributedString.init(string: firstChild.stringValue)
//
//                var attr : [NSAttributedString.Key : Any] = [:]
//
//                if bold {
//                    attr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
//                }else{
//                    attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
//                }
//
//                if let color = textColor {
//                    attr[NSAttributedString.Key.foregroundColor] = UIColor(hexadecimalString: color)
//                }
//
//                myAttrString.addAttributes(attr, range: NSMakeRange(0, myAttrString.length))
//
//                let childs = firstChild.children(tag: "span")
//                childs.forEach({ (element) in
//
//                    var myAttribute : [NSAttributedString.Key : Any] = [:]
//
//                    guard let cssAttrs = (element.attr("style")?.trimSpace() as AnyObject).split(separator: ";") else{
//                        return;
//                    }
//
//                    let cssModel = QNNCSSStyleModel.QNNCSSElementModel()
//
//                    cssModel.range = firstChild.stringValue.rangeOfString(str: element.stringValue)
//                    cssModel.string = element.stringValue
//
//                    cssAttrs.forEach({ (string) in
//                        let attr = string.split(separator: ":")
//                        if attr.count > 0, let attrName = attr.first, let attrValue = attr.last{
//                            switch attrName {
//                            case "color" :
//                                cssModel.color = String(attrValue)
//                                myAttribute[NSAttributedString.Key.foregroundColor] = UIColor(hexadecimalString: String(attrValue))
//                            case "font-size" :
//                                cssModel.fontSize = String(attrValue)
//                            //myAttribute[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: CGFloat((attrValue as NSString).floatValue))
//                            case "background-color" :
//                                cssModel.backgroundColor = String(attrValue)
//                                myAttribute[NSAttributedString.Key.backgroundColor] = UIColor(hexadecimalString: String(attrValue))
//                            case "font-weight" :
//                                if String(attrValue) == "bold" {
//                                    cssModel.bold = true
//                                }else{
//                                    cssModel.bold = false
//                                }
//                            default:
//                                break
//                            }
//                        }
//                    })
//
//
//                    // 添加字体加粗
//                    if let fontSize = cssModel.fontSize {
//                        var font = UIFont.systemFont(ofSize: CGFloat(fontSize.floatValue))
//                        if cssModel.bold{
//                            font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize.floatValue))
//                        }
//                        myAttribute[NSAttributedString.Key.font] = font
//                    }else {
//                        myAttribute[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: fontSize)
//                    }
//
//                    myAttrString.addAttributes(myAttribute, range: cssModel.range!)
//                    styleModel.elements.append(cssModel)
//
//                })
//
//                styleModel.attrString = myAttrString
//
//            }
//
//        } catch let error {
//
//            debugPrint("htmlToAttrString：\(error)")
//
//        }
//
//        return styleModel
//    }
    
}


public extension String {
    
//    func html2AttrStrWithFontSize(fontSize:CGFloat = 12, _ bold:Bool = false, textColor: String) -> NSAttributedString? {
//        return QNNHTMLParseTool.htmlToAttrString(self, fontSize: fontSize, bold: bold, textColor: textColor)
//    }
}
