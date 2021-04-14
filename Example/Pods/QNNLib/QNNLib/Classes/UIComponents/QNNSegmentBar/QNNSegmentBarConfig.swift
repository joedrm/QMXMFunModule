//
//  QNNSegmentBarConfig.swift
//  QNN
//
//  Created by joewang on 2018/9/28.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit

public class QNNSegmentBarConfig: NSObject {
    
    public var segmentBarBackColor:UIColor = adaptColor(with: UIColor.white, dark: UIColor(hexadecimalString: "1C1C1C"))
    public var itemNormalColor:UIColor = UIColor.lightGray
    public var itemSelectColor:UIColor = UIColor.red
    
    public var itemFont:UIFont = UIFont.systemFont(ofSize: 15)
    
    public var indicatorColor:UIColor = UIColor.red
    public var indicatorHeight:CGFloat = 3
    public var indicatorExtraW:CGFloat = 30
    public var indicatorLimitW:CGFloat = 0 // 固定的宽度
    public var indicatorFromBottom:CGFloat = 0 // 底部的高度
    
    public class func defaultConfig() -> QNNSegmentBarConfig {
        let conf = QNNSegmentBarConfig.init()
        return conf
    }
}
