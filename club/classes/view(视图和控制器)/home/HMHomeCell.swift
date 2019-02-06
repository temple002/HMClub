//
//  HMHomeCell.swift
//  club
//
//  Created by Temple on 16/10/23.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SDWebImage

class HMHomeCell: UITableViewCell {

    /// 活动标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 发布的社团名称
    @IBOutlet weak var clubName: UIButton!
    /// 活动图片
    @IBOutlet weak var activityPic: UIImageView!
    /// 活动时间
    @IBOutlet weak var activityTime: UIButton!
    /// 活动地点
    @IBOutlet weak var activityLocation: UIButton!
    
    /// 设置event信息
    var eventModel: HMEvent?{
        didSet{
            
            titleLabel.text = eventModel?.eventName
            clubName.setTitle(eventModel?.inClub, for: .normal)
            
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            
            let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((eventModel?.eventPicName)!))
            activityPic.sd_setImage(with: url as URL)
            
            let begintime = eventModel?.beginTime ?? ""
            let endtime = eventModel?.endTime ?? ""
            let time = "\(begintime)~\(endtime)"
            activityTime.setTitle(time, for: .normal)
            
            activityLocation.setTitle(eventModel?.location ?? "", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

// MARK: - 界面
fileprivate extension HMHomeCell{
    
    func setupUI() {
        clubName.layer.borderColor = HMThemeColor.cgColor
        clubName.setTitleColor(HMThemeColor, for: .normal)
        clubName.layer.borderWidth = 1
        clubName.layer.cornerRadius = 2
    }
}
