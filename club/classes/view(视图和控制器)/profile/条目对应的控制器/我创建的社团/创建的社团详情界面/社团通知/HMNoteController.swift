//
//  HMNoteController.swift
//  club
//
//  Created by Temple on 16/11/13.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let NoteCellID = "NoteCellID"
/// 社团的通知管理控制器
class HMNoteController: HMBaseController {

    /// 从控制器获取的本社团的名称
    var clubTitle: String?
    var notes = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    /// 加载信息
    override func loadData() {
        
        loadFromDB()
        tableview?.reloadData()
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.contentInset = UIEdgeInsetsMake(35, 0, 0, 0)
        
        tableview?.backgroundColor = HMThemeBgColor
        tableview?.register(UINib.init(nibName: "HMNoteCell", bundle: nil), forCellReuseIdentifier: NoteCellID)
        tableview?.separatorStyle = .none
        
        tableview?.rowHeight = UITableViewAutomaticDimension
        tableview?.estimatedRowHeight = 81
    }
}

// MARK: - 数据库相关
extension HMNoteController{
    
    func loadFromDB() {
        
        guard let clubTitle = clubTitle else {
            return
        }
        
        /// 加载通知信息
        HMDBManager.shared.loadNotes(clubTitle: clubTitle, isApplyNote: false) { (notes) in
            
            self.notes = notes
        }
    }
}

// MARK: - 数据源
extension HMNoteController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCellID, for: indexPath) as! HMNoteCell
        
        cell.noteDict = notes[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let note = notes[indexPath.row]
        
        if let height = note["rowHeight"] as? CGFloat{
            return height
        }else{
            return 81
        }
    }
}










