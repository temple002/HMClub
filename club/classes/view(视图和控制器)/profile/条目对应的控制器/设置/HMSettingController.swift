//
//  HMSettingController.swift
//  club
//
//  Created by Temple on 16/11/9.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let settingCellID = "settingCellID"
class HMSettingController: UITableViewController {

    let settingItems = [["itemName": "推送与通知"],
                        ["itemName": "个人资料设置"],
                        ["itemName": "账号密码设置"],
                        ["itemName": "使用帮助"],
                        ["itemName": "意见反馈"],
                        ["itemName": "分享给好友"],
                        ["itemName": "关于我们"]]
    

    override func loadView() {
        
        tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingCellID)
        
    }
    
    /// 注销
    @objc func logout() {
        
        let alert = UIAlertController(title: "你确定要注销吗?", message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "确定", style: .destructive){ (action) in
            
            /// 删除文件
            guard let filePath = ("userAccount.json" as NSString).cz_appendDocumentDir()
            else{
                return
            }
            let filemanager = FileManager.default
            
            try? filemanager.removeItem(atPath: filePath)
            
            // 通知登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMUserShouldLoginNotification), object: nil)
            
            HMDBManager.shared.account = HMUser()
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
}

/// 数据源
extension HMSettingController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return settingItems.count
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 {
            
            let item = settingItems[indexPath.row]
            if let itemName = item["itemName"] {
                cell.textLabel?.text = itemName
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            
            let button = UIButton()
            button.backgroundColor = HMThemeColor
            button.setTitle("注销", for: .normal)
            button.titleLabel?.textAlignment = .center
            
            /// 注销
            button.addTarget(self, action: #selector(logout), for: .touchUpInside)
            
            return button
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}











