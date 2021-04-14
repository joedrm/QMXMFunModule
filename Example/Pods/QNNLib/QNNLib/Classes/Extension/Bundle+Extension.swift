//
//  Bundle+Extension.swift
//  QNNLib
//
//  Created by wdy on 2019/3/11.
//

import UIKit

extension QNN where Base: Bundle {
    
    public func filePath(forResource name: String?, ofType ext: String?, inDirectory subpath: String? = "") -> String? {
        
        var path = base.path(forResource: name, ofType: ext, inDirectory: subpath)
        if path != nil {
            return path!
        }
        
        let scale = UIScreen.main.scale
        if abs(scale - 3) <= 0.001 {
            path = self.path_3x(forResource: name, ofType: ext, inDirectory: subpath)
            if path == nil {
                path = self.path_2x(forResource: name, ofType: ext, inDirectory: subpath)
                if path == nil {
                    path = self.path_x(forResource: name, ofType: ext, inDirectory: subpath)
                }
            }
        } else if abs(scale - 2) <= 0.001 {
            path = self.path_2x(forResource: name, ofType: ext, inDirectory: subpath)
            if path == nil {
                path = self.path_3x(forResource: name, ofType: ext, inDirectory: subpath)
                if path == nil {
                    path = self.path_x(forResource: name, ofType: ext, inDirectory: subpath)
                }
            }
        } else {
            path = self.path_x(forResource: name, ofType: ext, inDirectory: subpath)
            if path == nil {
                path = self.path_2x(forResource: name, ofType: ext, inDirectory: subpath)
                if path == nil {
                    path = self.path_3x(forResource: name, ofType: ext, inDirectory: subpath)
                }
            }
        }
        
        return path
    }
    
    private func path_3x(forResource name: String?, ofType ext: String?, inDirectory subpath: String? = "") -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name?.subString(to: (name?.count)! - 3).appending("@3x")
            
        } else {
            tempName = name?.appending("@3x")
        }
        path = base.path(forResource: tempName, ofType: ext, inDirectory: subpath)
        return path
        
    }
    
    private func path_2x(forResource name: String?, ofType ext: String?, inDirectory subpath: String? = "") -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name?.subString(to: (name?.count)! - 3).appending("@2x")
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name
        } else {
            tempName = name?.appending("@2x")
        }
        path = base.path(forResource: tempName, ofType: ext, inDirectory: subpath)
        return path
    }
    
    private func path_x(forResource name: String?, ofType ext: String?, inDirectory subpath: String? = "") -> String? {
        var tempName: String?
        var path: String?
        
        if (name?.hasSuffix("@3x"))! {
            tempName = name?.subString(to: (name?.count)! - 3)
        } else if (name?.hasSuffix("@2x"))! {
            tempName = name?.subString(to: (name?.count)! - 3)
        } else {
            tempName = name
        }
        path = base.path(forResource: tempName, ofType: ext, inDirectory: subpath)
        return path
    }
}
