//
//  QNNBaseNavigationController.swift
//  QNNBaseNavigationController
//

import UIKit
import Then

open class QNNBaseNavigationController: UINavigationController {

    fileprivate let GestureNavWindow = UIApplication.shared.delegate?.window!
    fileprivate let GestureNavScreenWidth = UIScreen.main.bounds.width
    fileprivate let GestureNavScreenHeight = UIScreen.main.bounds.height
    
    /// 是否在滑动过程中(右滑)
    var isMoving = false
    /// 滑动开始坐标
    var startPoint = CGPoint(x: 0, y: 0)
    /// 存储push之后页面的屏幕截图
    var screenShotlist: Array<UIImage> = []
    
    /// 最小回弹距离 小于最小回弹距离时会弹回不会pop
    let min_distance: CGFloat = 100
    /// 拉伸参数
    let offset_float: CGFloat = 0.65
    
    /// 当侧滑时背景View
    weak var backGroundView: UIView!
    /// 侧滑时展示上一个页面截屏的imageView
    weak var lastScreenImageView: UIImageView!
    /// Mark
    weak var markView: UIImageView!
    
    /// 侧滑手势
    var sideslipGesture: UIPanGestureRecognizer!
    // MARK: -  属性
    
    private lazy var fakeBar: QNNFakeNavigationBar = {
        let fakeBar = QNNFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var fromFakeBar: QNNFakeNavigationBar = {
        let fakeBar = QNNFakeNavigationBar()
        return fakeBar
    }()
    
    private lazy var toFakeBar: QNNFakeNavigationBar = {
        let fakeBar = QNNFakeNavigationBar()
        return fakeBar
    }()
    
    private var fakeSuperView: UIView? {
        get {
            return navigationBar.subviews.first
        }
    }
    
    private weak var poppingVC: UIViewController?
    private var fakeFrameObserver: NSKeyValueObservation?
    /// 负责动画进度管理
    fileprivate var interaction: UIPercentDrivenInteractiveTransition?
    fileprivate let edgeWidth: CGFloat = 40
    
    // 自定义动画，需要实现了UIViewControllerAnimatedTransitioning协议
    fileprivate var animator: NavigationAnimator?
    fileprivate var animationController: AnimationContoller?
    
    // MARK: -  override

    override open func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleinteractivePopGesture(gesture:)))
        
//        animationController = AnimationContoller()
        
        /// 全屏右滑返回
        
        // 第一种实现方式：调用系统的滑动返回函数，不用自己实现
//        if let target = interactivePopGestureRecognizer?.delegate {
//            interactivePopGestureRecognizer?.isEnabled = false
//            let sel = NSSelectorFromString("handleNavigationTransition:")
//            let pan = UIPanGestureRecognizer.init(target: target, action: sel)
//            pan.delegate = self
//            view.addGestureRecognizer(pan)
//        }
        
        // 第二种实现方式
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(QNNBaseNavigationController.panGesture(_:)))
//        pan.delegate = self
//        view.addGestureRecognizer(pan)
        
        interactivePopGestureRecognizer?.isEnabled = false
        /// 侧滑手势添加
         let sideslipGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(panGesture:)))
        sideslipGesture.delaysTouchesBegan = true
        sideslipGesture.delegate = self
        view.addGestureRecognizer(sideslipGesture)

//        animator = NavigationAnimator()
        
        setupNavigationBar()
    }
    
    
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let coordinator = transitionCoordinator {
            guard let fromVC = coordinator.viewController(forKey: .from) else { return }
            if fromVC == poppingVC {
                updateNavigationBar(for: fromVC)
            }
        } else {
            guard let topViewController = topViewController else { return }
            updateNavigationBar(for: topViewController)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFakeSubviews()
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        poppingVC = topViewController
        if screenShotlist.count > 0 {
            screenShotlist.removeLast()
        }
        let viewController = super.popViewController(animated: animated)
        if let topViewController = topViewController {
            updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return viewController
    }

    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        if screenShotlist.count > 0 {
            screenShotlist.removeAll()
        }
        let vcArray = super.popToRootViewController(animated: animated)
        if let topViewController = topViewController {
            updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        return vcArray
    }

    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        poppingVC = topViewController
        let vcArray = super.popToViewController(viewController, animated: animated)
        guard let _ = vcArray else {
            return vcArray
        }
        if let topViewController = topViewController {
            updateNavigationBarTint(for: topViewController, ignoreTintColor: true)
        }
        if screenShotlist.count >= vcArray!.count {
            screenShotlist.removeLast(vcArray!.count)
        }
        return vcArray
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let screenImage = capture() {
            screenShotlist.append(screenImage)
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: -  Private Methods
extension QNNBaseNavigationController {
    
    private func setupNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        setupFakeSubviews()
    }
    
    private func setupFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        if fakeBar.superview == nil {
            fakeFrameObserver = fakeSuperView.observe(\.frame, changeHandler: { [weak self] (obj, changed) in
                guard let `self` = self else { return }
                self.layoutFakeSubviews()
            })
            fakeSuperView.insertSubview(fakeBar, at: 0)
        }
    }
    
    private func layoutFakeSubviews() {
        guard let fakeSuperView = fakeSuperView else { return }
        fakeBar.frame = fakeSuperView.bounds
        fakeBar.setNeedsLayout()
    }
    
    @objc private func handleinteractivePopGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let coordinator = transitionCoordinator,
            let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        if gesture.state == .changed {
            navigationBar.tintColor = average(fromColor: fromVC.navTintColor, toColor: toVC.navTintColor, percent: coordinator.percentComplete)
        }
    }
    
    private func average(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        let red = fromRed + (toRed - fromRed) * percent
        let green = fromGreen + (toGreen - fromGreen) * percent
        let blue = fromBlue + (toBlue - fromBlue) * percent
        let alpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func showViewController(_ viewController: UIViewController, coordinator: UIViewControllerTransitionCoordinator) {
        guard let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        resetButtonLabels(in: navigationBar)
        coordinator.animate(alongsideTransition: { (context) in
            self.updateNavigationBarTint(for: viewController, ignoreTintColor: context.isInteractive)
            if viewController == toVC {
                self.showTempFakeBar(fromVC: fromVC, toVC: toVC)
            } else {
                self.updateNavigationBarBackground(for: viewController)
                self.updateNavigationBarShadow(for: viewController)
                self.updateNavigationItemTitleView(for: viewController)
            }
        }) { (context) in
            if context.isCancelled {
                self.updateNavigationBar(for: fromVC)
            } else {
                self.updateNavigationBar(for: viewController)
            }
            if viewController == toVC {
                self.clearTempFakeBar()
            }
        }
    }
    
    private func showTempFakeBar(fromVC: UIViewController, toVC: UIViewController) {
        UIView.setAnimationsEnabled(false)
        fakeBar.alpha = 0
        // from
        fromVC.view.addSubview(fromFakeBar)
        fromFakeBar.frame = fakerBarFrame(for: fromVC)
        fromFakeBar.updateTitleView(for: fromVC, center:titleImageFrame(for: fromVC))
        fromFakeBar.setNeedsLayout()
        fromFakeBar.updateFakeBarBackground(for: fromVC)
        fromFakeBar.updateFakeBarShadow(for: fromVC)
        // to
        toVC.view.addSubview(toFakeBar)
        toFakeBar.frame = fakerBarFrame(for: toVC)
        toFakeBar.updateTitleView(for: toVC, center:titleImageFrame(for: toVC))
        toFakeBar.setNeedsLayout()
        toFakeBar.updateFakeBarBackground(for: toVC)
        toFakeBar.updateFakeBarShadow(for: toVC)
        UIView.setAnimationsEnabled(true)
    }
    
    private func clearTempFakeBar() {
        fakeBar.alpha = 1
        fromFakeBar.removeFromSuperview()
        toFakeBar.removeFromSuperview()
    }
    
    private func fakerBarFrame(for viewController: UIViewController) -> CGRect {
        guard let fakeSuperView = fakeSuperView else {
            return navigationBar.frame
        }
        var frame = navigationBar.convert(fakeSuperView.frame, to: viewController.view)
        frame.origin.x = viewController.view.frame.origin.x
        return frame
    }
    
    private func titleImageFrame(for viewController: UIViewController) -> CGPoint {
        guard let fakeSuperView = fakeSuperView else {
            return navigationBar.center
        }
        var frame = navigationBar.convert(fakeSuperView.frame, to: viewController.view)
        frame.origin.x = viewController.view.frame.origin.x
        //debugPrintOnly(frame)
        return CGPoint(x: frame.midX, y: frame.size.height - 25)
    }
    
    private func resetButtonLabels(in view: UIView) {
        let viewClassName = view.classForCoder.description().replacingOccurrences(of: "_", with: "")
        if viewClassName == "UIButtonLabel" {
            view.alpha = 1
        } else {
            if view.subviews.count > 0 {
                for subview in view.subviews {
                    resetButtonLabels(in: subview)
                }
            }
        }
    }

}

// MARK: -  UINavigationControllerDelegate
extension QNNBaseNavigationController: UINavigationControllerDelegate {
 
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = transitionCoordinator {
            showViewController(viewController, coordinator: coordinator)
        } else {
            if !animated && viewControllers.count > 1 {
                let lastButOneVC = viewControllers[viewControllers.count - 2]
                showTempFakeBar(fromVC: lastButOneVC, toVC: viewController)
                return
            }
            updateNavigationBar(for: viewController)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !animated {
            updateNavigationBar(for: viewController)
            clearTempFakeBar()
        }
        poppingVC = nil
    }
 
    //在该协议返回自定义管理动画进度的interaction
//    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        //触发panGesture才会为interaction赋值，平时返回nil
//        return interaction
//    }
//
//    //在该协议里返回自定义动画
//    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        animator?.currentOpearation = operation
//        var ignoreTabbar = true
//        switch operation {
//        case .pop:
//            //fromVC.view.layer.addSublayer(uiPopShadow)
//            ignoreTabbar = toVC.hidesBottomBarWhenPushed || !fromVC.hidesBottomBarWhenPushed
//        case .push:
//            //如果不需要自定义push，可以return nil
//            //toVC.view.layer.addSublayer(uiPopShadow)
//            ignoreTabbar = !toVC.hidesBottomBarWhenPushed || fromVC.hidesBottomBarWhenPushed
//        default:
//            return nil
//        }
//        animator?.tabbar = ignoreTabbar ? nil : self.tabBarController?.tabBar
//        return animator
//    }
    
//    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        animationController?.navigationOperation = operation
//        animationController?.navigationController = self
//        return animationController
//    }
}

// MARK: -  UIGestureRecognizerDelegate
extension QNNBaseNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        if let topViewController = topViewController {
            return topViewController.enablePopGesture
        }
        return true
    }


    @objc func panGestureAction(panGesture: UIPanGestureRecognizer) {
        guard let _ = panGesture.view else {
            return
        }
        
        if let topViewController = topViewController,
            !topViewController.enablePopGesture {
            return
        }
        
        /// 当在第一个视图时不需要侧滑
        guard self.viewControllers.count > 1 else {
            return
        }
        
        var keyWindow = UIApplication.shared.keyWindow
        if let _ = keyWindow {} else {
            keyWindow = UIApplication.shared.windows.first
        }
        
        //  获取手势点在window上面的坐标
        let touchPoint = panGesture.location(in: keyWindow)
        
        //  开始侧滑
        if panGesture.state == .began {
            isMoving = true
            startPoint = touchPoint
            setBackAndScreenViews()
        } else if panGesture.state == .ended {
            if touchPoint.x - startPoint.x > min_distance {
                UIView.animate(withDuration: 0.3, animations: {
                    self.moveViewWithX(pointX: self.GestureNavScreenWidth)
                }, completion: { (finish) in
                    _ = self.popViewController(animated: false)
                    self.resetViewFrame(animation: false)
                })
            } else {
                self.resetViewFrame(animation: true)
            }
            return
        } else if panGesture.state == .cancelled {
            self.resetViewFrame(animation: true)
            return
        }
        
        if isMoving {
            moveViewWithX(pointX: touchPoint.x - startPoint.x)
        }
        
//        let location = panGesture.location(in: view)
//        switch panGesture.state {
//        case .began:
//            //左边缘 edgeWidth 个单位以内才有效
//            if location.x < edgeWidth, self.viewControllers.count > 1 {
//                interaction = UIPercentDrivenInteractiveTransition()
//                _ = self.popViewController(animated: true) //会调用UINavigationControllerDelegate
//            }
//        case .changed:
//            let translation = panGesture.translation(in: view)
//            //动画整体进度
//            interaction?.update(translation.x / view.bounds.width)
//        case .ended, .cancelled:
//            if location.x > view.bounds.width * 0.5 {
//                interaction?.finish()
//            } else {
//                interaction?.cancel()
//            }
//            interaction = nil
//            break
//        default:
//            break
//        }
        
        guard let coordinator = transitionCoordinator,
            let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to) else {
                return
        }
        if panGesture.state == .changed {
            navigationBar.tintColor = average(fromColor: fromVC.navTintColor, toColor: toVC.navTintColor, percent: coordinator.percentComplete)
        }
    }
    
    func moveViewWithX(pointX: CGFloat) {
        var X = pointX
        X = pointX > GestureNavScreenWidth ? GestureNavScreenWidth : pointX
        X = pointX < 0 ? 0 : pointX
        
        var frame = self.view.frame
        frame.origin.x = X
        self.view.frame = frame
        
        // 设定比例 浮动的
        let t = X / 20
        //  k 是固定比例
        let k = GestureNavScreenWidth / 20
        //  高度
        let l = GestureNavScreenHeight - GestureNavScreenWidth / 20 * 2
        lastScreenImageView?.frame = CGRect(x: k - t, y: k - t, width: GestureNavScreenWidth - k + t, height: l + t * 2)
        markView?.frame = CGRect(x: X - 14, y: 0, width: 14, height: frame.size.height)
    }
    
    /// 重置view的frame
    func resetViewFrame(animation: Bool) {
        if animation {
            self.isMoving = false
            UIView.animate(withDuration: 0.3, animations: {
                self.moveViewWithX(pointX: 0)
            }, completion: { (finish) in
                self.backGroundView?.isHidden = true
            })
        } else {
            moveViewWithX(pointX: 0)
            backGroundView?.isHidden = true
        }
    }
    
    func capture() -> UIImage? {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let rect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        GestureNavWindow?.drawHierarchy(in: rect, afterScreenUpdates: false)
        let  image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 设置背景VIEW和图片
extension QNNBaseNavigationController {
    func setBackAndScreenViews() {
        if let _ = backGroundView {
            backGroundView.isHidden = false
            self.view.superview?.insertSubview(backGroundView, belowSubview: self.view)
        } else {
            backGroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: GestureNavScreenWidth, height: GestureNavScreenHeight)).then({ (v) in
                v.backgroundColor = UIColor.black
                self.view.superview?.insertSubview(v, belowSubview: self.view)
            })
        }
        
        if let _ = lastScreenImageView {
            lastScreenImageView.removeFromSuperview()
        }
        
        lastScreenImageView = UIImageView(frame: CGRect(x: -(GestureNavScreenWidth * offset_float), y: 0, width: GestureNavScreenWidth, height: GestureNavScreenHeight)).then({ (v) in
            v.image = screenShotlist.last
            backGroundView.addSubview(v)
        })
        
        if let _ = markView {
            markView.frame = CGRect.zero
            backGroundView.insertSubview(markView, aboveSubview: lastScreenImageView)
        } else {
            markView = UIImageView(frame: CGRect.zero).then({ (v) in
                backGroundView.addSubview(v)
                v.image = QNNCommonTool.image(for: QNNBaseNavigationController.self, "note_cover_mask")
            })
        }
    }
}

// MARK: -  Public
extension QNNBaseNavigationController {
    
    public func updateNavigationBar(for viewController: UIViewController) {
        setupFakeSubviews()
        updateNavigationBarTint(for: viewController)
        updateNavigationBarBackground(for: viewController)
        updateNavigationBarShadow(for: viewController)
        updateNavigationItemTitleView(for: viewController)
    }
    
    public func updateNavigationBarTint(for viewController: UIViewController, ignoreTintColor: Bool = false) {
        if viewController != topViewController {
            return
        }
        UIView.setAnimationsEnabled(false)
        navigationBar.barStyle = viewController.barStyle
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: viewController.navTitleColor,
            NSAttributedString.Key.font: viewController.navTitleFont
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        if !ignoreTintColor {
            navigationBar.tintColor = viewController.navTintColor
        }
        UIView.setAnimationsEnabled(true)
    }
    
    public func updateNavigationBarBackground(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.updateFakeBarBackground(for: viewController)
    }
    
    public func updateNavigationBarShadow(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.updateFakeBarShadow(for: viewController)
    }
    
    public func updateNavigationItemTitleView(for viewController: UIViewController) {
        if viewController != topViewController {
            return
        }
        fakeBar.updateTitleView(for: viewController, center: titleImageFrame(for: viewController))
    }
}
