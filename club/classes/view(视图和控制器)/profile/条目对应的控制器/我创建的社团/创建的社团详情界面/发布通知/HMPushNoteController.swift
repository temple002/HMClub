//
//  HMPushNoteController.swift
//  club
//
//  Created by Temple on 16/11/12.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
class HMPushNoteController: UIViewController {

    /// 通知标题
    @IBOutlet weak var noteTitle: UITextField!
    /// 通知正文
    @IBOutlet weak var noteText: UITextView!

    /// 从控制器获取的本社团的名称
    var clubTitle: String?
    
    lazy var sendButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 背景为橘黄色时，文字颜色为白色
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        
        // 设置背景
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        // 添加监听
        btn.addTarget(self, action: #selector(pushNote), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitle.becomeFirstResponder()
        setupUI()
    }
    
    // 发布通知
    @objc func pushNote() {
        
        guard let clubTitle = clubTitle else {
            return
        }
        var noteDict = [String: String]()
        noteDict["noteTitle"] = noteTitle.text!
        noteDict["noteText"] = noteText.text!
        noteDict["byClubName"] = clubTitle
        noteDict["isApplyNote"] = "否"
        
        HMSQLManager.shared.updateNote(dict: noteDict)
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: "发布成功")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            SVProgressHUD.dismiss()
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func close() {
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - 界面
fileprivate extension HMPushNoteController{
    
    func setupUI() {
        
        setupNav()
        
        noteText.delegate = self
        noteTitle.delegate = self
        
        noteTitle.layer.cornerRadius = 4
        noteText.layer.cornerRadius = 4
    }
    
    /// 导航栏设置
    func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
    }
}


// MARK: - 代理
extension HMPushNoteController: UITextViewDelegate, UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkNote()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkNote()
    }
    
    // 检查是否符合提交要求
    func checkNote() {
        if noteTitle.hasText && noteText.hasText {
            sendButton.isEnabled = true
        }else{
            sendButton.isEnabled = false
        }
    }
}







