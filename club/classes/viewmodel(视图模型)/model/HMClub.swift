//
//  HMClub.swift
//  club
//
//  Created by Temple on 16/11/7.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import YYModel

class HMClub: NSObject {

    /// 社团名称
    var clubTitle: String?
    /// 社团logo
    var clubLogoPic: String?
    /// 社团类型
    var clubType: String?
    /// 社团描述
    var clubDes: String?
    
    // 社团是否申请通过
    var state: String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
}
