//
//  HMProfileController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let profileCellID = "profileCellID"
class HMProfileController: HMBaseController {

    /// 记录我的界面中的选项条
    var mineProfiles: [[String: AnyObject]]?
    
    /// 记录headerview
    var headerView: HMProfileHeaderView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // 加载用户数据
        loadUserInfo()
    }
    
    // 重新加载
    override func loadData() {
        loadUserInfo()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - 获取数据库数据
extension HMProfileController{
    /// 加载用户数据
    func loadUserInfo() {
        
        /// 加载用户信息
        HMDBManager.shared.loadUserInfo { (user) in
            self.headerView?.userModel = user
        }
    }
}

// MARK: - 界面
extension HMProfileController{
    
    fileprivate func setupUI() {
        guard let path = Bundle.main.path(forResource: "Mine.json", ofType: nil),
            let data = NSData(contentsOfFile: path),
            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! [[String: AnyObject]]
            else{
                return
        }
        
        mineProfiles = array
        
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.register(UINib.init(nibName: "HMProfileCell", bundle: nil), forCellReuseIdentifier: profileCellID)
        tableview?.separatorStyle = .none
        
        let headerview = HMProfileHeaderView.profileHeaderView()
        self.headerView = headerview
        
        tableview?.tableHeaderView = headerView
        tableview?.backgroundColor = HMThemeBgColor
    }
}

// MARK: - UITableViewDataSource, UITabBarDelegate
extension HMProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mineProfiles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: profileCellID, for: indexPath) as! HMProfileCell
        
        let profile = mineProfiles?[indexPath.row]
        
        cell.profile = profile as! [String : String]?
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    // 点击进入对应的控制器
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview?.deselectRow(at: indexPath, animated: true)
        
        guard let profile = mineProfiles?[indexPath.row],
            let title = profile["title"] as? String,
            let clsName = profile["clsName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            
        else{
            return
        }
        
        let vc = cls.init()
        vc.title = title
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}









