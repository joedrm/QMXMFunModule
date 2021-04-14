import UIKit

extension UITableView {
    
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

extension QNN where Base: UITableView {

    /// 空白占位视图
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

// MARK: - 取列表总行数
extension QNN where Base: UITableView{
    
    internal func getRowsCount() -> Int{
        var count = 0
        for section in 0..<self.base.numberOfSections{
            count += self.base.numberOfRows(inSection: section)
        }
        return count
    }
}

// MARK: - 根据是否有数据决定是否显示空白占位视图
extension QNN where Base: UITableView{
    
    internal func decide_show_hide_noDataView_by_rowsCount(){
        DispatchQueue.main.async {
            if self.noDataView.customSetting{ // 外界使用中设置了noDataView
                self.noDataView.isHidden = self.getRowsCount() > 0
                if !self.noDataView.isHidden{
                    self.base.sendSubviewToBack(self.noDataView) // UITableView放最下面即可
                    self.base.layoutIfNeeded()
                }
            }
        }
    }
    
    // 有数据回调true，无数据回调false
    internal func decide_show_hide_noDataView_by_rowsCount(completion: @escaping (Bool) -> ()){
        DispatchQueue.main.async {
            if self.noDataView.customSetting{ // 外界使用中设置了noDataView
                self.noDataView.isHidden = self.getRowsCount() > 0
                if !self.noDataView.isHidden{
                    self.base.sendSubviewToBack(self.noDataView) // UITableView放最下面即可
                    self.base.layoutIfNeeded()
                }
            }
            completion(self.getRowsCount() > 0)
        }
    }
}


// MARK: - 自动控制是否显示空白占位视图，没有回调
extension QNN where Base: UITableView {
    
    public func refreshNoDataView_withoutReloadData(){
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func reloadData_noDataView(){
        self.base.reloadData()
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func insertSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation){
        self.base.insertSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func deleteSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation){
        self.base.deleteSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func reloadSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation){
        self.base.reloadSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func insertRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation){
        self.base.insertRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func deleteRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation){
        self.base.deleteRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
    
    public func reloadRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation){
        self.base.reloadRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount()
    }
}

// MARK: - 自动控制是否显示空白占位视图，有数据回调true，无数据回调false
extension QNN where Base: UITableView {
    
    public func refreshNoDataView_withoutReloadData(completion: @escaping (Bool) -> ()){
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func reloadData_noDataView(completion: @escaping (Bool) -> ()){
        self.base.reloadData()
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func insertSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.insertSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func deleteSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.deleteSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func reloadSections_noDataView(_ sections: IndexSet, with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.reloadSections(sections, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func insertRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.insertRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func deleteRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.deleteRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
    
    public func reloadRows_noDataView(at: [IndexPath], with: UITableView.RowAnimation, completion: @escaping (Bool) -> ()){
        self.base.reloadRows(at: at, with: with)
        decide_show_hide_noDataView_by_rowsCount(completion: completion)
    }
}
