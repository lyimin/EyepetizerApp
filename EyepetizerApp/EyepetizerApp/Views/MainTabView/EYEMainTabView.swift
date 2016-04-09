//
//  EYEMainTabView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/11.
//  Copyright © 2016年 xiaoming. All rights reserved.
//
import UIKit
import SnapKit

protocol EYEMainTabViewDelegate {
    // 点击前回调
    // tabbar点击时调用 定义协议规则  from:to: 从某个按钮跳到某个按钮
    func tabBarDidSelector(fromSelectorButton from:Int,toSelectorButton to:Int, title : String)
}

class EYEMainTabView: UIView {
    @IBOutlet weak var choiceBtn: UIButton!
    @IBOutlet weak var discoverBtn: UIButton!
    @IBOutlet weak var popularBtn: UIButton!
    private weak var selectorBtn : UIButton!
    var delegate : EYEMainTabViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bringSubviewToFront(choiceBtn)
        self.bringSubviewToFront(discoverBtn)
        self.bringSubviewToFront(popularBtn)
        
        setupBtnFont(tabBtn: choiceBtn)
        setupBtnFont(tabBtn: discoverBtn)
        setupBtnFont(tabBtn: popularBtn)
        
        selectorBtn = choiceBtn
    }
    
    class func tabView() -> EYEMainTabView {
        return NSBundle.mainBundle().loadNibNamed("EYEMainTabView", owner: nil, options: nil).first as! EYEMainTabView
    }
    @IBAction func choiceBtnClick(sender: UIButton) {
        setupSelectBtn(sender)
    }
    
    @IBAction func discoverBtnClick(sender: UIButton) {
        setupSelectBtn(sender)
    }
    @IBAction func pupularBtnClick(sender: UIButton) {
        setupSelectBtn(sender)
    }
    
    /**
     设置tab字体属性
     */
    private func setupBtnFont(tabBtn btn : UIButton) {
        btn.titleLabel?.font = UIFont.customFont_FZLTXIHJW()
        //设置字体默认颜色
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        //设置字体选中颜色
        btn.setTitleColor(UIColor.blackColor(), forState: [.Highlighted, .Selected])
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
    }
    
    /**
     设置选中状态
     */
    private func setupSelectBtn(selectBtn : UIButton) {
        guard selectorBtn != selectBtn else {
            return
        }
        selectorBtn.selected = false
        selectBtn.selected = true
        delegate?.tabBarDidSelector(fromSelectorButton: selectorBtn.tag, toSelectorButton:selectBtn.tag, title : (selectBtn.titleLabel?.text)!)
        selectorBtn = selectBtn
    }
}
