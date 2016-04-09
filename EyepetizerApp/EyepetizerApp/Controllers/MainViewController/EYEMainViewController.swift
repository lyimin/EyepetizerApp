//
//  EYEMainViewController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/11.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEMainViewController: UITabBarController {
    
    //MARK: --------------------------- lifeCycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加自定义tabbar
        delegate = self
        tabBar.addSubview(tabView)

        // 添加子控制器
        addChildVC()
        
        // 添加launchView
        view.addSubview(launchView)
        // 动画完成回调
        launchView.animationDidStop { [unowned self](launchView) in
            self.launchViewRemoveAnimation()
        }
    }
    
    // - viewWillAppear -- 删除系统的tabbar
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 删除系统自带的导航按钮
        for button in self.tabBar.subviews {
            if button is UIControl {
                button.removeFromSuperview()
            }
        }
    }
    
    //MARK: --------------------------- Private Methods --------------------------
    /**
    设置控制器属性
    */
    private func addChildVC () {
        let choiceController = EYEChoiceController()
        let discoverController = EYEDiscoverController()
        let popularController = EYEPopularController()
        
        setupChildController(choiceController)
        setupChildController(discoverController)
        setupChildController(popularController)
    }
    /**
     设置更控制器
     
     - parameter vc: <#vc description#>
     */
    private func setupChildController(vc : UIViewController) {
        vc.title = "Eyepetizer"
        // 包装一个navigationcontroller
        self.addChildViewController(EYENavigationController(rootViewController: vc))
        self.view.bringSubviewToFront(vc.view)
    }
    /**
     launchview动画
     */
    private func launchViewRemoveAnimation() {
        UIView.animateWithDuration(1, animations: {
            self.launchView.alpha = 0
            }) { [unowned self](_) in
                self.launchView.removeFromSuperview()
        }
    }
    //MARK: --------------------------- getter or setter --------------------------
    // 底部Tab
    private lazy var tabView : EYEMainTabView = {
        var tabView : EYEMainTabView = EYEMainTabView.tabView()
        tabView.frame = self.tabBar.bounds
        tabView.delegate = self
        return tabView
    }()
    

    private lazy var launchView: EYELaunchView = {
        var launchView : EYELaunchView = EYELaunchView.launchView()
        launchView.frame = self.view.bounds
        return launchView
    }()
    
}
extension EYEMainViewController : UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EYETabbarTransition()
    }
}

//MARK: --------------------------- EYEMainTabViewDelegate --------------------------
extension EYEMainViewController : EYEMainTabViewDelegate {
    func tabBarDidSelector(fromSelectorButton from: Int, toSelectorButton to: Int, title : String) {
        self.selectedIndex = to
    }
}