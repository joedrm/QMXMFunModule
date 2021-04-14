//
//  ValidateTool.swift
//  QNN
//
//  Created by joewang on 2018/9/21.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit
import Foundation

public enum QNNValidate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    case verifyCode(_: String)
    
    
    public var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            //predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            predicateStr = "^1\\d{10}$"
            currObject = str
        case let .password(str):
            predicateStr = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}"
            currObject = str
        case let .verifyCode(str):
            predicateStr = "^\\w{4,8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}




