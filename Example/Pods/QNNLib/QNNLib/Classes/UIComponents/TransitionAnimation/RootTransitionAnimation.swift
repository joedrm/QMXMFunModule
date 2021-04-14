//
//  RootTransitionAnimation.swift
//  QNN
//
//  Created by joewang on 2019/3/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

//  转场动画来自
//  https://github.com/DianQK/TransitionTreasury/blob/master/TransitionAnimation/TRTransitionAnimations.swift

import UIKit

/// 基础转场动画
public enum RootTransitionAnimationType{
    /// `default`
    case `default`
    /// Page Motion
    case page
    /// Fade Out In
    case fadeOut
    /// Like OmniFocus
    case omniFocus(keyView:UIView)
    /// custom
    case custom(animation:ViewControllerAnimatedTransitioning)
    
    var animation:ViewControllerAnimatedTransitioning {
        switch self {
        case .default:
            return DefaultTransitionAnimation()
        case .page:
            return PageTransitionAnimation()
        case .fadeOut:
            return FadeOutTransitionAnimation()
        case .omniFocus(let key):
            return OmniFocusTransitionAnimation(key:key)
        case .custom(let animation):
            return animation
        }
    }
}
/// 为了兼容ObjC 和将基础动画提供给ObjC使用
@objc public final class RootTransitionAnimationProcess:NSObject,TransitionAnimationConvert{
    
    @objc public class var `defalut`:TransitionAnimationConvert {
      return RootTransitionAnimationProcess()
    }
    
    @objc public class var page:TransitionAnimationConvert {
        return RootTransitionAnimationProcess(type: .page)
    }
    
    @objc public class var fadeOut:TransitionAnimationConvert {
        return RootTransitionAnimationProcess(type: .fadeOut)
    }
    
    @objc public static func omniFocus(key:UIView)->RootTransitionAnimationProcess{
        return RootTransitionAnimationProcess(type: .omniFocus(keyView: key))
    }
    
    let animation:ViewControllerAnimatedTransitioning
    
    public init(type:RootTransitionAnimationType = .default) {
        self.animation = type.animation
        super.init()
    }
    
    #if WZDEBUG
    deinit {
        print(self.classForCoder, #line , #function)
    }
    #endif
    
    public func convertTransitionAnimation() -> ViewControllerAnimatedTransitioning {
        return animation
    }
}
