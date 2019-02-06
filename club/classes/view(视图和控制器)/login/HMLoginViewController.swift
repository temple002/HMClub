//
//  HMLoginView.swift
//  club
//
//  Created by Temple on 16/11/2.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 登录视图
class HMLoginViewController: UIViewController {

    /// 学号输入框
    @IBOutlet weak var stuNumTextView: UITextField!
    /// 密码输入框
    @IBOutlet weak var pswTextview: UITextField!
    /// 提交按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
    // 点击注册新用户
    @IBAction func registNewUserClick() {
    }
    /// 提交按钮点击事件
    @IBAction func loginClick() {
        
        if !stuNumTextView.hasText || !pswTextview.hasText {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "请把信息填写完整")
            return
        }
        
        // 在数据库中对比账号密码是否正确
        let dict = HMSQLManager.shared.loadUser(stuNum: stuNumTextView.text ?? "")
        
        guard let stuNum = dict["stuNum"] as? String,
            let psw = dict["psw"] as? String,
            let sntv = stuNumTextView.text,
            let ptv = pswTextview.text
        else{
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "学号或密码错误")
            return
        }
        
        // 如果账号密码对，则保存到沙盒
        if stuNum == sntv && psw == ptv {
            
            // 设置账号密码
            HMDBManager.shared.account.setInfo(
                stuNum: stuNumTextView.text!,
                psw: pswTextview.text!)
            
            // 保存到沙盒
            HMDBManager.shared.account.saveAccount()
            
            // 更新用户数据
            guard let jsonData = dict["club"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] else{
                    return
            }
            HMDBManager.shared.account.yy_modelSet(with: dict)
            HMDBManager.shared.account.club = json
            
            // 通知menuView更新item
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMHomeMenuNeedRefreshNotification), object: nil)
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showSuccess(withStatus: "正在登录...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                SVProgressHUD.dismiss()
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: {
                    
                })
            })
            
        }else{
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "学号或密码错误")
            
        }
        
    }
    
    /// 注册
    @IBAction func registClick() {
        
        navigationController?.navigationBar.isHidden = true
        // 如果没注册，则显示注册界面
        let newUserView = HMNewUserView()
        newUserView.frame = view.bounds
        
        view.addSubview(newUserView)
        
        /// 注册完成，自己dismiss一下
        newUserView.completeRegistBlock = {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 关闭
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - 界面
fileprivate extension HMLoginViewController{
    
    func setupUI() {
        
        loginBtn.layer.cornerRadius = 4
        
        self.title = "登录"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(close))
        
    }
}
