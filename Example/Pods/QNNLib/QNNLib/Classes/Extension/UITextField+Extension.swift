//
//  UITextField+Extension.swift
//  QNN
//
//  Created by Smalla on 2017/12/18.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation

public extension UITextField {
    /// 只能输入数字(添加到 EditingChanged)
    /// eg: addTarget(self, action: #selector(textFieldChange), forControlEvents: .EditingChanged)
    func qnn_numberOnly() {
        if let textFieldText = self.text {
            if textFieldText.length > 0 {
                let text = textFieldText.filter({ (c) -> Bool in
                    if "0123456789".contains(String(c)) { return true }
                    else {  return false }
                })
                self.text! = String(text)
                
                if self.text!.length > 0 {
                    let str = (String(text) as NSString).substring(with: NSRange(location: 0, length: 1))
                    if str == "0" {  self.text! = "" }
                }
            }
        }
    }
    
    /// 限制输入框输入空格
    func limitSpace(range: NSRange, string: String) -> Bool {
        let text = self.text?.replaceRange(inRange: range, withStr: string)
        let spaceRange = text!.rangeOfString(str: " ")
        return spaceRange.length <= 0
    }
    
    func limiteCardNum(range: NSRange, string: String, count: Int) -> Bool {// 限制输入框输入位数
        if range.location >= count || string.length > count {
            return false
        }
        
        let textFieldLength = NSString(string: self.text!).length
        let replacementTextLength = NSString(string: string).length
        if replacementTextLength + textFieldLength > count{
            return false
        }
        
        // 限制输入框只能输入阿拉伯数字
        let limit = self.limitTextFieldText(text: "0123456789Xx", string: string)
        return limit
    }
}
