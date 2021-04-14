//
//  QNNSearchBarConfig.swift
//  QNN
//
//  Created by wdy on 2018/9/3.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit

public struct QNNSearchBarConfig {
    
    public var animationDuration: TimeInterval = 0.25
    public var rasterSize: CGFloat = 11.0
    public var textAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : defaultTextForegroundColor]
    public var textContentType: String? = nil
    public var useCancelButton: Bool = true
    public var cancelButtonTitle: String = "取消"
    public var cancelButtonTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : defaultTextForegroundColor]
    public var leftView: UIView? = nil
    public var leftViewMode: UITextField.ViewMode = .never
    public var rightView: UIView? = nil
    public var rightViewMode: UITextField.ViewMode = .always
    public var clearButtonMode: UITextField.ViewMode = .whileEditing
    
    public init() {}
    
    public static var defaultTextForegroundColor = UIColor.black
}

