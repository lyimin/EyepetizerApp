//
//  EYEDiscoverDetailController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/29.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEDiscoverDetailController: EYEBaseViewController, LoadingPresenter {
    var loaderView : EYELoaderView!
    //MARK: --------------------------- Life Cycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // 返回按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImg(UIImage(named: "ic_action_back"), selectorImg: nil, target: self, action: #selector(EYEDiscoverDetailController.leftBtnDidClick))
        // 添加headerView
        self.view.addSubview(headerView)

        // headerview点击
        headerView.headerViewTitleDidClick { [unowned self](targetBtn, index) in
            
            self.itemDidClick(index)
        }
        
        // 默认选中第一个
        itemDidClick(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    convenience init(title : String, categoryId : Int) {
        self.init()
        self.title = title
        self.categoryId = categoryId
    }
    
    //MARK: --------------------------- Event response --------------------------
    @objc private func leftBtnDidClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     点击标题Tab
     */
    private func itemDidClick(index : Int) {
        var actionController : UIViewController!
        // 再添加控制器
        switch index {
        case 0:
            if timeController == nil {
                timeController = EYEDiscoverDetailTimeController(categoryId: self.categoryId)
            }
            actionController = timeController
            break
        case 1:
            if shareController == nil {
                shareController = EYEDiscoverDetailShareController(categoryId: self.categoryId)
            }
            actionController = shareController
            break
        default:
            break
        }
        self.addChildViewController(actionController)
        self.view.addSubview(actionController.view)
        self.setupControllerFrame(actionController.view)
        // 动画
        startAnimation(currentController, toVC: actionController)
    }
    
    //MARK: --------------------------- Private Methods --------------------------
    private func setupControllerFrame (view : UIView) {
        view.snp_makeConstraints { (make) in
            make.left.trailing.equalTo(self.view)
            make.top.equalTo(self.headerView).offset(headerView.height)
            make.bottom.equalTo(self.view).offset(-UIConstant.UI_TAB_HEIGHT)
        }
    }
    
    // 设置控制器frame
    private func startAnimation(fromVC: UIViewController? = nil, toVC: UIViewController) {
        toVC.view.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            
            if let _ = fromVC {
                fromVC!.view.alpha = 0
            }
            toVC.view.alpha = 1
            
        }) {[unowned self] (_) in
            // 先清空currentview
            if let _ = fromVC {
                fromVC!.view.removeFromSuperview()
            }
            self.currentController = nil
            // 在赋值
            self.currentController = toVC
            
        }
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    
    private var timeController : EYEDiscoverDetailTimeController?
    private var shareController : EYEDiscoverDetailShareController?
    
    // 当前选中控制器
    private var currentController : UIViewController?
    // 分类id
    private var categoryId : Int!
    // headerView
    private let titleArray = ["按时间排序", "分享排行榜"]
    private lazy var headerView : EYEPopularHeaderView = {
        let headerView = EYEPopularHeaderView(frame: CGRect(x: 0, y: UIConstant.UI_NAV_HEIGHT, width: UIConstant.SCREEN_WIDTH, height: UIConstant.UI_CHARTS_HEIGHT), titleArray: self.titleArray)
        headerView.setupLineViewWidth(65)
        return headerView
    }()
}
