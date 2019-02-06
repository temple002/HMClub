//
//  HMEvent.swift
//  club
//
//  Created by Temple on 16/11/4.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import YYModel

class HMEvent: NSObject {
    
    /// 活动图片
    var eventPicName: String?
    /// 活动标题
    var eventName: String?
    /// 活动详情
    var eventDes: String?
    /// 活动开始时间
    var beginTime: String?
    /// 活动结束时间
    var endTime: String?
    /// 活动地点
    var location: String?
    /// 是哪个社团发布的
    var inClub: String?
    
    override init() {}
    
    init(dict: [String: String]) {
        super.init()
        
        self.yy_modelSet(with: dict)
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
