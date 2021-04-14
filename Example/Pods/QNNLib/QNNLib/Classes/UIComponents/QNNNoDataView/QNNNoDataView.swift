import UIKit



/// 列表视图的空白占位视图，使用：子类继承 QNNNoDataView，并实现 addChildView() 方法

open class QNNNoDataView: UIView {
    
    /// 初始化时是否展示
    open var initShow = false
    
    /// 默认视图
    internal var customSetting = false
    
    /// 快捷创建方式
    ///
    /// - Parameters:
    ///   - initShow: 初始化时是否展示
    ///   - customSetting: 内部调用时(默认视图)，传false
    internal convenience init(initShow: Bool, customSetting: Bool) {
        self.init()
        self.initShow = initShow
        self.customSetting = false
        self.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    
    /// 快捷创建方式
    ///
    /// - Parameters:
    ///   - initShow: 初始化时是否展示
    public convenience init(frame: CGRect, initShow: Bool) {
        self.init(frame: frame)
        self.initShow = initShow
        self.customSetting = true
        self.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addChildView()
    }
    
    open func addChildView(){
        
    }
}
