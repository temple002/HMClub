//
//  HMUnderCheckClub.swift
//  club
//
//  Created by Temple on 16/11/11.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import YYModel
class HMUnderCheckClub: NSObject {

    var underCheckClubID: Int64 = 0
    /// 社团名称
    var underCheckClubName: String?
    /// 社团logo
    var applyStuNum: String?
    /// 社团类型
    var applyReason: String?
    /// 审核状态
    var applyState: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
