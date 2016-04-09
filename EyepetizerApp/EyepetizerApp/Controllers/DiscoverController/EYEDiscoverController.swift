//
//  EYEDiscoverController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/10.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import Alamofire

class EYEDiscoverController: UIViewController, LoadingPresenter {

    //MARK: --------------------------- LifeCycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        setupLoaderView()
        getData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: --------------------------- Network --------------------------
    private func getData() {
        setLoaderViewHidden(false)
        Alamofire.request(.GET, EYEAPIHeaper.API_Discover).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            
            if json != .null && error == nil{
                let jsonArray = json.arrayValue
                self.modelArray = jsonArray.map({ (dict) -> EYEDiscoverModel in
                    return EYEDiscoverModel(dict: dict.rawValue as! NSDictionary)
                })
                self.collectionView.reloadData()
            }
            self.setLoaderViewHidden(true)
        })
    }
    
    //MARK: --------------------------- Getter or Setter --------------------------
    // 模型数组
    var modelArray : [EYEDiscoverModel] = [EYEDiscoverModel]()
    // 加载框
    var loaderView : EYELoaderView!
    
    private lazy var collectionView : UICollectionView = {
        // 布局
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIConstant.SCREEN_WIDTH/2-0.5
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        var collectionView : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.registerClass(EYEDiscoverCell.self, forCellWithReuseIdentifier: EYEDiscoverCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
}

// MARK: --------------------- UICollectionViewDelegate,UICollectionViewDataSource ---------------------
extension EYEDiscoverController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    // 传递模型
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! EYEDiscoverCell
        cell.model = modelArray[indexPath.row]
    }
    
    // 显示cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EYEDiscoverCell.reuseIdentifier, forIndexPath: indexPath) as! EYEDiscoverCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = modelArray[indexPath.row]
        let detailController = EYEDiscoverDetailController(title: model.name, categoryId: model.id)
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}
