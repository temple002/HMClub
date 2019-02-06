//
//  HMMineCreatedCell.swift
//  club
//
//  Created by Temple on 16/11/9.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMMineCreatedCell: UITableViewCell {

    /// 社团logo
    @IBOutlet weak var clubIcon: UIImageView!
    /// 社团名称
    @IBOutlet weak var clubName: UILabel!
    /// 社团类型
    @IBOutlet weak var clubType: UILabel!
    /// 社团描述
    @IBOutlet weak var clubDes: UILabel!
    
    /// 设置模型
    var createdClubModel: HMClub?{
        didSet{
            
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((createdClubModel?.clubLogoPic)!))
            clubIcon.sd_setImage(with: url as URL)
            clubName.text = createdClubModel?.clubTitle ?? ""
            clubType.text = createdClubModel?.clubType ?? ""
            clubDes.text = createdClubModel?.clubDes ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clubType.layer.borderColor = HMThemeColor.cgColor
        clubType.textColor = HMThemeColor
        clubType.layer.borderWidth = 1
        clubType.layer.cornerRadius = 2
    }

}
