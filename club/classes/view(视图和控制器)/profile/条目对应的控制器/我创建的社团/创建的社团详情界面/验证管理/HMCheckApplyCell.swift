//
//  HMCheckApplyCell.swift
//  club
//
//  Created by Temple on 16/11/12.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

/// 代理，点击同意或者拒绝后删除本条cell
protocol HMCheckApplyCellDelegate: NSObjectProtocol {
    
    func deleteRow(cell: HMCheckApplyCell, index: Int)
}

class HMCheckApplyCell: UITableViewCell {

    /// 用户头像
    @IBOutlet weak var userIcon: UIImageView!
    /// 用户名
    @IBOutlet weak var userName: UILabel!
    /// 申请理由
    @IBOutlet weak var applyReason: UITextView!
    /// 同意按钮
    @IBOutlet weak var agreeBtn: UIButton!
    /// 拒绝按钮
    @IBOutlet weak var refuseBtn: UIButton!
    
    weak var applyDelegate: HMCheckApplyCellDelegate?
    
    /// 记录社团名称
    var clubTitle: String?
    /// 快速设置模型
    var applyUser: [String: AnyObject]?{
        didSet{
            
            userIcon.image = UIImage(named: applyUser?["userIcon"] as? String ?? "")
            userName.text = applyUser?["userName"] as? String
            applyReason.text = applyUser?["applyReason"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        agreeBtn.layer.cornerRadius = 4
        refuseBtn.layer.cornerRadius = 4
        userIcon.layer.cornerRadius = 30
        userIcon.clipsToBounds = true
        
    }
    
    /// 同意点击事件
    @IBAction func agreeClick() {
        
        updateCheckState(isAgree: true)
    }
    /// 拒绝点击事件
    @IBAction func refuseClick() {
        
        updateCheckState(isAgree: false)
    }
}

// MARK: - 数据库相关的
extension HMCheckApplyCell{
    
    func updateCheckState(isAgree: Bool) {
        
        let checkState = (isAgree == true) ? "审核通过": "审核未通过"
        
        guard var checkClub = applyUser?["checkClub"] as? [String: AnyObject] else {
            return
        }
        
        checkClub["applyState"] = checkState as AnyObject?
        
        HMSQLManager.shared.updateUnderCheck(dict: checkClub)
        
        // 代理执行
        applyDelegate?.deleteRow(cell: self, index: self.tag)
        
        // 发布通知
        var noteDict = [String: String]()
        noteDict["noteTitle"] = "申请验证通知"
        noteDict["noteText"] = (isAgree == true) ? "恭喜您成功加入本社团" : "抱歉您还没有资格加入我们社团"
        noteDict["byClubName"] = clubTitle
        noteDict["isApplyNote"] = "是"
        
        HMSQLManager.shared.updateNote(dict: noteDict)
    }
}




