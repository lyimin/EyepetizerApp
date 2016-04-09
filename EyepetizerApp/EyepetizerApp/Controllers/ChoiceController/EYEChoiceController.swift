//
//  EYEChoiceController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/10.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEChoiceController: EYEBaseViewController, LoadingPresenter, MenuPresenter {
    //MARK: --------------------------- LifeCycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        // 设置loadview
        setupLoaderView()
        // 获取数据
        getData(EYEAPIHeaper.API_Choice, params: ["date" : NSDate.getCurrentTimeStamp(), "num" : "7"])
        setLoaderViewHidden(false)
        // 初始化菜单按钮
        setupMenuBtn()
        // 下拉刷新
        collectionView.headerViewPullToRefresh { [unowned self] in
            self.getData(EYEAPIHeaper.API_Choice, params: ["date": NSDate.getCurrentTimeStamp(), "num": "7"])
        }
        // 上拉加载更多
        collectionView.footerViewPullToRefresh {[unowned self] in
            if let url = self.nextPageUrl {
                self.getData(url)
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    //MARK: --------------------------- Network --------------------------
    private func getData(api: String, params: [String : AnyObject]? = nil) {
        Alamofire.request(.GET, api, parameters: params).responseSwiftyJSON ({[unowned self](request, Response, json, error) -> Void in
            print("\(EYEAPIHeaper.API_Choice)- \(params)")
            
            if json != .null && error == nil{
                // 转模型
                let dict = json.rawValue as! NSDictionary
                // 获取下一个url
                self.nextPageUrl = dict["nextPageUrl"] as? String
                // 内容数组
                let issueArray = dict["issueList"] as! [NSDictionary]
                let list = issueArray.map({ (dict) -> IssueModel in
                    return IssueModel(dict: dict)
                })
                
                // 这里判断下拉刷新还是上拉加载更多，如果是上拉加载更多，拼接model。如果是下拉刷新，直接复制
                if let _ = params {
                    // 如果params有值就是下拉刷新
                    self.issueList = list
                    self.collectionView.headerViewEndRefresh()
                } else {
                    self.issueList.appendContentsOf(list)
                    self.collectionView.footerViewEndRefresh()
                }
                
                // 隐藏loaderview
                self.setLoaderViewHidden(true)
                // 刷新
                self.collectionView.reloadData()
                
            }
        })
    }
    //MARK: --------------------------- Event or Action --------------------------
    func menuBtnDidClick() {
        let menuController = EYEMenuViewController()
        menuController.modalPresentationStyle = .Custom
        menuController.transitioningDelegate = self
        // 设置刀砍式动画属性
        if menuController is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuController as? GuillotineAnimationDelegate
        }
        
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = menuBtn
        presentationAnimator.duration = 0.15
        self.presentViewController(menuController, animated: true, completion: nil)
    }
    
    //MARK: --------------------------- Getter or Setter -------------------------
    /// 模型数据
    var issueList: [IssueModel] = [IssueModel]()
    /// 下一个page的地址
    var nextPageUrl: String?
    /// 加载控件
    var loaderView: EYELoaderView!
    /// 菜单按钮
    var menuBtn: EYEMenuBtn!
    /// collectionView
    private lazy var collectionView : EYECollectionView = {
        var collectionView : EYECollectionView = EYECollectionView(frame: self.view.bounds, collectionViewLayout:EYECollectionLayout())
            // 注册header
        collectionView.registerClass(EYEChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EYEChoiceHeaderView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    // 点击菜单动画
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
}

//MARK: --------------------------- UICollectionViewDelegate, UICollectionViewDataSource --------------------------
extension EYEChoiceController : UICollectionViewDelegate, UICollectionViewDataSource {

    // return section count
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return issueList.count
    }
    
    // return section row count
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let issueModel : IssueModel = issueList[section]
        let itemList = issueModel.itemList
        return itemList.count
    }
    // 传递模型
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = cell as! EYEChoiceCell
        
        let issueModel = issueList[indexPath.section]
        cell.model = issueModel.itemList[indexPath.row]
    }
    
    // 显示view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : EYEChoiceCell = collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.reuseIdentifier, forIndexPath: indexPath) as! EYEChoiceCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as! EYEChoiceCell

        let issueModel = issueList[indexPath.section]
        let model: ItemModel = issueModel.itemList[indexPath.row]
        // 如果播放地址为空就返回
        if model.playUrl.isEmpty {
            APESuperHUD.showOrUpdateHUD(.SadFace, message: "没有播放地址", duration: 0.3, presentingView: self.view, completion: nil)
            return
        }
        self.navigationController?.pushViewController(EYEVideoDetailController(model: model), animated: true)
    }
    
    /**
    *  section HeaderView
    */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
//        if kind == UICollectionElementKindSectionHeader {
            let headerView : EYEChoiceHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: EYEChoiceHeaderView.reuseIdentifier, forIndexPath: indexPath) as! EYEChoiceHeaderView
            let issueModel = issueList[indexPath.section]
            if let image = issueModel.headerImage {
                headerView.image = image
            } else {
                headerView.title = issueModel.headerTitle
            }
        
            return headerView
//        }
    }
    // return section headerview height
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // 获取cell的类型
        let issueModel = issueList[section]
        if issueModel.isHaveSectionView {
            return CGSize(width: UIConstant.SCREEN_WIDTH, height: 50)
        } else {
            return CGSizeZero
        }

    }
}

// 这个是点击菜单的动画代理。
extension EYEChoiceController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Dismissal
        return presentationAnimator
    }
}