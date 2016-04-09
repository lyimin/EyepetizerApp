//
//  EYEMenuViewController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/4/2.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEMenuViewController: UIViewController, GuillotineMenu {
    

    //MARK: --------------------------- Life Cycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
//         返回按钮
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem

        let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(UIConstant.UI_NAV_HEIGHT)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    //MARK: --------------------------- Event Responce --------------------------
    @objc private func dismissButtonTapped(sende: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    /// tableview
    private let menuViewCellId = "menuViewCellId"
    let itemArray = ["我的缓存", "功能开关", "我要投稿", "更多应用"]
    private lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = EYEMenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
        tableView.sectionHeaderHeight = 200
        tableView.rowHeight = 70
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    //GuillotineMenu protocol
    lazy var dismissButton: UIButton! = {
        var dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        dismissButton.setImage(UIImage(named: "ic_action_menu"), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(EYEMenuViewController.dismissButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return dismissButton
    }()
    lazy var titleLabel: UILabel! = {
        var titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "Eyepetizer"
        titleLabel.font = UIFont.customFont_Lobster(fontSize: UIConstant.UI_FONT_16)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.sizeToFit()
        return titleLabel
    }()
}

extension EYEMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(menuViewCellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: menuViewCellId)
        }
        cell?.backgroundColor = UIColor.clearColor()
        cell?.contentView.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = .None
        cell?.textLabel?.textAlignment = .Center
        cell?.textLabel?.text = itemArray[indexPath.row]
        return cell!
    }
}
