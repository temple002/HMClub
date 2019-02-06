//
//  HMMessageController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let message_cellID = "message_cellID"
class HMMessageController: HMBaseController {

    // item字典
    let messageItemArr = [
        ["itemName": "系统消息", "imageName": "system_message"],
        ["itemName": "社团消息", "imageName": "club_message"],
    ]
    
    var clubs = [HMClub]()
    var notes = [[String: AnyObject]]()
    //记录刷新前和刷新后的note数量
    var notesCount = 0
    // 记录是否显示小红点
    var newNoteBadgeNeeded: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }

    /// 加载数据
    override func loadData() {
        
        loadFromDB()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - 数据库相关
extension HMMessageController{
    
    func loadFromDB() {
        
        newNoteBadgeNeeded = false
        
        guard let stuNum = HMDBManager.shared.account.stuNum else{
            return
        }
        
        // 获取数据
        let result = HMSQLManager.shared.loadCheckClub(stuNum: stuNum, clubTitle: "")
        
        
        var clubs = [HMClub]()
        for dict in result {
            
            guard let clubTitle = dict["underCheckClubName"] as? String,
                let state = dict["applyState"] as? String
                
                else {
                    continue
            }
            
            if state == "审核未通过" || state == "正在审核"{
                continue
            }
            
            let clubResult = HMSQLManager.shared.loadClub(since_id: 0, clubName: clubTitle)
            
            /// 遍历查到的社团数组
            for clubDict in clubResult {
                guard let club = HMClub.yy_model(with: clubDict) else {
                    continue
                }
                club.state = state
                clubs.append(club)
            }
        }
        self.clubs = clubs
        
        /// 开始加载这个club对应的消息
        loadNoteFromDB()
    }
    
    func loadNoteFromDB() {
        
        var notes = [[String: AnyObject]]()
        for club in clubs {
            
            let noteResult = HMSQLManager.shared.loadNote(byClubName: club.clubTitle ?? "")
            
            if noteResult.count < 1 {
                continue
            }
            for noteDict in noteResult {
                
                notes.append(noteDict)
            }
        }
        notes = notes.reversed()
        self.notes = notes
        
        /// 如果刷新前和刷新后的note数量一样，就不必显示小红点了
        if notesCount == self.notes.count {
            
            newNoteBadgeNeeded = true
        }
        
        // 记录这次的note数量
        notesCount = self.notes.count
    }
}

// MARK: - 界面
extension HMMessageController{
    
    fileprivate func setupUI() {
        
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.register(UINib.init(nibName: "HMMessageCell", bundle: nil), forCellReuseIdentifier: message_cellID)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = HMThemeBgColor
        tableview?.contentInset = UIEdgeInsetsMake(35, 0, 0, 0)
    }
}

// MARK: - 数据源和代理
extension HMMessageController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageItemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: message_cellID, for: indexPath) as! HMMessageCell
        
        cell.message = messageItemArr[indexPath.row]
        
        if indexPath.row == 1 {
            
            cell.notes = notes
            cell.newNoteBadge.isHidden = newNoteBadgeNeeded
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview?.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as? HMMessageCell
            cell?.newNoteBadge.isHidden = true
            
            let messageDetail = HMMessageDetailController()
            messageDetail.title = "通知列表"
            messageDetail.notes = notes
            messageDetail.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(messageDetail, animated: true)
        }
    }
    
}





