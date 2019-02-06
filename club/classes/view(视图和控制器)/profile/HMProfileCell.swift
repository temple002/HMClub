//
//  HMProfileCell.swift
//  club
//
//  Created by Temple on 16/10/26.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMProfileCell: UITableViewCell {

    /// profilecell的图标
    @IBOutlet weak var profile_Icon: UIImageView!
    
    /// profilecell的标题
    @IBOutlet weak var profile_title: UILabel!
    
    /// 设置我的界面的 条目界面
    var profile: [String: String]?{
        didSet{
            profile_Icon.image = UIImage(named: profile?["imageName"] ?? "")
            profile_title.text = profile?["title"] ?? ""
        }
    }

}
