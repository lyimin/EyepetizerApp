//
//  NSDate+Eye.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import Foundation

extension NSDate {
    /**
     获取当前时间戳
     */
    class func getCurrentTimeStamp() -> String {
        let timeStamp : String = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000)))"
        return timeStamp
    }
    
    /**
     获取当前年月日
     */
    class func getCurrentDate() -> String {
        let formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd")
        return formatter.stringFromDate(NSDate())
    }
    
    /**
     将时间转换为时间戳
     
     - parameter date: 要转化的时间
     
     - returns: 时间戳
     */
    class func change2TimeStamp(date : String) -> String {
        let formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd")
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dateNow = formatter.dateFromString(date)
        return "\(dateNow?.timeIntervalSince1970)000"
    }
    
    /**
     将时间戳转化成时间
     
     - parameter timestamp: 要转化的时间戳
     
     - returns: 时间
     */
    class func change2Date(timestamp : String) -> String {
        guard timestamp.length > 3 else {
            return ""
        }
        
        let newTimestamp = (timestamp as NSString).substringFromIndex(timestamp.length - 3)
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFromString("yyyy-MM-dd HH:mm:ss")
        
        let dateStart = NSDate(timeIntervalSince1970: Double(newTimestamp)!)
        return formatter.stringFromDate(dateStart)
    }
}