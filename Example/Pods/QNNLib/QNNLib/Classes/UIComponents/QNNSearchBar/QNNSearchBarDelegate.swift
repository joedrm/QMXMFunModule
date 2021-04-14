//
//  QNNSearchBarDelegate.swift
//  QNN
//
//  Created by wdy on 2018/9/3.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import Foundation


public protocol QNNSearchBarDelegate : NSObjectProtocol {
    
    func searchBarShouldBeginEditing(_ searchBar: QNNSearchBar) -> Bool

    func searchBarDidBeginEditing(_ searchBar: QNNSearchBar)

    
    func searchBarShouldEndEditing(_ searchBar: QNNSearchBar) -> Bool

    func searchBarDidEndEditing(_ searchBar: QNNSearchBar)

    func searchBar(_ searchBar: QNNSearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool

    func searchBarShouldClear(_ searchBar: QNNSearchBar) -> Bool

    func searchBarShouldReturn(_ searchBar: QNNSearchBar) -> Bool

    func searchBarShouldCancel(_ searchBar: QNNSearchBar) -> Bool

    func searchBar(_ searchBar: QNNSearchBar, textDidChange text: String)
}



extension QNNSearchBarDelegate {
    public func searchBarShouldBeginEditing(_ searchBar: QNNSearchBar) -> Bool {
        return true
    }

    public func searchBarDidBeginEditing(_ searchBar: QNNSearchBar) {}

    public func searchBarShouldEndEditing(_ searchBar: QNNSearchBar) -> Bool {
        return true
    }

    public func searchBarDidEndEditing(_ searchBar: QNNSearchBar) {}

    public func searchBar(_ searchBar: QNNSearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    public func searchBarShouldClear(_ searchBar: QNNSearchBar) -> Bool {
        return true
    }

    public func searchBarShouldReturn(_ searchBar: QNNSearchBar) -> Bool {
        searchBar.textField.resignFirstResponder()
        return true
    }

    public func searchBarShouldCancel(_ searchBar: QNNSearchBar) -> Bool {
        return true
    }

    public func searchBar(_ searchBar: QNNSearchBar, textDidChange text: String) {}
}
