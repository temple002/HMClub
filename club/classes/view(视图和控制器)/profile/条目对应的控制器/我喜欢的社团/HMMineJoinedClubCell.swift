//
//  HMMineJoinedClubCell.swift
//  club
//
//  Created by Temple on 16/11/11.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMMineJoinedClubCell: UITableViewCell {

    /// 社团logo
    @IBOutlet weak var clubPic: UIImageView!
    /// 社团标题
    @IBOutlet weak var clubTitle: UILabel!
    /// 审核状态
    @IBOutlet weak var checkState: UILabel!
    
    /// 快速设置模型
    var clubModel: HMClub?{
        didSet{
            
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((clubModel?.clubLogoPic)!))
            clubPic.sd_setImage(with: url as URL)
            
            clubTitle.text = clubModel?.clubTitle ?? ""
            checkState.text = clubModel?.state ?? ""
            
            if (clubModel?.state ?? "") == "审核通过" {
                checkState.textColor = #colorLiteral(red: 0, green: 0.6965795755, blue: 0, alpha: 1)
            }else{
                checkState.textColor = UIColor.red
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
