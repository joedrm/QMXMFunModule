//
//  RootContentConfigProtocol.swift
//  QNN
//
//  Created by joewang on 2019/3/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//


import UIKit


/// 转场动画协议
@objc public protocol ViewControllerAnimatedTransitioning:UIViewControllerAnimatedTransitioning {
    
    ///
    var interactiveTransition:UIPercentDrivenInteractiveTransition? { get set }
    
    ///
    var operation:UINavigationController.Operation { get set }
    
    /// weak
    weak var transitionContext:UIViewControllerContextTransitioning? { get set }
}


/// 转场动画转换协议 方便自定义转场协议 为了兼容ObjC Swift神枚举没得用了😢
@objc public protocol TransitionAnimationConvert {
    func convertTransitionAnimation() ->ViewControllerAnimatedTransitioning
}

/// 手势处理
@objc public protocol GestureRecognizerDelegate:UIGestureRecognizerDelegate {
    /// 自定义popGestureRecognizer
    var popGestureRecognizer:UIPanGestureRecognizer { get set }
    /// 当前容器
    weak var container:UIViewController! { get set }
    /// 当前交互边界
    var currentInteractiveEdge:UIRectEdge { get set }
    /// 手势处理
    @objc func handlePopRecognizer(_ recognizer:UIPanGestureRecognizer)
}


@objc public protocol RootContentConfigProtocol {
    
    /// 自定义导航栏
    var navigationBarClass:UINavigationBar.Type? { get set }
    
    /// 允许交互边界 默认是.left
    var popEdge:UIRectEdge { get set }
    
    /// 交互边界允许范围
    /// 与popEdge对应参数为0 不做限制
    var popAllowedEdge:UIEdgeInsets { get set }
    
    /// pop手势处理
    var popGestureProcessing:GestureRecognizerDelegate { get set }
    
    /// 转场动画处理 
    var animationProcessing:TransitionAnimationConvert { get set }
    
    /// 是否隐藏导航栏
    var prefersNavigationBarHidden:Bool { get set }
}

@objc public protocol RootNavigationItemCustomProtocol {
    /// 自定义返回按钮
    @objc optional func qnn_customBackItem(withTarget target: Any?, action aSelector: Selector) -> UIBarButtonItem?
    
    /// 自定义返回按钮数组
    @objc optional func qnn_customBackItems(withTarget target: Any?, action aSelector: Selector) -> [UIBarButtonItem]?
}

@objc public final class RootContentConfig:NSObject,RootContentConfigProtocol {
    public var navigationBarClass: UINavigationBar.Type?
    public var popEdge: UIRectEdge
    public var popAllowedEdge: UIEdgeInsets
    public var popGestureProcessing: GestureRecognizerDelegate
    public var animationProcessing: TransitionAnimationConvert
    public var prefersNavigationBarHidden: Bool
    override init() {
        self.navigationBarClass = nil
        self.popEdge = .left
        self.popAllowedEdge = .zero
        self.popGestureProcessing = RootTransitionGestureProcess()
        self.animationProcessing = RootTransitionAnimationProcess.defalut
        self.prefersNavigationBarHidden = false
        super.init()
    }
    #if WZDEBUG
    deinit {
        print(self.classForCoder, #line , #function)
    }
    #endif
}

