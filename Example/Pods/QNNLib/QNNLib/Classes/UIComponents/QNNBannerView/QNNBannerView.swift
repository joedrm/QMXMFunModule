//
//  QNNBannerView.swift
//  QNN
//
//  Created by zhenyu on 17/4/5.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import UIKit
import FSPagerView

public class QNNBannerView: UIView {
    
    public weak var banner: FSPagerView!
    public weak var pageControl: FSPageControl!
    public var imageArray : Array<String> = []
    public var imgsArray : Array<UIImage> = []
    public var bannerSeleted: ((Int) -> ())?
    public var itemContentMode: UIView.ContentMode = .scaleAspectFit
    
    public var bannerNumberItems = 0
    
    // MARK: - LifeCycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetViews
    func setView() {
        banner = {
            let b = FSPagerView(frame: self.bounds)
            b.isInfinite = true
            b.automaticSlidingInterval = 5
            b.delegate = self
            b.dataSource = self
            b.interitemSpacing = 0
            b.register(QNNBannerItemViewCell.self, forCellWithReuseIdentifier: QNNBannerItemViewCell.defaultReusableId)
            addSubview(b)
            return b
        }()
        
        pageControl = {
            let p = FSPageControl()
            addSubview(p)
            p.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
                make.left.right.equalTo(self)
                make.height.equalTo(15)
            }
            p.backgroundColor = UIColor.clear
            p.itemSpacing = 15
            p.contentHorizontalAlignment = .center
            p.setFillColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            p.setFillColor(.white, for: .selected)
            p.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 15, height: 2), cornerRadius: 1), for: .normal)
            p.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 15, height: 2), cornerRadius: 1), for: .selected)
            p.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            p.currentPage = 0
            return p
        }()
    }
    
    // MARK: - LoadData
    public func loadData(images: [String]) {
        imageArray.removeAll()
        imgsArray.removeAll()
        imageArray.append(contentsOf: images)
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPage = 0
        banner.reloadData()
        DispatchQueue.main.async {
            if self.bannerNumberItems > 0 {
                self.banner.scrollToItem(at: 0, animated: false)
            }
        }
    }
    
    public func loadLocalData(images: [UIImage]) {
        imgsArray.removeAll()
        imageArray.removeAll()
        imgsArray.append(contentsOf: images)
        pageControl.numberOfPages = imgsArray.count
        pageControl.currentPage = 0
        banner.reloadData()
        DispatchQueue.main.async {
            if self.bannerNumberItems > 0 {
                self.banner.scrollToItem(at: 0, animated: false)
            }
        }
    }
    
    public func resetBannerScrool() {
        DispatchQueue.main.async {
            if self.bannerNumberItems > 0 {
                self.banner.scrollToItem(at: 0, animated: false)
            }
        }
    }
}

//  bannerStyleSetting
public extension QNNBannerView {
    //  设置轮播时间
    func setBanner(automaticSlidingInterval: CGFloat) {
        banner.automaticSlidingInterval = automaticSlidingInterval
    }
    
    //  设置轮播按钮风格
    func setFillColor(_ fillColor: UIColor?, for state: UIControl.State) {
        pageControl.setFillColor(fillColor, for: state)
    }
    
}

// MARK: - FSPagerViewDataSource, FSPagerViewDelegate
extension QNNBannerView: FSPagerViewDataSource, FSPagerViewDelegate {
    open func numberOfItems(in pagerView: FSPagerView) -> Int {
        if imageArray.isEmpty {
            bannerNumberItems = imgsArray.count
            return imgsArray.count
        }else{
            bannerNumberItems = imageArray.count
            return imageArray.count
        }
    }
    
    open func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: QNNBannerItemViewCell.defaultReusableId, at: index)
        if imageArray.isEmpty {
            cell.imageView?.image = imgsArray[index]
        }else{
            cell.imageView?.loadImage(urlStr: imageArray[index])
        }
        cell.imageView?.contentMode = itemContentMode
        return cell
    }
    
    open func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        pageControl.currentPage = index
        bannerSeleted?(index)
    }
    
    open func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        pageControl.currentPage = pagerView.currentIndex
    }
}


class QNNBannerItemViewCell:  FSPagerViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    func setUI() {
        
        imageView?.contentMode = .scaleAspectFit
        contentView.layer.shadowColor = UIColor.clear.cgColor
    }
    
    /// 重写下面的属性去掉点击效果
    //    open override var isHighlighted: Bool {
    //        set {
    //            super.isHighlighted = false
    //        }
    //        get {
    //            return super.isHighlighted
    //        }
    //    }
    //
    //    open override var isSelected: Bool {
    //        set {
    //            super.isSelected = false
    //        }
    //        get {
    //            return super.isSelected
    //        }
    //    }
}
