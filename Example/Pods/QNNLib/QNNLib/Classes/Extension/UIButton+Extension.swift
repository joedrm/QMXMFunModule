//
//  UIButton+Extension.swift
//  QNN
//
//  Created by joewang on 2018/9/18.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import Foundation


public enum QNNButtonImagePositionStyle {
    /// 图片在左，文字在右
    case Default
    /// 图片在右，文字在左
    case ImageRight
    /// 图片在上，文字在下
    case ImageTop
    /// 图片在下，文字在上
    case ImageBottom
}

public extension UIButton {
    
    
    /// 快速创建一个按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体
    ///   - normalColor: 普通状态下文字颜色
    ///   - highlightedColor: 高亮状态下文字颜色
    /// - Returns: UIButton
    class func qnn_textBtn(title:String, fontSize:UIFont, normalColor:UIColor, highlightedColor:UIColor) -> UIButton{
        return qnn_textBtn(title: title, fontSize: fontSize, normalColor: normalColor, highlightedColor: highlightedColor, bgImageName: nil, selector:nil, target:nil)
    }
    
    
    /// 快速创建一个按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体
    ///   - normalColor: 普通状态下文字颜色
    ///   - highlightedColor: 高亮状态下文字颜色
    ///   - selector: 点击执行的事件
    ///   - target: 事件委托对象
    /// - Returns: UIButton
    class func qnn_textBtn(title:String, fontSize:UIFont, normalColor:UIColor, highlightedColor:UIColor, selector: Selector?, target: Any?) -> UIButton{
        return qnn_textBtn(title: title, fontSize: fontSize, normalColor: normalColor, highlightedColor: highlightedColor, bgImageName: nil, selector:selector, target:target)
    }
    
    
    
    class func qnn_textBtn(title:String, fontSize:UIFont, normalColor:UIColor, highlightedColor:UIColor, bgImageName:String?, selector: Selector?, target: Any?) -> UIButton{
        let button = UIButton.init(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(highlightedColor, for: .normal)
        button.titleLabel?.font = fontSize
        
        if let bgImgName = bgImageName,
            let bgImage = UIImage(named: bgImgName){
            button.setBackgroundImage(bgImage, for: .normal)
        }
        
        if let bgImgNameHL = bgImageName?.appending("_highlighted"),
            let bgImageHL = UIImage(named: bgImgNameHL){
            button.setBackgroundImage(bgImageHL, for: .highlighted)
        }
        
        if let sel = selector,
            let tar = target{
            button.addTarget(tar, action: sel, for: .touchUpInside)
        }
        
        button.sizeToFit()
        return button
    }
    
    func qnn_imageBtn(imageName:String?, bgImageName:String?){
        
        if let imgName = imageName,
            let image = UIImage(named: imgName){
            self.setImage(image, for: .normal)
        }
        
        if let imgNameHL = imageName?.appending("_highlighted"),
            let imageHL = UIImage(named: imgNameHL){
            self.setBackgroundImage(imageHL, for: .highlighted)
        }
        
        
        if let bgImgName = bgImageName,
            let bgImage = UIImage(named: bgImgName){
            self.setBackgroundImage(bgImage, for: .normal)
        }
        
        if let bgImgNameHL = bgImageName?.appending("_highlighted"),
            let bgImageHL = UIImage(named: bgImgNameHL){
            self.setBackgroundImage(bgImageHL, for: .highlighted)
        }
        
        self.sizeToFit()
    }
    
    
    /// 设置按钮风格
    ///
    /// - Parameters:
    ///   - style: 风格
    ///   - space: 图片和文本的间距
    ///   - imagePositionBlock: 回调，在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
    func qnn_imagePositionStyle(style:QNNButtonImagePositionStyle, space:CGFloat, imagePositionBlock:((_ button:UIButton)->())?) {
        
        if let block = imagePositionBlock {
            block(self)
        }
        
        if (style == .Default) {
            
            if (self.contentHorizontalAlignment == .left) {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
            } else if (contentHorizontalAlignment == .right) {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * space, bottom: 0, right: 0.5 * space)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: -0.5 * space)
            }
            
        } else if (style == .ImageRight) {
            
            let imageW = imageView?.image?.size.width ?? 0.0
            let titleW = titleLabel?.frame.size.width ?? 0.0
            
            if self.contentHorizontalAlignment == .left {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleW + space, bottom: 0, right: 0)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageW, bottom: 0, right: 0)
            } else if contentHorizontalAlignment == .right {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleW)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageW + space)
            } else {
                let imageOffset = titleW + 0.5 * space
                let titleOffset = imageW + 0.5 * space
                imageEdgeInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
            }
        } else if (style == .ImageTop) {
            
            let imageW = imageView?.frame.size.width ?? 0.0
            let imageH = imageView?.frame.size.height ?? 0.0
            let titleLabelContentW = titleLabel?.intrinsicContentSize.width ?? 0.0
            let titleLabelContentH = titleLabel?.intrinsicContentSize.height ?? 0.0
            imageEdgeInsets = UIEdgeInsets(top: -titleLabelContentH - space, left: 0, bottom: 0, right: -titleLabelContentW)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageW, bottom: -imageH - space, right: 0)
            
        } else if (style == .ImageBottom) {
            
            let imageW = imageView?.frame.size.width ?? 0.0
            let imageH = imageView?.frame.size.height ?? 0.0
            let titleLabelContentW = titleLabel?.intrinsicContentSize.width ?? 0.0
            let titleLabelContentH = titleLabel?.intrinsicContentSize.height ?? 0.0
            imageEdgeInsets = UIEdgeInsets(top: titleLabelContentH + space, left: 0, bottom: 0, right: -titleLabelContentW)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageW, bottom: imageH + space, right: 0)
        }
    }
}

