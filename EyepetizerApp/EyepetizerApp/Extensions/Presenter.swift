//
//  LoadingPresenter.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/17.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import Foundation

protocol LoadingPresenter : class {
    // 加载控件
    var loaderView : EYELoaderView! { get set }
    // 初始化加载控件
//    func setupLoaderView ()
//    // 设置控件状态
//    func setLoaderViewHidden(hidden : Bool)
//    // 启动动画
//    func startLoadingAnimation()
//    // 停止动画
//    func stopLoadingAnimation()
}

extension LoadingPresenter where Self: UIViewController {
    
    /**
     初始化
     */
    func setupLoaderView() {
        if  loaderView == nil {
            loaderView = EYELoaderView(frame: CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: 100))
            loaderView.center = CGPoint(x: UIConstant.SCREEN_WIDTH*0.5, y: UIConstant.SCREEN_HEIGHT*0.4)
            self.view.addSubview(loaderView)
        }
    }
    
    /**
     设置显示隐藏
     */
    func setLoaderViewHidden(hidden : Bool) {
        if let view = loaderView {
            view.hidden = hidden
            if hidden {
                view.stopLoadingAnimation()
            } else {
                view.startLoadingAnimation()
            }
        }
    }
    
    /**
     开启动画
     */
    func startLoadingAnimation () {
        if let view = loaderView {
            view.startLoadingAnimation()
        }
    }
    
    /**
     停止动画
     */
    func stopLoadingAnimation() {
        if let view = loaderView {
            view.stopLoadingAnimation()
        }
    }
}

protocol MenuPresenter: class {
    var menuBtn : EYEMenuBtn! { get set }
    func menuBtnDidClick()
}

extension MenuPresenter where Self: UIViewController {
    /**
     初始化按钮
     */
    func setupMenuBtn (type : EYEMenuBtnType = .None) {
        menuBtn = EYEMenuBtn(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: type)
        menuBtn.addTarget(self, action: Selector("menuBtnDidClick"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuBtn)
    }
}
