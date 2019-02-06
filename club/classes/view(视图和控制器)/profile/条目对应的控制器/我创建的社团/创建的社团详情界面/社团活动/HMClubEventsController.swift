//
//  HMClubEventsController.swift
//  club
//
//  Created by Temple on 16/11/12.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let clubEventsCellID = "clubEventsCellID"
class HMClubEventsController: HMBaseController {

    /// 动态列表模型
    let eventlistModel = HMEventListViewModel()
    var clubEvents = [HMEvent]()
    
    /// 从控制器获取的本社团的名称
    var clubTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    
        eventlistModel.loadEvents(isPullUp: false)
        for event in eventlistModel.eventList {
            
            if event.inClub == clubTitle{
                clubEvents.append(event)
            }
        }
    }
    
    // 加载数据
    override func loadData() {
        
        eventlistModel.loadEvents(isPullUp: true)
        
        clubEvents.removeAll()
        for event in eventlistModel.eventList {
            
            if event.inClub == clubTitle{
                clubEvents.append(event)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

// MARK: - 界面
extension HMClubEventsController{
    
    override func setupTableview() {
        super.setupTableview()
        tableview?.backgroundColor = HMThemeBgColor
        tableview?.register(UINib.init(nibName: "HMHomeCell", bundle: nil), forCellReuseIdentifier: clubEventsCellID)
        tableview?.tableFooterView = UIView(frame: CGRect())
    }
}

// MARK: - 数据源
extension HMClubEventsController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: clubEventsCellID, for: indexPath) as! HMHomeCell
        
        cell.eventModel = clubEvents[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventDetail = HMEventDetailController()
        
        let eventmodel = eventlistModel.eventList[indexPath.row]
        
        eventDetail.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(eventDetail, animated: true)
        
        eventDetail.eventModel = eventmodel
        
        tableview?.deselectRow(at: indexPath, animated: true)
    }
}











