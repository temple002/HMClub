//
//  HMMessageCell.swift
//  club
//
//  Created by Temple on 16/10/24.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMMessageCell: UITableViewCell {

    /// 消息图片
    @IBOutlet weak var messageIcon: UIImageView!
    /// 消息标题
    @IBOutlet weak var messageTitle: UILabel!
    /// 消息详细信息
    @IBOutlet weak var messageDetailTitle: UILabel!
    /// 新消息来了的角标
    @IBOutlet weak var newNoteBadge: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newNoteBadge.layer.cornerRadius = 4
        newNoteBadge.isHidden = true
    }
    
    /// 存储notes
    var notes: [[String: AnyObject]]?{
        didSet{
            
            guard let notes = notes else {
                return
            }
            if notes.count < 1 {
                return
            }
            
            newNoteBadge.isHidden = false
            messageDetailTitle.text = notes[0]["noteTitle"] as? String
        }
    }
    
    /// 设置我的界面的 条目界面
    var message: [String: String]?{
        didSet{
            messageIcon.image = UIImage(named: message?["imageName"] ?? "")
            messageTitle.text = message?["itemName"] ?? ""
            messageDetailTitle.text = "无"
        }
    }
}
