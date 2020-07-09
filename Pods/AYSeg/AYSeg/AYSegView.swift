//
//  AYSegView.swift
//  FashionMix
//
//  Created by ayong on 2017/5/12.
//  Copyright © 2017年 ayong. All rights reserved.
//

import UIKit


// MARK: - 每个分页遵循AYSegPage协议。
@objc public protocol AYSegPage {
    var viewIsVisable: Bool {get set}
    var owner: UIViewController? {get set}
    var view: UIView! {get set}
    
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

////////////////////////////////////AYSegViewDelegate协议////////////////////////////////////
@objc public protocol AYSegViewDelegate: class {
    /// 滑动切换分页
    ///
    /// - Parameters:
    ///   - scrollView: bodyScrollView
    ///   - seg: 当前SegView实例
    ///   - view: 当前显示的页面
    ///   - previousView: 之前的页面
    /// - Returns: Void
    @objc optional func scrollView(_ scrollView: UIScrollView, seg: AYSegView, viewDidappear currentPage: AYSegPage, previousPage: AYSegPage?) -> Void
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView) -> Void
}

////////////////////////////////////AYSegViewDataSource协议////////////////////////////////////
@objc public protocol AYSegViewDataSource: class {
    /// 提供数据源--个数
    ///
    /// - Parameter segView: 传递当前的segView实例
    /// - Returns: 提供需要展现的个数
    //func numberOfPage(segView: AYSegView) -> Int
    
    //上面的方法废弃，采用下面的方式
    var pages: [AYSegPage] {get set}

    
    
    /// 提供数据源--显示的View
    ///
    /// - Parameters:
    ///   - segView: 传递当前的segView实例
    ///   - page: 当前的页码
    /// - Returns: 提供当前页码需要展现的View
    //func viewForPage(segView: AYSegView, page: Int) -> AYSegPage
}



////////////////////////////////////定制SegView////////////////////////////////////
/// 定制SegView
final public class AYSegView: UIView, UIScrollViewDelegate {
    
    /*
     AYSegView 父子视图关系:
     -AYSegView
        -header
        -bodyScrollView(size跟随AYSegView大小变化，顶部依赖header的位置)
            -contentView(size跟随AYSegView大小变化， contentsize宽度依赖于子视图page的宽度，高度固定某个值，默认固定为父视图高度,reloadData时更新约束高度值，依旧是父视图高度)
                -page1（宽度固定bodyScrollView宽度，高度依赖于contentView高度，注意：contentView高度可能受到外部更改而导致和bodyScrollView高度不一样）
                -page2
                -page3
                -......
     */
    
    /// 代理委托
    @IBOutlet public weak var delegate: AYSegViewDelegate?
    @IBOutlet public weak var dataSource: AYSegViewDataSource? {
        didSet {
            if useDefaultHeader, defaultHeader == nil {
                self.enableDefaultSegHeader()
            }
        }
    }
    
    /// 展示的页码数量
    fileprivate var pageCount = 0
    
    /// 当前页码
    public fileprivate(set) var currentIndex: Int = 0
    fileprivate var useDefaultHeader = true
    public private(set) var defaultHeader: AYSegDefaultHeader?
    public var header: UIView? {
        get {
            return segHeaderBG.subviews.first
        }
    }
    
    /// 滑动的UIScrollView
    public private(set) lazy var bodyScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    private lazy var segHeaderBG: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.clipsToBounds = true
        
        return v
    }()
    private var segHeaderBGHeight: CGFloat = 45.0
        
    
    /// bodyScrollView的subView，辅助作用的view，辅助子视图自动布局加约束
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.clear
        
        return contentView
    }()
    
    /// 重写指定构造器
    ///
    /// - Parameter frame: 指定SegView的初始化frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }

    
    private func setup() {
        self.addSubview(segHeaderBG)
        self.addSubview(bodyScrollView)
        
        segHeaderBG.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(segHeaderBGHeight)
        }
        bodyScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segHeaderBG.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        bodyScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
            make.width.equalTo(contentView.superview!.bounds.size.width).priority(990)
            make.height.equalTo(contentView.superview!.bounds.size.height)
        }
    }
}


////////////////////////////////////遵循UIScrollViewDelegate////////////////////////////////////
// MARK: - UIScrollViewDelegate
extension AYSegView {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    // called when scroll view grinds to a halt
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("scrollViewDidEndDecelerating")
        //当前类型页面显示高亮
        self.showCurrentKindViewHighlightedWithCurrentPage(Int(bodyScrollView.contentOffset.x/bodyScrollView.frame.size.width), previousPage: currentIndex)
    }
    
    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //print("scrollViewDidEndScrollingAnimation")
        //当前类型页面显示高亮
        self.showCurrentKindViewHighlightedWithCurrentPage(Int(bodyScrollView.contentOffset.x/bodyScrollView.frame.size.width), previousPage: currentIndex)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("scrollViewDidEndDragging")
        if (decelerate) {
            return;
        }
        if (scrollView === bodyScrollView) {
            //当前类型页面显示高亮
            self.showCurrentKindViewHighlightedWithCurrentPage(Int(bodyScrollView.contentOffset.x/bodyScrollView.frame.size.width), previousPage: currentIndex)
        }
    }
    
    public func scrollToPage(_ page: Int) -> Void {
        bodyScrollView.setContentOffset(CGPoint.init(x: CGFloat(page)*self.bodyScrollView.frame.size.width, y: 0), animated: true)
        self.showCurrentKindViewHighlightedWithCurrentPage(page, previousPage: currentIndex)
    }
    
    fileprivate func showCurrentKindViewHighlightedWithCurrentPage(_ page: Int, previousPage: Int) -> Void {
        //var newPage = (page-1+dataSource!.pages.count)%dataSource!.pages.count
        if self.currentIndex == page {
            return
        }
        self.currentIndex = page
        
//        selectedButtonInSegHeader?.setTitleColor(UIColor.darkGrayColorForText(), for: .normal)
//        selectedButtonInSegHeader?.titleLabel?.font = self.buttonFont
//        
//        selectedButtonInSegHeader = segHeader?.buttons[self.currentIndex]
//        
//        selectedButtonInSegHeader?.setTitleColor(UIColor.pink(), for: .normal)
//        selectedButtonInSegHeader?.titleLabel?.font = UIFont.init(name: self.buttonFont.fontName, size: 15)
        
        (contentView.subviews[page] as? UIScrollView)?.scrollsToTop = true
        (contentView.subviews[previousPage] as? UIScrollView)?.scrollsToTop = false
        delegate?.scrollView?(bodyScrollView, seg: self, viewDidappear: dataSource!.pages[page], previousPage: dataSource!.pages[previousPage])
        if useDefaultHeader {
            defaultHeader?.updateUIDidEndScrolling(currentIndex: page)
        }
        
        if let pV = dataSource?.pages[previousPage], pV.viewIsVisable {
            pV.viewWillDisappear(true)
            pV.viewDidDisappear(true)
            pV.viewIsVisable = false
        }
        if let v = dataSource?.pages[page], !v.viewIsVisable {
            v.viewIsVisable = true
            v.viewWillAppear(true)
            v.viewDidAppear(true)
        }
    }
}



////////////////////////////////////外部可调用的接口////////////////////////////////////
// MARK: - 供外部调用的接口
extension AYSegView {
    // MARK: - 重新加载所有分页
    public func reloadData() {
        guard let dataSource = self.dataSource else {
            print("AYSegView的dataSource为空")
            #if DEBUG
            assert(false, "AYSegView's dataSource cannot be nil")
            #endif
            return
        }
        
        //let count = dataSource.numberOfPage(segView: self)
        let count = dataSource.pages.count
        contentView.subviews.forEach { (subView: UIView) in
            subView.removeFromSuperview()
        }
        contentView.snp.updateConstraints { (update) in
            update.width.equalTo(contentView.superview!.bounds.size.width*CGFloat(count)).priority(990)
            update.height.equalTo(contentView.superview!.bounds.size.height)
        }
        
        self.pageCount = count
        var tmpView: UIView!
        for i in 0..<count {
            //let aView = dataSource.viewForPage(segView: self, page: i)
            let aView = dataSource.pages[i].view!
            self.contentView.addSubview(aView)
            aView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                if i == 0 {
                    make.left.equalToSuperview()
                }else{
                    make.left.equalTo(tmpView.snp.right)
                }
                
                make.width.equalTo(bodyScrollView.bounds.size.width)
                make.height.equalTo(contentView.snp.height)
                
                if i+1 == count {
                    make.right.equalToSuperview()
                }
            }
            tmpView = aView
        }
        
        if currentIndex >= count {
            currentIndex = count-1
        }
        if currentIndex < 0 {
            currentIndex = 0
        }
        
        if currentIndex >= 0, currentIndex < count, delegate != nil {
            delegate?.scrollView?(bodyScrollView, seg: self, viewDidappear: dataSource.pages[currentIndex], previousPage: nil)
            if useDefaultHeader {
                defaultHeader?.updateUIDidEndScrolling(currentIndex: currentIndex)
            }
            
            dataSource.pages[currentIndex].viewIsVisable = true
            dataSource.pages[currentIndex].viewWillAppear(true)
            dataSource.pages[currentIndex].viewDidAppear(true)
        }
    }
    
    // MARK: - 设置默认header是否可用，默认可用
    public func enableDefaultSegHeader(_ enable: Bool = true, titles: [String] = [], normalColor: UIColor = "#8A98BD".uiColor(), selectedColor: UIColor = UIColor.white) {
        useDefaultHeader = enable
        segHeaderBG.subviews.forEach { (elem: UIView) in
            elem.removeFromSuperview()
        }
        if enable {
            var newTitles: [String] = titles
            if newTitles.count < (dataSource?.pages.count ?? 0) {
                for i in newTitles.count..<dataSource!.pages.count {
                    newTitles.append("Page\(i+1)")
                }
            }
            let header = AYSegDefaultHeader.init(frame: CGRect.zero, titles: newTitles, lineImageNames: [], handle: nil, buttonFont: UIFont.systemFont(ofSize: 14), buttonTitleNormalColor: normalColor, buttonTitleSelectedColor: selectedColor)
            header.backgroundColor = UIColor.clear
            
            segHeaderBG.addSubview(header)
            header.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        segHeaderBG.snp.updateConstraints { (update) in
            update.height.equalTo(enable ? segHeaderBGHeight : 0)
        }
        segHeaderBG.layoutIfNeeded()
        
        defaultHeader = segHeaderBG.subviews.first as? AYSegDefaultHeader
    }
    public func updateDefaultHeaderBGHeight(_ height: CGFloat) {
        self.segHeaderBGHeight = height
        segHeaderBG.snp.updateConstraints { (update) in
            update.height.equalTo(height)
        }
        segHeaderBG.layoutIfNeeded()
    }
    public func updateDefualtHeaderInset(_ insets: UIEdgeInsets = UIEdgeInsets.zero) {
        defaultHeader?.snp.updateConstraints({ (update) in
            update.edges.equalTo(insets)
        })
        defaultHeader?.layoutIfNeeded()
    }
    //MARK: - 使用自定义header
    public func setCustomHeader(_ header: UIView, height: CGFloat = 45) {
        segHeaderBG.snp.updateConstraints { (update) in
            update.height.equalTo(height)
        }
        segHeaderBG.subviews.forEach { (elem: UIView) in
            elem.removeFromSuperview()
        }
        segHeaderBG.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if defaultHeader != header {
            defaultHeader = nil
            useDefaultHeader = false
        }
    }
    //MARK: - 修改所有分页高度
    public func updateContentHeight(_ height: CGFloat) {
        contentView.snp.updateConstraints { (update) in
            update.height.equalTo(height)
        }
        contentView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    //MARK: - 横纵屏切换
    public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.superview!.bounds.size.height)
        }
        contentView.subviews.forEach { (aView) in
            aView.snp.updateConstraints({ (make) in
                make.width.equalTo(size.width)
            })
        }
        self.layoutIfNeeded()
    }
    
}

