//
//  EYEPopularModel.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/20.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit



struct EYEPopularModel {
    
    var videoList : [VideoModel] = [VideoModel]()
    /// 数量
    var count : Int!
    var nextPageUrl : String!
    
    init(dict : NSDictionary) {
        self.count = dict["count"] as? Int ?? 0
        
        let videoList : NSArray = dict["videoList"] as! NSArray
        self.videoList = videoList.map { (dict) -> VideoModel in
            return VideoModel(dict: dict as! NSDictionary)
        }
    }
    
    struct VideoModel {
        
        var id : Int!
        // 日期
        var date : Int32!
        // 行数
        var idx : Int!
        // 标题
        var title : String!
        // 详情
        var description : String!
        // 播放地址
        var playUrl : String!
        
        // 收藏数
        var collectionCount : Int!
        // 分享数
        var shareCount : Int!
        // 评论数
        var replyCount : Int!
        /// 背景图
        var feed : String!
        /// 模糊背景
        var blurred : String!
        
        init(dict : NSDictionary) {
            self.id = dict["id"] as? Int ?? 0
            self.date = dict["date"] as? Int32 ?? 0
            self.idx = dict["idx"] as? Int ?? 0
            self.title = dict["title"] as? String ?? ""
            self.description = dict["description"] as? String ?? ""
            self.playUrl = dict["playUrl"] as? String ?? ""
            
            let consumptionDic = dict["consumption"] as? NSDictionary
            if let consumption = consumptionDic {
                self.collectionCount = consumption["collectionCount"] as? Int ?? 0
                self.shareCount = consumption["shareCount"] as? Int ?? 0
                self.replyCount = consumption["replyCount"] as? Int ?? 0
            }
            
            let coverDic = dict["cover"] as? NSDictionary
            if let cover = coverDic {
                self.feed = cover["feed"] as? String ?? ""
                self.blurred = cover["blurred"] as? String ?? ""
            }
        }
    }
}