//
//  EYEPopularController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/10.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEPopularController: EYEBaseViewController, LoadingPresenter {
    var loaderView : EYELoaderView!
    
    //MARK: --------------------------- Life Cycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加headerView
        self.view.addSubview(headerView)
    
        headerView.headerViewTitleDidClick { [unowned self](targetBtn, index) in
            self.itemDidClick(index)
        }
        // 添加控制器
        // 默认选中第一个
        itemDidClick(0)
    }
    
    //MARK: --------------------------- Private Methods --------------------------
    private func itemDidClick(index : Int) {
        
        var actionController : UIViewController!
        // 再添加控制器
        switch index {
        case 0:
            if weekController == nil {
                weekController = EYEPopularWeekController()
            }
            actionController = weekController
            break
        case 1:
            if monthController == nil {
                monthController = EYEPopularMonthController()
            }
            actionController = monthController
            break
        case 2:
            if historyController == nil {
                historyController = EYEPopularHistoryController()
            }
            actionController = historyController
            break
        default:
            break
        }
        self.addChildViewController(actionController)
        self.view.addSubview(actionController.view)
        self.setupControllerFrame(actionController.view)
        // 动画
        if let currentVC = currentController {
            startAnimation(currentVC, toVC: actionController)
        } else {
            // 首次运行会来这里，将weekcontroller 赋值给当前控制器
            currentController = actionController
        }
        
    }
    
    // 设置控制器frame
    private func startAnimation(fromVC: UIViewController, toVC: UIViewController) {
        toVC.view.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            
            fromVC.view.alpha = 0
            toVC.view.alpha = 1
            
            }) {[unowned self] (_) in
                // 先清空currentview
                fromVC.view.removeFromSuperview()
                self.currentController = nil
                // 在赋值
                self.currentController = toVC
                
        }
    }
    
    private func setupControllerFrame (view : UIView) {
        view.snp_makeConstraints { (make) in
            make.left.trailing.equalTo(self.view)
            make.top.equalTo(self.headerView).offset(headerView.height)
            make.bottom.equalTo(self.view).offset(-UIConstant.UI_TAB_HEIGHT)
        }
    }
    
    //MARK: --------------------------- Getter or Setter --------------------------
    // controller
    private var weekController: EYEPopularWeekController?
    private var monthController: EYEPopularMonthController?
    private var historyController: EYEPopularHistoryController?
    // 当前选中控制器
    private var currentController : UIViewController?
    
    private let titleArray = ["周排行", "月排行", "总排行"]
    // headerView
    private lazy var headerView : EYEPopularHeaderView = {
        let headerView = EYEPopularHeaderView(frame: CGRect(x: 0, y: UIConstant.UI_NAV_HEIGHT, width: UIConstant.SCREEN_WIDTH, height: UIConstant.UI_CHARTS_HEIGHT), titleArray: self.titleArray)
        
        return headerView
    }()
}