//
//  HMNoteCell.swift
//  club
//
//  Created by Temple on 16/11/13.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMNoteCell: UITableViewCell {

    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var clubName: UILabel!

    @IBOutlet weak var bgView: UIView!
    
    /// 快速设置模型
    var noteDict: [String: AnyObject]? {
        didSet{
            
            noteTitle.text = noteDict?["noteTitle"] as? String
            noteText.text = noteDict?["noteText"] as? String
            clubName.text = noteDict?["byClubName"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        bgView.layer.cornerRadius = 4
    }

}
