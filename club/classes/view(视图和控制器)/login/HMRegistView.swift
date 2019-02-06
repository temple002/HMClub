//
//  HMRegistView.swift
//  club
//
//  Created by Temple on 16/11/5.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD

class HMRegistView: UIView {

    /// 昵称
    @IBOutlet weak var userName: UITextField!
    /// 学号
    @IBOutlet weak var stuNum: UITextField!
    /// 密码
    @IBOutlet weak var pwd: UITextField!
    /// 确认密码
    @IBOutlet weak var rePwd: UITextField!
    // 注册按钮
    @IBOutlet weak var registBtn: UIButton!
    
    var registBlock: (()->())?
    
    /// 快捷返回
    class func registView(completion: @escaping ()->()) -> HMRegistView{
        
        let nib = UINib(nibName: "HMRegistView", bundle: nil)
        
        //设置frame
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! HMRegistView
        
        //使用xib加载的页面默认是600 * 600的
        v.frame = UIScreen.main.bounds
        
        v.registBlock = completion
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registBtn.layer.cornerRadius = 4
    }
    
    /// 点击确认
    @IBAction func registClick() {
        if !userName.hasText || !stuNum.hasText || !pwd.hasText || !rePwd.hasText{
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "请把信息填写完整!")
            
            return
        }
        
        let pwdText = pwd.text!
        let repwdText = rePwd.text!
        /// 密码验证
        if !pwdText.isEqual(repwdText) {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "密码验证错误!")
            
            return
        }
        
        // 执行闭包
        registBlock?()
        
        var dict = [String: AnyObject]()
        
        dict["userID"] = 1 as AnyObject?
        dict["userIcon"] = "onLineIcon3.jpg" as AnyObject?
        dict["userName"] = userName.text! as AnyObject?
        dict["stuNum"] = stuNum.text! as AnyObject?
        dict["psw"] = pwd.text! as AnyObject?
        
        
        /// 设置一下全局微博用户信息
        HMDBManager.shared.account.yy_modelSet(with: dict)
        
        // 设置账号密码
        HMDBManager.shared.account.setInfo(
            stuNum: stuNum.text!,
            psw: pwd.text!)
        
        // 保存到沙盒
        HMDBManager.shared.account.saveAccount()
    }
    
}
