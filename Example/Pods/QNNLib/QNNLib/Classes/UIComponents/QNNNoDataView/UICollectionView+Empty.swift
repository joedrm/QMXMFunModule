import UIKit

// MARK: - 添加空白占位视图属性
extension UICollectionView {
    
    private struct QNNNoDataViewKey {
        static let qnnNoDataViewKey = UnsafeRawPointer.init(bitPattern: "qnnNoDataViewKey".hashValue)!
    }
    
    fileprivate var qnn_noDataView: QNNNoDataView {
        get {
            guard let nodataView = objc_getAssociatedObject(self, QNNNoDataViewKey.qnnNoDataViewKey) as? QNNNoDataView else{
                return QNNNoDataView(initShow: false, customSetting: false)
            }
            return nodataView
        }
        
        set {
            objc_setAssociatedObject(self, QNNNoDataViewKey.qnnNoDataViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension QNN where Base: UICollectionView {
    public var noDataView: QNNNoDataView {
        get {
            return base.qnn_noDataView
        }
        
        set {
            base.qnn_noDataView = newValue
            
            for subview in self.base.subviews{
                if subview.isKind(of: QNNNoDataView.self){
                    subview.removeFromSuperview()
                }
            }
            base.insertSubview(newValue, at: 0) // UITableView放最下面即可
            newValue.isHidden = !newValue.initShow
        }
    }
    
    public func hideNoDataView(){
        noDataView.isHidden = true
    }
    
    // 显示空白占位视图
    public func showNoDataView(){
        noDataView.isHidden = false
        base.sendSubviewToBack(noDataView) // UITableView放最下面即可
        base.layoutIfNeeded()
    }
}



// MARK: - 取列表总条目数
extension QNN where Base: UICollectionView{
    
    internal func getItemsCount() -> Int{
        var count = 0
        for section in 0..<base.numberOfSections{
            count += base.numberOfItems(inSection: section)
        }
        return count
    }
}

// MARK: - 根据是否有数据决定是否显示空白占位视图
extension QNN where Base: UICollectionView{
    
    internal func decide_show_hide_noDataView_by_itemsCount(){
        DispatchQueue.main.async {
            if self.noDataView.customSetting{ // 外界使用中设置了noDataView
                self.noDataView.isHidden = self.getItemsCount() > 0
                if !self.noDataView.isHidden{
                    self.base.sendSubviewToBack(self.noDataView) // UICollectionView放最下面即可
                    self.base.layoutIfNeeded()
                }
            }
        }
    }
    
    // 有数据回调true，无数据回调false
    internal func decide_show_hide_noDataView_by_itemsCount(completion: @escaping (Bool) -> ()){
        DispatchQueue.main.async {
            if self.noDataView.customSetting{ // 外界使用中设置了noDataView
                self.noDataView.isHidden = self.getItemsCount() > 0
                if !self.noDataView.isHidden{
                    self.base.sendSubviewToBack(self.noDataView) // UICollectionView放最下面即可
                    self.base.layoutIfNeeded()
                }
            }
            completion(self.getItemsCount() > 0)
        }
    }
}


// MARK: - 手动控制是否显示空白占位视图
extension QNN where Base: UICollectionView{
    
    // 隐藏空白占位视图
    public func qnn_hideNoDataView(){
        noDataView.isHidden = true
    }
    
    // 显示空白占位视图
    public func qnn_showNoDataView(){
        noDataView.isHidden = false
        base.sendSubviewToBack(noDataView) // UITableView放最下面即可
        base.layoutIfNeeded()
    }
}

// MARK: - 自动控制是否显示空白占位视图，没有回调
extension QNN where Base: UICollectionView{
    
    public func qnn_refreshNoDataView_withoutReloadData(){
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_reloadData_noDataView(){
        base.reloadData()
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_insertSections_noDataView(_ sections: IndexSet){
        base.insertSections(sections)
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_deleteSections_noDataView(_ sections: IndexSet){
        base.deleteSections(sections)
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_reloadSections_noDataView(_ sections: IndexSet){
        base.reloadSections(sections)
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_insertItems_noDataView(at:[IndexPath]){
        base.insertItems(at: at)
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_deleteItems_noDataView(at:[IndexPath]){
        base.deleteItems(at: at)
        decide_show_hide_noDataView_by_itemsCount()
    }
    
    public func qnn_reloadItems_noDataView(at:[IndexPath]){
        base.reloadItems(at: at)
        decide_show_hide_noDataView_by_itemsCount()
    }
}

// MARK: - 自动控制是否显示空白占位视图，有数据回调true，无数据回调false
extension QNN where Base: UICollectionView{
    
    public func qnn_refreshNoDataView_withoutReloadData(completion: @escaping (Bool) -> ()){
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_reloadData_noDataView(completion: @escaping (Bool) -> ()){
        base.reloadData()
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_insertSections_noDataView(_ sections: IndexSet, completion: @escaping (Bool) -> ()){
        base.insertSections(sections)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_deleteSections_noDataView(_ sections: IndexSet, completion: @escaping (Bool) -> ()){
        base.deleteSections(sections)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_reloadSections_noDataView(_ sections: IndexSet, completion: @escaping (Bool) -> ()){
        base.reloadSections(sections)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_insertItems_noDataView(at:[IndexPath], completion: @escaping (Bool) -> ()){
        base.insertItems(at: at)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_deleteItems_noDataView(at:[IndexPath], completion: @escaping (Bool) -> ()){
        base.deleteItems(at: at)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
    
    public func qnn_reloadItems_noDataView(at:[IndexPath], completion: @escaping (Bool) -> ()){
        base.reloadItems(at: at)
        decide_show_hide_noDataView_by_itemsCount(completion: completion)
    }
}
