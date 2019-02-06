//
//  HMProfileHeaderView.swift
//  club
//
//  Created by Temple on 16/10/26.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMProfileHeaderView: UIView {
    
    // 头像
    @IBOutlet weak var headerviewIcon: UIImageView!
    // 用户名
    @IBOutlet weak var username: UILabel!
    // 喜欢的社团个数
    @IBOutlet weak var loveClubCount: UILabel!
    // 参加活动个数
    @IBOutlet weak var joinEventCount: UILabel!
    // 创建社团个数
    @IBOutlet weak var createClubCount: UILabel!
    
    // 设置数据
    var userModel: HMUser?{
        
        didSet{
            
            guard let userName = userModel?.userName,
                let loveClubCount = userModel?.loveClubCount,
                let joinEventCount = userModel?.joinEventCount,
                let createClubCount = userModel?.createClubCount
                
            else{
                    return
            }
            
            headerviewIcon.image = UIImage(named: "onLineIcon3")
            username.text = userName
            self.loveClubCount.text = loveClubCount.description
            self.joinEventCount.text = joinEventCount.description
            self.createClubCount.text = createClubCount.description
        }
    }
    
    
    class func profileHeaderView () -> HMProfileHeaderView{
        
        let nib = UINib(nibName: "HMProfileHeaderView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! HMProfileHeaderView
        
        return v
    }
    
    override func awakeFromNib() {
        headerviewIcon.layer.cornerRadius = 50
        headerviewIcon.layer.borderWidth = 2
        headerviewIcon.layer.borderColor = UIColor.white.cgColor
        headerviewIcon.clipsToBounds = true
    }
}
