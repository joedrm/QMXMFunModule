//
//  NavigationAnimator.swift
//  PopGesture
//
//  Created by lyf on 2018/9/7.
//  Copyright © 2018年 lyf. All rights reserved.
//

import UIKit

class NavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.25
    
    /// 如果需要做tabbar的动画就传值，不需要就不传
    var tabbar: UITabBar?
    
    var currentOpearation: UINavigationController.Operation = .pop

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch currentOpearation {
        case .pop:
            popAnitmation(transitionContext)
        case .push:
            pushAnimation(transitionContext)
        default:
            break
        }
    }
    
    func pushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
            let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
                return
        }
        
        //containerView添加的顺序从最上层依次是toView、tabbar?、fromView
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.insertSubview(fromeView, belowSubview: toView)
        
        let width = containerView.bounds.width
        toView.frame.origin.x = width
        
        //判断是否有tabar，有的话也要做动画
        if let bar = tabbar {
            containerView.insertSubview(bar, belowSubview: toView)
        }
        tabbar?.frame.origin.x = 0
        
        //动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            fromeView.frame.origin.x = -width * 0.5
            toView.frame.origin.x = 0
            self?.tabbar?.frame.origin.x = width * 0.5
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func popAnitmation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
            let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
                return
        }
        
        //containerView添加的顺序从最上层依次是fromView、tabbar?、toView
        let containerView = transitionContext.containerView
        containerView.addSubview(fromeView)
        containerView.insertSubview(toView, belowSubview: fromeView)
        
        let width = containerView.bounds.width
        toView.frame.origin.x = -width * 0.5
        
        //判断是否有tabar，有的话也要做动画
        if let bar = tabbar {
            containerView.insertSubview(bar, belowSubview: fromeView)
        }
        tabbar?.frame.origin.x = -width * 0.5
        
        //动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            fromeView.frame.origin.x = width
            toView.frame.origin.x = 0
            self?.tabbar?.frame.origin.x = 0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
