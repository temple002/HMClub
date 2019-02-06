//
//  HMMessageDetailController.swift
//  club
//
//  Created by Temple on 16/11/13.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let messageDetailcellID = "messageDetailcellID"
class HMMessageDetailController: HMBaseController {

    var notes = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    /// 加载数据
    override func loadData() {

        var noteDicts = [[String: AnyObject]]()
        
        for noteDict in notes {
            
            var dict = noteDict
            
            let rowHeight = getRowHeight(noteDict: noteDict)
            dict["rowHeight"] = rowHeight as AnyObject?
            noteDicts.append(dict)
        }
        
        notes = noteDicts
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){

            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// 计算行高
    ///
    /// - Parameter noteDict: 字典
    /// - Returns: 行高
    func getRowHeight(noteDict: [String: AnyObject]) -> CGFloat{
        
        let margin: CGFloat = 12
        let size = CGSize(width: UIScreen.cz_screenWidth() - 4 * margin, height: CGFloat(MAXFLOAT))
        
        guard let noteTitle = noteDict["noteTitle"] as? String,
            let noteText = noteDict["noteText"] as? String else{
                return 0
        }
        var height = margin + 50
        height += (noteTitle as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil).height
        height += 5 + 1 + margin
        
        height += (noteText as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil).height
        
        height += margin
        
        return height
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.register(UINib.init(nibName: "HMNoteCell", bundle: nil), forCellReuseIdentifier: messageDetailcellID)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = HMThemeBgColor
    }
}

// MARK: - 数据源
extension HMMessageDetailController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageDetailcellID, for: indexPath) as! HMNoteCell
        
        cell.noteDict = notes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let note = notes[indexPath.row]
        
        if let height = note["rowHeight"] as? CGFloat{
            return height + 5
        }else{
            return 81
        }
    }
}
