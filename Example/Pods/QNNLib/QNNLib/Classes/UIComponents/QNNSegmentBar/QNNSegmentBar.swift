//
//  QNNSegmentBar.swift
//  QNN
//
//  Created by joewang on 2018/9/28.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit
public protocol QNNSegmentBarDelegate : class{
    
    func segmentBarDidSelected(_ segmentBar: QNNSegmentBar, toIndex: Int, fromIndex: Int)
    
}

private let kMinMargin:CGFloat = 40

public class QNNSegmentBar: UIView {
    
    public weak var delegate: QNNSegmentBarDelegate?
    public var items: Array<String> = []
    
    private var _selectIndex: Int = 0
    public var selectIndex: Int? {
        get {
            return _selectIndex
        }
        set {
            if (itemBtns.count == 0 || _selectIndex < 0 || _selectIndex > itemBtns.count - 1) {
                return
            }
            _selectIndex = newValue ?? 0
            
            let btn = self.itemBtns[_selectIndex]
            btnClick(sender: btn)
        }
    }
    
    var lastBtn: UIButton = UIButton(type: .custom)
    
    private var itemBtns:[UIButton] = []
    
    public lazy var contentView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        return scrollView
    }()
    
    public lazy var indicatorView: UIView = {
        let indicatorH = config.indicatorHeight
        let indicatorView = UIView.init(frame: CGRect.init(x: 0, y: self.height - indicatorH, width: 0, height: indicatorH))
        indicatorView.backgroundColor = config.indicatorColor
        indicatorView.layer.cornerRadius = indicatorH * 0.5
        indicatorView.clipsToBounds = true
        contentView.addSubview(indicatorView)
        return indicatorView
    }()
    
    private var config: QNNSegmentBarConfig = QNNSegmentBarConfig.defaultConfig()
    
    public class func segmentBarWithFrame(frame: CGRect) -> QNNSegmentBar{
        let bar = QNNSegmentBar.init(frame: frame)
        return bar
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = self.config.segmentBarBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = self.bounds
        
        // 计算margin
        var totalBtnWidth:CGFloat = 0
        for (_, btn) in itemBtns.enumerated() {
            btn.sizeToFit()
            totalBtnWidth += btn.width
        }
        
        var caculateMargin = (self.width - totalBtnWidth) / (CGFloat)(items.count + 1)
        if (caculateMargin < kMinMargin) {
            caculateMargin = kMinMargin
        }
        
        var lastX = caculateMargin
        
        for (_, btn) in itemBtns.enumerated() {
            btn.sizeToFit()
            totalBtnWidth += btn.width
            
            btn.height = self.height
            btn.x = lastX
            btn.y = 0
            
            lastX += btn.width + caculateMargin
        }
        
        contentView.contentSize = CGSize(width: lastX, height: 0)
        
        if (itemBtns.count == 0) {
            return
        }
        
        let btn = itemBtns[_selectIndex]
        self.indicatorView.width = getIndicatorViewW(btn)
        self.indicatorView.centerX = btn.centerX
        self.indicatorView.height = config.indicatorHeight
        self.indicatorView.y = self.height - indicatorView.height - config.indicatorFromBottom
    }
}


public extension QNNSegmentBar {
    
    func updateWithConfig(_ configBlock : ((_ conf: QNNSegmentBarConfig?) -> ())? ) {
        
        if let blcok = configBlock{
            blcok(config)
        }
        
        backgroundColor = config.segmentBarBackColor
        
        for (_, item) in itemBtns.enumerated() {
            item.setTitleColor(config.itemNormalColor, for: .normal)
            item.setTitleColor(config.itemSelectColor, for: .selected)
            item.titleLabel?.font = config.itemFont
        }
        
        indicatorView.backgroundColor = config.indicatorColor
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setItems (_ items: Array<String>) {
        
        for (_, item) in itemBtns.enumerated() {
            item.removeFromSuperview()
        }
        itemBtns = []
        
        self.items = items
        
        for (index, item) in items.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = index
            button.setTitleColor(config.itemNormalColor, for: .normal)
            button.setTitleColor(config.itemNormalColor, for: .selected)
            button.titleLabel?.font = config.itemFont
            button.setTitle(item as String, for: .normal)
            button.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            contentView.addSubview(button)
            itemBtns.append(button)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    @objc func btnClick(sender: UIButton) {
        
        _selectIndex = sender.tag
        
        if sender.isEqual(lastBtn) {
            return
        }
        
        lastBtn.setTitleColor(config.itemNormalColor, for: .normal)
        sender.setTitleColor(config.itemSelectColor, for: .normal)
        lastBtn = sender
        
        _ = getMargin()
        
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.width = self.getIndicatorViewW(sender)
            self.indicatorView.centerX = sender.centerX
        }
        
        var scrollX = sender.centerX - contentView.width * 0.5
        
        if (scrollX < 0) {
            scrollX = 0
        }
        
        if scrollX > (contentView.contentSize.width - contentView.width) {
            scrollX = contentView.contentSize.width - contentView.width
        }
        
        contentView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
        
        delegate?.segmentBarDidSelected(self, toIndex: sender.tag, fromIndex: lastBtn.tag)
    }
    
    
    
    
    // 滚动内容设置标题
    func scrollToIndex(_ index : Int)  {
        
        _selectIndex = index
        
        let button = itemBtns[index]

        if button .isEqual(lastBtn) {
            return
        }
        
        btnClick(sender: button)
//
//        lastBtn.setTitleColor(config.itemNormalColor, for: .normal)
//        button.setTitleColor(config.itemSelectColor, for: .normal)
//        lastBtn = button
//
//        UIView.animate(withDuration: 0.25) {
//            self.indicatorView.width = button.width + self.config.indicatorExtraW * 2
//            self.indicatorView.centerX = button.centerX
//        }
//
//        let offsetX = button.centerX - self.width * 0.5
//
//        if offsetX >= 0 {
//
//            if button.centerX + self.width * 0.5 >= contentView.contentSize.width {
//
//                contentView.setContentOffset(CGPoint(x: contentView.contentSize.width - self.width, y: 0), animated: true)
//
//            } else {
//                contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
//            }
//
//        } else {
//
//            contentView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }
    }
    
    func getMargin() -> CGFloat {
        
        if (self.itemBtns.count == 0) {
            return kMinMargin
        }
        
        var totalBtnWidth: CGFloat = 0
        for (_, btn) in itemBtns.enumerated() {
            btn.sizeToFit()
            totalBtnWidth += btn.width
        }
        
        var caculateMargin = (self.width - totalBtnWidth) / (CGFloat)(itemBtns.count + 1)
        if (caculateMargin < kMinMargin) {
            caculateMargin = kMinMargin
        }
        
        var lastX = caculateMargin
        for (_, btn) in itemBtns.enumerated() {
            btn.sizeToFit()
            btn.height = self.height
            btn.x = lastX
            btn.y = 0
            lastX += btn.width + caculateMargin
        }
        
        return caculateMargin
    }
    
    func getIndicatorViewW(_ sender: UIButton) -> CGFloat {
        if config.indicatorLimitW > 0 {
            return config.indicatorLimitW
        }
        var indicatorViewW = sender.width + self.config.indicatorExtraW * 2
        if indicatorViewW > sender.width + getMargin() {
            indicatorViewW = sender.width + getMargin()
        }
        return indicatorViewW
    }
    
    func updateIndicatorView(_ scrollView: UIScrollView, _ startOffsetX : CGFloat) {

        if (self.itemBtns.count == 0) {
            return
        }

        let caculateMargin = getMargin()
        var lastX = caculateMargin
        for (_, btn) in itemBtns.enumerated() {
            btn.sizeToFit()
            btn.height = self.height
            btn.x = lastX
            btn.y = 0
            lastX += btn.width + caculateMargin
        }

        //滚动的百分比
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0

        let currentOffsetX : CGFloat = scrollView.contentOffset.x
        let scrollViewW : CGFloat = scrollView.bounds.size.width > 0.0 ? scrollView.bounds.size.width : ScreenWidth
        let totalPage = itemBtns.count

        if (currentOffsetX > startOffsetX) { //左滑
            progress = currentOffsetX/scrollViewW - CGFloat(floor(Float(currentOffsetX/scrollViewW)))
            sourceIndex = (Int)(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if (targetIndex >= totalPage) {
                targetIndex = totalPage - 1
            }
            
        } else { //右滑
            progress = 1 - (currentOffsetX / scrollViewW - CGFloat(floor(Float(currentOffsetX/scrollViewW))))
            targetIndex = (Int)(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1

            //scrollView的页码
            if (sourceIndex >= totalPage) {
                sourceIndex = totalPage - 1
            }
        }

        self.contentView.contentSize = CGSize(width: lastX, height: 0)
        let sourceBtn = itemBtns[sourceIndex]
        let targetBtn = itemBtns[targetIndex]

        let indicatorViewW = getIndicatorViewW(sourceBtn)

        if config.indicatorLimitW <= 0 {
            let spacing = targetBtn.frame.minX - sourceBtn.frame.minX //两者间距
            let lengthDiffer = targetBtn.frame.width - sourceBtn.frame.width //两者长度差值
            
            var sourcelineFrame = CGRect(x: sourceBtn.x, y: self.indicatorView.frame.minY, width: indicatorViewW, height: self.indicatorView.height)
            sourcelineFrame.origin.x += (spacing * progress)
            sourcelineFrame.size.width += lengthDiffer * progress
            indicatorView.frame = sourcelineFrame
        }else {
            indicatorView.width = indicatorViewW
            indicatorView.centerX = sourceBtn.centerX + (targetBtn.centerX - sourceBtn.centerX) * progress
        }
    }
}



