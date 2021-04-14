//
//  JSONService.swift
//  QNN
//
//  Created by Smalla on 2017/12/19.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation
import SwiftyJSON

public class QNNStringToModel<Model: NSObject> {
    
    public init(){
        
    }
    
    public func toModelArr(_ jsonStr: String) -> [Model] {
        let model = ModelService<Model>().reflectArr(jsonString: jsonStr)
        return model
    }
    
    public func toModelDic(_ jsonStr: String) -> Model {
        let model = ModelService<Model>().reflectDic(jsonString: jsonStr)
        return model
    }
}

public class ModelService<Model: NSObject> {
    /// json字符串转数组类型
    public func reflectArr(jsonString: String?) -> [Model] {
        if let jsonString = jsonString {
            let data = jsonString.data(using: .utf8)
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    debugPrint(json)
                    let model = Reflect<Model>.mapObjects(json: json as AnyObject)
                    return model
                } catch {
                    debugPrint("jsonString 解析错误")
                    return [Model]()
                }
            } else {
                debugPrint("jsonString 解析错误")
                return [Model]()
            }
        } else {
            debugPrint("jsonString 不存在，初始化一个空的Model")
            return [Model]()
        }
    }
    
    /// json字符串转对象类型
    public func reflectDic(jsonString: String?) -> Model {
        if let jsonString = jsonString {
            let data = jsonString.data(using: .utf8)
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    debugPrint(json)
                    let model = Reflect<Model>.mapObject(json: json as AnyObject)
                    return model
                } catch {
                    debugPrint("jsonString 解析错误")
                    return Model()
                }
            } else {
                debugPrint("jsonString 解析错误")
                return Model()
            }
        } else {
            debugPrint("jsonString 不存在，初始化一个空的Model")
            return Model()
        }
    }
}

public class JSONService<Model: NSObject> {
    public class func modelWithJSON(fileName: String) -> Model {
        let json = JSONService.readJSONFile(name: fileName)
        if let json = json {
            let model =  Reflect<Model>.mapObject(json: json as AnyObject)
            return model
        } else {
            debugPrint("json 不存在，初始化一个空的Model")
            return Model()
        }
    }
    
    public class func readJSONFile(name: String) -> Any? {
        let path = Bundle.main.path(forResource: name, ofType: "json") ?? ""
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                debugPrint(json)
                return json
            } catch {
                debugPrint("json 解析错误")
                return nil
            }
        } else {
            debugPrint("path=\(path) 错误，文件不存在")
            return nil
        }
    }
}

