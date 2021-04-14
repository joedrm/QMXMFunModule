//
//  UIViewController+NavigationBar.swift
//  UIViewController+NavigationBar
//

import UIKit


// MARK: -  自定义导航栏相关的属性, 支持UINavigationBar.appearance()
public extension UIViewController {
    
    // MARK: -  属性
    
    /// keys
    private struct HXNavigationBarKeys {
        static var barStyle = "QNNNavigationBarKeys_barStyle"
        static var backgroundColor = "QNNNavigationBarKeys_backgroundColor"
        static var backgroundImage = "QNNNavigationBarKeys_backgroundImage"
        static var tintColor = "QNNNavigationBarKeys_tintColor"
        static var barAlpha = "QNNNavigationBarKeys_barAlpha"
        static var titleColor = "QNNNavigationBarKeys_titleColor"
        static var titleFont = "QNNNavigationBarKeys_titleFont"
        static var shadowHidden = "QNNNavigationBarKeys_shadowHidden"
        static var shadowColor = "QNNNavigationBarKeys_shadowColor"
        static var enablePopGesture = "QNNNavigationBarKeys_enablePopGesture"
        static var titleImageView = "QNNNavigationBarKeys_titleImageView"
        static var titleImageSize = "QNNNavigationBarKeys_titleImageSize"
        static var titleViewAlpha = "QNNNavigationBarKeys_titleViewAlpha"
    }


    /// 导航栏样式，默认样式
    var barStyle: UIBarStyle {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.barStyle) as? UIBarStyle ?? UINavigationBar.appearance().barStyle
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.barStyle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏前景色（item的文字图标颜色），默认黑色
    var navTintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.tintColor) as? UIColor {
                return tintColor
            }
            if let tintColor = UINavigationBar.appearance().tintColor {
                return tintColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏标题文字颜色，默认黑色
    var navTitleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.titleColor) as? UIColor {
                return titleColor
            }
            if let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor {
                return titleColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    /// 导航栏标题文字字体，默认17号粗体
    var navTitleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(self, &HXNavigationBarKeys.titleFont) as? UIFont {
                return titleFont
            }
            if let titleFont = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
                return titleFont
            }
            return UIFont.boldSystemFont(ofSize: 17)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    /// 导航栏背景色，默认白色
    var navBackgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .white
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 导航栏背景图片
    var navBackgroundImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.backgroundImage) as? UIImage ?? UINavigationBar.appearance().backgroundImage(for: .default)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    /// 导航栏背景透明度，默认1
    var navBarAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.barAlpha, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsNavigationBarBackgroundUpdate()
        }
    }

    /// 导航栏底部分割线是否隐藏，默认不隐藏
    var navShadowHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.shadowHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 导航栏底部分割线颜色
    var navShadowColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.shadowColor) as? UIColor ?? UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.shadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsNavigationBarShadowUpdate()
        }
    }
    
    /// 是否开启手势返回，默认开启
    var enablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

//    public var enablePopGesture: Bool {
//        get {
//            return !self.sh_interactivePopDisabled
//        }
//        set {
//            self.sh_interactivePopDisabled = !newValue
//        }
//    }
    
    /// 导航栏titleView背景透明度，默认1
    var titleImageView: UIImage? {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.titleImageView) as? UIImage ?? UIImage()
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleImageView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsTitleViewUpdate()
        }
    }
    
    /// 导航栏titleView背景透明度，默认1
    var titleViewAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.titleViewAlpha) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleViewAlpha, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsTitleViewUpdate()
        }
    }
    
    
    /// 导航栏titleView背景透明度，默认1
    var titleImageSize: CGSize {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.titleImageSize) as? CGSize ?? CGSize.zero
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleImageSize, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setNeedsTitleViewUpdate()
        }
    }
    
    
    // MARK: -  更新UI

    // 整体更新
    func setNeedsNavigationBarUpdate() {
        guard let naviController = navigationController as? QNNBaseNavigationController else { return }
        naviController.updateNavigationBar(for: self)
    }
    
    // 更新文字、title颜色
    func setNeedsNavigationBarTintUpdate() {
        guard let naviController = navigationController as? QNNBaseNavigationController else { return }
        naviController.updateNavigationBarTint(for: self)
    }

    // 更新背景
    func setNeedsNavigationBarBackgroundUpdate() {
        guard let naviController = navigationController as? QNNBaseNavigationController else { return }
        naviController.updateNavigationBarBackground(for: self)
    }
    
    // 更新shadow
    func setNeedsNavigationBarShadowUpdate() {
        guard let naviController = navigationController as? QNNBaseNavigationController else { return }
        naviController.updateNavigationBarShadow(for: self)
    }
    
    // 更新titleView
    func setNeedsTitleViewUpdate() {
        guard let naviController = navigationController as? QNNBaseNavigationController else { return }
        naviController.updateNavigationItemTitleView(for: self)
    }
}

