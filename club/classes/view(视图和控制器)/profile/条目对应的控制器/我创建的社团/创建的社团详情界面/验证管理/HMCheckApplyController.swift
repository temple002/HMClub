//
//  HMCheckApplyController.swift
//  club
//
//  Created by Temple on 16/11/12.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let applyCheckCellID = "applyCheckCellID"
class HMCheckApplyController: HMBaseController {

    /// 从控制器获取的本社团的名称
    var clubTitle: String?
    
    /// 存放申请人的字典
    var applyUsers = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }
    
    /// 加载数据
    override func loadData() {
        
        applyUsers.removeAll()
        loadFromDB()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.contentInset = UIEdgeInsetsMake(35, 0, 0, 0)
        
        tableview?.register(UINib.init(nibName: "HMCheckApplyCell", bundle: nil), forCellReuseIdentifier: applyCheckCellID)
        
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = HMThemeBgColor
        
    }
}

// MARK: - 数据库相关
extension HMCheckApplyController{
    
    func loadFromDB() {
        guard let clubTitle = clubTitle else {
            return
        }
        
        /// 获取申请这个社团的申请人信息
        HMDBManager.shared.loadApplyUser(clubTitle: clubTitle){ (users) in
            
            applyUsers = users
        }
        
    }
}

// MARK: - 数据源
extension HMCheckApplyController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: applyCheckCellID, for: indexPath) as! HMCheckApplyCell
        cell.applyUser = applyUsers[indexPath.row]
        cell.clubTitle = clubTitle
        
        cell.tag = indexPath.row
        
        /// 设置代理
        cell.applyDelegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
    
}

// MARK: - 代理
extension HMCheckApplyController: HMCheckApplyCellDelegate{
    
    func deleteRow(cell: HMCheckApplyCell, index: Int) {
        
        guard let indexpath = tableview?.indexPath(for: cell) else{
            return
        }
        applyUsers.remove(at: indexpath.row)
        
        tableview?.deleteRows(at: [indexpath], with: .automatic)
        
        print(applyUsers)
    }
}







