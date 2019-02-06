//
//  HMZone.swift
//  club
//
//  Created by Temple on 16/10/28.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import YYModel
/// 动态模型
class HMZone: NSObject {

    var id: Int64 = 0
    /// 信息内容
    var text: String?
    /// 创建时间字符串
    var created_at: String?
    /// 评论数
    var commits_count: Int = 0
    /// 点赞数
    var love_count: Int = 0
    /// 用户
    var user: HMUser?
    /// 配图模型数组
    var pic_urls: [String]?
    
    /// 视频地址
    var video_url: String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
}
