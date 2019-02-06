//
//  HMMineJoinedCell.swift
//  club
//
//  Created by Temple on 16/11/10.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMMineJoinedCell: UITableViewCell {

    /// 活动图片
    @IBOutlet weak var eventPic: UIImageView!
    /// 活动标题
    @IBOutlet weak var eventTitle: UILabel!
    /// 活动所属社团
    @IBOutlet weak var inClub: UILabel!
    /// 活动内容
    @IBOutlet weak var eventDes: UILabel!

    /// 设置模型
    var joinedEventModel: HMEvent?{
        didSet{
            
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((joinedEventModel?.eventPicName)!))
            eventPic.sd_setImage(with: url as URL)
            eventTitle.text = joinedEventModel?.eventName ?? ""
            inClub.text = joinedEventModel?.inClub ?? ""
            eventDes.text = joinedEventModel?.eventDes ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inClub.layer.borderColor = HMThemeColor.cgColor
        inClub.textColor = HMThemeColor
        inClub.layer.borderWidth = 1
        inClub.layer.cornerRadius = 2
    }
}
