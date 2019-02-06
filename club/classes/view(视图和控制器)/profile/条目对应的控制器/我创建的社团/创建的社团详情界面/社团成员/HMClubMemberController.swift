//
//  HMClubMemberController.swift
//  club
//
//  Created by Temple on 16/11/12.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let clubMemberCellID = "clubMemberCellID"
class HMClubMemberController: HMBaseController {

    /// 从控制器获取的本社团的名称
    var clubTitle: String?
    
    /// 存放申请人的字典
    var users = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    /// 加载数据
    override func loadData() {
        
        users.removeAll()
        loadFromDB()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func setupTableview() {
        super.setupTableview()
        tableview?.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: clubMemberCellID)
        tableview?.tableFooterView = UIView(frame: CGRect())
    }
}

// MARK: - 数据源
extension HMClubMemberController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: clubMemberCellID, for: indexPath)
        
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: HMDBManager.shared.account.userIcon ?? "")?.cz_avatarImage(size: CGSize(width: 45, height: 45))
            cell.textLabel?.text = HMDBManager.shared.account.userName ?? ""
        }else{
            
            let user = users[indexPath.row]
            let image = UIImage(named: user["userIcon"] ?? "")?.cz_avatarImage(size: CGSize(width: 45, height: 45))
            
            cell.imageView?.image = image
            cell.textLabel?.text = user["userName"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "社长、管理员"
        }else{
            return "成员"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

// MARK: - 数据库相关
extension HMClubMemberController{
    
    func loadFromDB() {
        guard let clubTitle = clubTitle else {
            return
        }
        
        /// 找到社团成员
        HMDBManager.shared.loadClubMembers(clubTitle: clubTitle) { (users) in
            
            self.users = users
        }
    }
}
