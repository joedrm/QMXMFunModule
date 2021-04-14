//
//  UIView+Extension.swift
//  QNN
//
//  Created by joewang on 2018/9/7.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import Foundation
import Then


/// 绘制圆角
public extension UIView {
    
    
    /// 部分圆角
    /* 使用
     
     // 调用没有任何问题，将左上角与右上角设为圆角。
     button.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 5)
     
     // 编译错误
     let corners: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
     button.corner(byRoundingCorners: corners, radii: 5)
     */
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func clipAllCorner(_ radii: CGFloat) {
        corner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topLeft, UIRectCorner.topRight], radii: radii)
    }
}

/// Gesture
var blockActionDict : [String : ( () -> () )] = [:]
public extension UIView{
    
    /// 返回所在控制器
    func viewController() -> UIViewController? {
        var next = self.next
        while((next) != nil){
            if(next!.isKind(of: UIViewController.self)){
                let rootVc = next as! UIViewController
                return rootVc
            }
            next = next?.next
        }
        return nil
    }
    
    /// view以及其子类的block点击方法
    func tapActionsGesture(action:@escaping ( () -> Void )){
        addBlock(block: action)//添加点击block
        whenTouchOne()//点击block
    }
    
    /// 创建唯一标示  方便在点击的时候取出
    private func addBlock(block:@escaping ()->()){
        blockActionDict[String(self.hashValue)] = block
    }
    
    private func whenTouchOne(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapActions))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapActions(){
        blockActionDict[String(self.hashValue)]!()
    }
}


/// 获取一个UIView及子类的唯一标示，通常用在 Cell 的 identifier
public extension UIView {
    static var defaultReusableId: String {
        let arr = self.description().components(separatedBy: ".")
        if arr.count > 1 {
            return arr.dropFirst().joined(separator: ".")
        } else if arr.count == 1 {
            return arr.first ?? ""
        } else {
            assertionFailure("类型转字符串失败")
            return ""
        }
    }
}

//  TODO: UIView Extension
public extension UIView {
    //  上边线
    func addTopLine(lineColor: UIColor = UIColor(hexadecimalString: "#E3E3E3")) {
        _ = UIView().then({ (v) in
            addSubview(v)
            v.backgroundColor = lineColor
            v.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(0.5)
            })
        })
    }
    
    //  底部线
    func addBottomline(lineColor: UIColor = UIColor(hexadecimalString: "#E3E3E3")) {
        _ = UIView().then { (v) in
            addSubview(v)
            v.backgroundColor = lineColor
            v.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0.5)
            })
        }
    }
    
    //  左边线
    func addLeftLine(lineColor: UIColor = UIColor(hexadecimalString: "#E3E3E3")) {
        _ = UIView().then { (v) in
            addSubview(v)
            v.backgroundColor = lineColor
            v.snp.makeConstraints({ (make) in
                make.top.bottom.left.equalTo(0)
                make.width.equalTo(0.5)
            })
        }
    }
    
    //  右边线
    func addRightLine(lineColor: UIColor = UIColor(hexadecimalString: "#E3E3E3")) {
        _ = UIView().then { (v) in
            addSubview(v)
            v.backgroundColor = lineColor
            v.snp.makeConstraints({ (make) in
                make.top.right.bottom.equalTo(0)
                make.width.equalTo(0.5)
            })
        }
    }
}
