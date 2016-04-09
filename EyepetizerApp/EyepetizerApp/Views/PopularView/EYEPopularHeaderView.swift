//
//  EYEPopularHeaderView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/20.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEPopularHeaderView: UIView {
    
    //MARK: --------------------------- Life Cycle --------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    convenience init(frame: CGRect, titleArray: [String]) {
        self.init(frame: frame)
        self.titleArray = titleArray
        let itemWidth = (self.width-2*UIConstant.UI_MARGIN_20)/CGFloat(titleArray.count)
        // 添加周排行 月排行 总排行3个按钮
        for i in 0..<titleArray.count {
            let title = titleArray[i]
            let titleButton = UIButton(frame: CGRect(x: UIConstant.UI_MARGIN_20 + CGFloat(i)*itemWidth, y: 0, width: itemWidth, height: self.height))
            titleButton.backgroundColor = UIColor.clearColor()
            titleButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            titleButton.tag = i
            titleButton.setTitle(title, forState: .Normal)
            titleButton.titleLabel?.font = UIFont.customFont_FZLTXIHJW()
            titleButton.addTarget(self, action: #selector(EYEPopularHeaderView.titleBtnDidClick(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(titleButton)
            self.titleLabelArray.append(titleButton)
        }
        
        self.currentBtn = self.titleLabelArray.first
        
        // 添加2条横线
        self.addSubview(topLineView)
        self.addSubview(bottomLineView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --------------------------- Event or Action --------------------------
    @objc private func titleBtnDidClick (button : UIButton) {
        guard isAnimation == false && button != self.currentBtn else {
            return
        }
        
        self.startAnimation(button.tag)
        
        if let _ = block {
            self.block!(targetBtn: button, index: button.tag)
        }
        
        self.currentBtn = button
    }
    
    func headerViewTitleDidClick(block : HeaderViewBtnClickBlock?) {
        self.block = block
    }
    
    //MARK: --------------------------- Private Methods --------------------------
    private func startAnimation (index : Int) {
        self.isAnimation = true
        let button = self.titleLabelArray[index]
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseIn, animations: {
            self.topLineView.center.x = button.center.x
            self.bottomLineView.center.x = button.center.x
            }) { (_) in
                self.isAnimation = false
        }
    }
    
    //MARK: --------------------------- Public Methods --------------------------
    func setupLineViewWidth(width : CGFloat) {
        bottomLineView.width = width
        topLineView.width = width
        bottomLineView.center = CGPoint(x: self.titleLabelArray.first!.center.x, y: self.height-12)
        topLineView.center = CGPoint(x: self.titleLabelArray.first!.center.x, y: 12)
    }
   
    //MARK: --------------------------- Getter or Setter --------------------------
    typealias HeaderViewBtnClickBlock = (targetBtn : UIButton, index : Int) -> Void
    // 标题
    private var titleArray: [String] = [String]()
    // 按钮
    private var titleLabelArray : [UIButton] = [UIButton]()
    // 点击回调
    private var block : HeaderViewBtnClickBlock?
    // 是否正在动画 底部两条横线动画
    private var isAnimation : Bool! = false
    // 当前选中的button
    private var currentBtn : UIButton!
    // 顶部横线
    private lazy var topLineView : UIView = {
        let topLineView: UIView = UIView()
        topLineView.backgroundColor = UIColor.blackColor()
        topLineView.frame = CGRect(x: 0, y: 0, width: 35, height: 0.5)
        topLineView.center = CGPoint(x: self.titleLabelArray.first!.center.x, y: 12)
        return topLineView
    }()
    // 底部横线
    private lazy var bottomLineView : UIView = {
        let bottomLineView: UIView = UIView()
        bottomLineView.backgroundColor = UIColor.blackColor()
        bottomLineView.frame = CGRect(x: 0, y: 0, width: 35, height: 0.5)
        bottomLineView.center = CGPoint(x: self.titleLabelArray.first!.center.x, y: self.height-12)
        return bottomLineView
    }()
}
