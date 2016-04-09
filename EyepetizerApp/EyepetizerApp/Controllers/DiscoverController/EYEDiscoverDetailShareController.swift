//
//  EYEDiscoverDetailShareController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/30.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEDiscoverDetailShareController: UIViewController, LoadingPresenter {

    var loaderView : EYELoaderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加collectionview
        self.view.addSubview(collectionView)
        // 初始化url
        setupLoaderView()
        // 获取数据
        getData(params: ["categoryId": categoryId])
        setLoaderViewHidden(false)
        // 上拉加载更多
        collectionView.footerViewPullToRefresh { [unowned self] in
            if let url = self.nextURL {
                self.getData(url, params: nil)
            }
        }
    }
    
    convenience init(categoryId : Int) {
        self.init()
        self.categoryId = categoryId
    }
    
    //MARK: --------------------------- Private Methods --------------------------
    private func getData(api : String = EYEAPIHeaper.API_Discover_Share, params:[String: AnyObject]? = nil) {
        
        Alamofire.request(.GET, api, parameters: params).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                let dataDict = json.rawValue as! NSDictionary
                // 下一个url
                self.nextURL = dataDict["nextPageUrl"] as? String
                let itemArray = dataDict["videoList"] as! NSArray
                // 字典转模型
                let list = itemArray.map({ (dict) -> ItemModel in
                    ItemModel(dict: dict as? NSDictionary)
                })
                
                if let _ = params {
                    self.modelArray = list
                } else {
                    self.modelArray.appendContentsOf(list)
                    self.collectionView.footerViewEndRefresh()
                }
                
                // 刷新数据
                self.collectionView.reloadData()
            }
            self.setLoaderViewHidden(true)
            })
    }
    //MARK: --------------------------- Getter and Setter --------------------------
    // 分类id
    private var categoryId : Int! = 0
    // 按时间排序collection
    private lazy var collectionView : EYECollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.width, height: UIConstant.SCREEN_HEIGHT-UIConstant.UI_TAB_HEIGHT-UIConstant.UI_NAV_HEIGHT)
        var collectionView = EYECollectionView(frame: rect, collectionViewLayout:EYECollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    // 时间排序模型数据
    private var modelArray : [ItemModel] = [ItemModel]()
    private var nextURL : String?
}


extension EYEDiscoverDetailShareController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.reuseIdentifier, forIndexPath: indexPath) as! EYEChoiceCell
        cell.model = modelArray[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.parentViewController is EYEDiscoverDetailController {
            (parentViewController as! EYEDiscoverDetailController).selectCell = collectionView.cellForItemAtIndexPath(indexPath) as! EYEChoiceCell
        }
        
        let model = modelArray[indexPath.row]
        self.navigationController?.pushViewController(EYEVideoDetailController(model: model), animated: true)
    }
}

