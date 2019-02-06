//
//  HMApplyView.swift
//  club
//
//  Created by Temple on 16/11/10.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
import pop
class HMApplyView: UIView {

    /// 文字输入框
    @IBOutlet weak var textview: UITextView!
    /// 提交按钮
    @IBOutlet weak var submitBtn: UIButton!
    
    /// 获取社团名称
    var clubTitle: String?
    
    /// 记录闭包
    var applyBlock: (()->())?
    
    class func applyView(completionBlock: @escaping ()->()) -> HMApplyView{
        
        let nib = UINib.init(nibName: "HMApplyView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! HMApplyView
        
        /// 记录闭包
        v.applyBlock = completionBlock
        
        return v
    }
    
    /// 提交按钮
    @IBAction func submitClick() {
        
        if !textview.hasText {
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "请填写申请理由")
            
            return
        }
        
        submitBtn.isSelected = true
        submitBtn.backgroundColor = UIColor.lightGray
        
        // 存入数据库
        saveToDB()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.leaveAnim()
            
        }
    }
    
    /// 退场动画
    func leaveAnim() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        
        anim?.fromValue = center.y
        anim?.toValue = center.y + 700
        
        // 弹力[0-20]
        anim?.springBounciness = 8
        // 动画速度[0-20]
        anim?.springSpeed = 3
        
        layer.pop_add(anim, forKey: nil)
        
        anim?.completionBlock = { _,_ in
            
            /// 执行闭包
            self.applyBlock?()
            self.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        
        textview.layer.borderWidth = 1
        textview.layer.borderColor = #colorLiteral(red: 0.9061367512, green: 0.9061579704, blue: 0.9061465859, alpha: 1).cgColor
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 10
        
        submitBtn.layer.cornerRadius = 4
    }
}

// MARK: - 数据库
extension HMApplyView{
    
    func saveToDB() {
        
        guard let clubTitle = clubTitle,
            let stuNum = HMDBManager.shared.account.stuNum,
            let applyReason = textview.text
        else {
            return
        }
        
        var checkDict = [String: String]()
        checkDict["underCheckClubName"] = clubTitle
        checkDict["applyStuNum"] = stuNum
        checkDict["applyReason"] = applyReason
        checkDict["applyState"] = "正在审核"
        
        HMSQLManager.shared.updateUnderCheck(dict: checkDict as [String : AnyObject])
    }
}




