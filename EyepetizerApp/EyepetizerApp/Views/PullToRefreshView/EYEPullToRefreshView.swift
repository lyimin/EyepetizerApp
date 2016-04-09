//
//  EYEPullToRefreshView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/4/8.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

// 动画时间
var animationDuration: NSTimeInterval = 0.3
// 下拉刷新高度
var pullToRefreshHeight: CGFloat = 80

let refreshHeaderTimeKey: String =  "RefreshHeaderView"
let refreshContentOffset: String =  "contentOffset"
let refreshContentSize: String =  "contentSize"

//控件的类型
enum PullToRefreshViewType {
    case  Header             // 头部控件
    case  Footer             // 尾部控件
}
enum PullToRefreshViewState {
    case  Normal                // 普通状态
    case  Pulling               // 松开就可以进行刷新的状态
    case  Refreshing            // 正在刷新中的状态
}

/// 刷新基类
class EYEPullToRefreshView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加loadview
        loadView = EYELoaderView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        loadView.center = self.center
        self.addSubview(loadView)
        
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        // 移走旧的父控件
        if (self.superview != nil) {
            self.superview?.removeObserver(self, forKeyPath: refreshContentOffset as String, context: nil)
        }
        // 新的父控件 添加监听器
        if (newSuperview != nil) {
            newSuperview!.addObserver(self, forKeyPath: refreshContentOffset as String, options: NSKeyValueObservingOptions.New, context: nil)
            var rect:CGRect = self.frame
            // 设置宽度 位置
            rect.size.width = newSuperview!.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            
            //UIScrollView
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --------------------------- Public Methods --------------------------
    // 给子类重写
    /**
     判断是否正在刷新
     */
    func isRefresh() -> Bool {
        return PullToRefreshViewState.Refreshing == state;
    }
    
    /**
     开始刷新
     */
    func beginRefreshing(){
        // self.State = RefreshState.Refreshing;
        if (self.window != nil) {
            state = .Refreshing;
        } else {
            //不能调用set方法
            state = .Normal;
            super.setNeedsDisplay()
        }
    }
    
    /**
     结束刷新
     */
    func endRefreshing(){
        if state == .Normal {
            return
        }
        
        let delayInSeconds:Double = 0.3
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
        
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.state = .Normal;
        })
    }
    
   
    //MARK: --------------------------- Getter and Setter --------------------------
    /// 刷新回调的Block
    typealias beginRefreshingBlock = () -> Void
    // 刷新view
    var loadView: EYELoaderView!
    // 父控件
    private var scrollView: UIScrollView!
    private var scrollViewOriginalInset: UIEdgeInsets!
    
    // 刷新后回调
    var beginRefreshingCallback: beginRefreshingBlock?
    // 交给子类去实现和调用
    var oldState: PullToRefreshViewState! = .Normal
    // 当状态改变时设置状态(State)就会调用这个方法
    var state : PullToRefreshViewState = .Normal {
        willSet {
            self.state = newValue
        }
        didSet {
            guard self.state != self.oldState else {
                return
            }
            
            switch self.state {
            // 普通状态时
            case .Normal:
                loadView.stopLoadingAnimation()
            // 释放刷新状态
            case .Pulling:
                break;
            // 正在刷新状态
            case .Refreshing:
                loadView.startLoadingAnimation()
                
                if let callBack = beginRefreshingCallback {
                    callBack()
                }
            }
        }
    }
}

/// 下拉刷新
class EYEPullToRefreshHeaderView: EYEPullToRefreshView {
    
    // 创建view的静态方法
    class func headerView() -> EYEPullToRefreshHeaderView {
        return EYEPullToRefreshHeaderView(frame: CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: pullToRefreshHeight))
    }
    /**
     设置headerView的frame
     */
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        
        var rect:CGRect = self.frame
        rect.origin.y = -pullToRefreshHeight
        self.frame = rect
    }
    
    /**
     这个方法是这个Demo的核心。。监听scrollview的contentoffset属性。 属性变化就会调用。
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        // 如果当前状态不是刷新状态
        guard self.state != .Refreshing else {
            return
        }
        
        // 监听到的是contentoffset
        guard refreshContentOffset == keyPath else {
            return
        }
        
        // 拿到当前contentoffset的y值
        let currentOffsetY : CGFloat = self.scrollView.contentOffset.y + UIConstant.UI_NAV_HEIGHT
        
        if (currentOffsetY >= 0) {
            return
        }
        // 根据scrollview 滑动的位置设置当前状态
        if self.scrollView.dragging {
            let happenOffSetY = fabs(currentOffsetY)
            if state == .Normal && happenOffSetY > pullToRefreshHeight {
                state = .Pulling
            } else if state == .Pulling && happenOffSetY <= pullToRefreshHeight{
                state = .Normal
            } else if state == .Normal && happenOffSetY < pullToRefreshHeight {
                state = .Normal
            }
        } else if state == .Pulling {
            state = .Refreshing
        }
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    
    override var state: PullToRefreshViewState {
        willSet {
            oldState = state
        }
        
        didSet {
            switch state {
            case .Normal:
                if PullToRefreshViewState.Refreshing == oldState {
                    UIView.animateWithDuration(animationDuration, animations: {
                        var contentInset:UIEdgeInsets = self.scrollView.contentInset
                        contentInset.top = self.scrollViewOriginalInset.top+UIConstant.UI_NAV_HEIGHT
                        self.scrollView.contentInset = contentInset
                    })
                    
                }
                
            case .Pulling:
                break;
            case .Refreshing:
                UIView.animateWithDuration(animationDuration, animations: {
                    let top:CGFloat = self.scrollViewOriginalInset.top + self.frame.size.height
                    var inset:UIEdgeInsets = self.scrollView.contentInset
                    inset.top = top+UIConstant.UI_NAV_HEIGHT
                    self.scrollView.contentInset = inset
                    
                    var offset:CGPoint = self.scrollView.contentOffset
                    offset.y = -top-UIConstant.UI_NAV_HEIGHT
                    self.scrollView.contentOffset = offset
                })
            }
        }
    }
}

/// 上拉加载更多
class EYEPullToRefreshFooterView: EYEPullToRefreshView {
    
    /**
     创建脚部静态方法
     */
    class func footerView() -> EYEPullToRefreshFooterView {
        return EYEPullToRefreshFooterView(frame: CGRectMake(0, 0, UIConstant.SCREEN_WIDTH, pullToRefreshHeight))
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        if (self.superview != nil){
            self.superview!.removeObserver(self, forKeyPath: refreshContentSize as String,context:nil)
        }
        if (newSuperview != nil)  {
            // 监听contentsize
            newSuperview.addObserver(self, forKeyPath: refreshContentSize, options: NSKeyValueObservingOptions.New, context: nil)
            // 重新调整frame
            resetFrameWithContentSize()
        }
    }
    
    /**
     监听contentsize
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // 这里分两种情况 1.contentSize 2.contentOffset
        
        if refreshContentSize == keyPath {
            self.resetFrameWithContentSize()
        } else if refreshContentOffset == keyPath {
            // 如果不是刷新状态
            guard self.state != .Refreshing else {
                return
            }
            
            let currentOffsetY : CGFloat  = self.scrollView.contentOffset.y
            let happenOffsetY : CGFloat = self.happenOffsetY()
            
            if currentOffsetY <= happenOffsetY {
                return
            }
            
            if self.scrollView.dragging {
                let normal2pullingOffsetY =  happenOffsetY + self.frame.size.height
                if state == .Normal && currentOffsetY > normal2pullingOffsetY {
                    state = .Pulling
                } else if (state == .Pulling && currentOffsetY <= normal2pullingOffsetY) {
                    state = .Normal;
                }
            } else if (state == .Pulling) {
                state = .Refreshing
            }
        }
    }
    
    /**
     重新设置frame
     */
    private func resetFrameWithContentSize() {
        let contentHeight:CGFloat = self.scrollView.contentSize.height
        let scrollHeight:CGFloat = self.scrollView.frame.size.height  - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
        
        var rect:CGRect = self.frame;
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect;
    }
    
    private func heightForContentBreakView() -> CGFloat {
        let h:CGFloat  = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
        return self.scrollView.contentSize.height - h;
    }
    
    
    private func happenOffsetY() -> CGFloat {
        let deltaH:CGFloat = self.heightForContentBreakView()
        
        if deltaH > 0 {
            return   deltaH - self.scrollViewOriginalInset.top;
        } else {
            return  -self.scrollViewOriginalInset.top;
        }
    }
    
    /**
     获取cell的总个数
     */
    private  func  totalDataCountInScrollView() -> Int {
        var totalCount:Int = 0
        if self.scrollView is UITableView {
            let tableView:UITableView = self.scrollView as! UITableView
            
            for i in 0..<tableView.numberOfSections {
                totalCount = totalCount + tableView.numberOfRowsInSection(i)
            }
        } else if self.scrollView is UICollectionView {
            let collectionView:UICollectionView = self.scrollView as! UICollectionView
            for i in 0..<collectionView.numberOfSections() {
                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
            }
        }
        return totalCount
    }
    
    
    //MARK: --------------------------- Getter and Setter --------------------------
    /// 保存cell的总个数
    private var lastRefreshCount: Int = 0
    /// 状态改变时就调用
    override var state : PullToRefreshViewState {
        willSet {
            oldState = state
        }
        
        didSet {
            switch state {
            // 普通状态
            case .Normal:
                if .Refreshing == oldState {
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.scrollView.contentInset.bottom = self.scrollViewOriginalInset.bottom
                    })
                    
                    let deltaH : CGFloat = self.heightForContentBreakView()
                    let currentCount : Int = self.totalDataCountInScrollView()
                    
                    if (deltaH > 0  && currentCount != self.lastRefreshCount) {
                        var offset:CGPoint = self.scrollView.contentOffset;
                        offset.y = self.scrollView.contentOffset.y
                        self.scrollView.contentOffset = offset;
                    }
                }
            // 释放加载更多
            case .Pulling:
                break;
                
            // 正在加载更多
            case .Refreshing:
                self.lastRefreshCount = self.totalDataCountInScrollView();
                UIView.animateWithDuration(animationDuration, animations: {
                    var bottom : CGFloat = self.frame.size.height + self.scrollViewOriginalInset.bottom
                    let deltaH : CGFloat = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    var inset:UIEdgeInsets = self.scrollView.contentInset;
                    inset.bottom = bottom;
                    self.scrollView.contentInset = inset;
                })
            }
        }
    }
}

