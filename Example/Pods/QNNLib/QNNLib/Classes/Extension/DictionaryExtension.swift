//
//  File.swift
//  KFQ
//
//  Created by zhenyu on 17/4/26.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
     字典转Json字符串
     */
    public func toString() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let strJSON = String(data: data, encoding: String.Encoding.utf8)
            
            return strJSON ?? ""
        } catch {
            debugPrint("Error: Dictionary to String fail")
            return ""
        }
    }
}

public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
