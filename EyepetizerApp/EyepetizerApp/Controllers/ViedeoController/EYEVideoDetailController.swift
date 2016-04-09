//
//  EYEVideoDetailController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/23.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEVideoDetailController: UIViewController {
    //MARK: --------------------------- Life Cycle --------------------------
    var model : ItemModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // 隐藏导航栏
        self.navigationController?.navigationBarHidden = true
        // 添加view
        self.view.addSubview(detailView)
        detailView.model = model
        navigationController?.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImg(UIImage(named: "ic_action_back"), selectorImg: nil, target: self, action: #selector(EYEVideoDetailController.leftBtnDidClick))
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(EYEVideoDetailController.edgePanGesture(_:)))
        edgePan.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(edgePan)
    }
    
    convenience init(model : ItemModel) {
        self.init()
        self.model = model
        
        self.title = "Eyepelizer"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: --------------------------- Event or Action --------------------------
    @objc private func leftBtnDidClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translationInView(self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.Began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        } else if edgePan.state == UIGestureRecognizerState.Changed {
            self.percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if edgePan.state == UIGestureRecognizerState.Cancelled || edgePan.state == UIGestureRecognizerState.Ended {
            if progress > 0.5 {
                self.percentDrivenTransition?.finishInteractiveTransition()
                panIsCancel = false
            } else {
                self.percentDrivenTransition?.cancelInteractiveTransition()
                panIsCancel = true
            }
            self.percentDrivenTransition = nil
        }
    }
    
    //MARK: --------------------------- Getter or Setter --------------------------
    lazy var detailView : EYEVideoDetailView = {
        var detailView : EYEVideoDetailView = EYEVideoDetailView(frame:self.view.bounds)
        detailView.delegate = self
        return detailView
    }()
    
    // 手势
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    // 记录手势是否取消了
    var panIsCancel: Bool = false
}

extension EYEVideoDetailController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Pop {
            return EYEVideoDetailPopTransition()
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is EYEVideoDetailPopTransition {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
}

extension EYEVideoDetailController: EYEVideoDetailViewDelegate {
    /**
     点击播放按钮
     */
    func playImageViewDidClick() {
        let playerController = EYEPlayerController(url: model.playUrl, title: model.title)
        self.navigationController?.pushViewController(playerController, animated: false)
    }
    
    /**
     点击返回按钮
    */
    func backBtnDidClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

