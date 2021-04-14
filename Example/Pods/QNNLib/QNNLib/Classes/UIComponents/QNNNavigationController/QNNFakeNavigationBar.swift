//
//  QNNFakeNavigationBar.swift
//  QNNFakeNavigationBar
//

import UIKit

class QNNFakeNavigationBar: UIView {

    // MARK: -  lazy load
    
    private lazy var fakeBackgroundImageView: UIImageView = {
        let fakeBackgroundImageView = UIImageView()
        fakeBackgroundImageView.isUserInteractionEnabled = false
        fakeBackgroundImageView.contentScaleFactor = 1
        fakeBackgroundImageView.contentMode = .scaleToFill
        fakeBackgroundImageView.backgroundColor = .clear
        return fakeBackgroundImageView
    }()
    
    private lazy var fakeBackgroundEffectView: UIVisualEffectView = {
        let fakeBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        fakeBackgroundEffectView.isUserInteractionEnabled = false
        return fakeBackgroundEffectView
    }()
    
    private lazy var fakeShadowImageView: UIImageView = {
        let fakeShadowImageView = UIImageView()
        fakeShadowImageView.isUserInteractionEnabled = false
        fakeShadowImageView.contentScaleFactor = 1
        return fakeShadowImageView
    }()
    
    private lazy var titleView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentScaleFactor = 1
        return view
    }()
    
    // MARK: -  init
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(fakeBackgroundEffectView)
        addSubview(fakeBackgroundImageView)
        addSubview(fakeShadowImageView)
        addSubview(titleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fakeBackgroundEffectView.frame = bounds
        fakeBackgroundImageView.frame = bounds
        fakeShadowImageView.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
    }
    
    // MARK: -  public
    
    func updateFakeBarBackground(for viewController: UIViewController) {
        fakeBackgroundEffectView.subviews.last?.backgroundColor = viewController.navBackgroundColor
        fakeBackgroundImageView.image = viewController.navBackgroundImage
        if viewController.navBackgroundImage != nil {
            // 直接使用fakeBackgroundEffectView.alpha控制台会有提示
            // 这样使用避免警告
            fakeBackgroundEffectView.subviews.forEach { (subview) in
                subview.alpha = 0
            }
        } else {
            fakeBackgroundEffectView.subviews.forEach { (subview) in
                subview.alpha = viewController.navBarAlpha
            }
        }
        fakeBackgroundImageView.alpha = viewController.navBarAlpha
        fakeShadowImageView.alpha = viewController.navBarAlpha
    }
    
    func updateFakeBarShadow(for viewController: UIViewController) {
        fakeShadowImageView.isHidden = viewController.navShadowHidden
        fakeShadowImageView.backgroundColor = viewController.navShadowColor
    }
    
    
    func updateTitleView(for viewController: UIViewController, center: CGPoint = CGPoint.zero) {
        self.titleView.image = viewController.titleImageView
        self.titleView.x = center.x - viewController.titleImageSize.width * 0.5
        self.titleView.y = center.y - viewController.titleImageSize.height * 0.5
        self.titleView.width = viewController.titleImageSize.width
        self.titleView.height = viewController.titleImageSize.height
        self.titleView.alpha = viewController.titleViewAlpha
    }
}
