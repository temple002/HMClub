//
//  HMMineJoinedEventController.swift
//  club
//
//  Created by Temple on 16/11/10.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
fileprivate let joinedEventID = "joinedEventID"
class HMMineJoinedEventController: UITableViewController {

    lazy var refreshContr = HMRefreshControl()
    
    var eventList = [HMEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        tableView.addSubview(refreshContr)
        tableView.register(UINib.init(nibName: "HMMineJoinedCell", bundle: nil), forCellReuseIdentifier: joinedEventID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = HMThemeBgColor
        refreshContr.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // 加载数据
    @objc func loadData() {
        
        HMDBManager.shared.JoinedEventModels { (events) in
            eventList = events.reversed()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableView.reloadData()
            self.refreshContr.endRefreshing()
        }
    }
}

// MARK: - 数据源
extension HMMineJoinedEventController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: joinedEventID, for: indexPath) as! HMMineJoinedCell
        
        cell.joinedEventModel = eventList[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let eventDetail = HMEventDetailController()
        
        let eventmodel = eventList[indexPath.row]
        
        navigationController?.pushViewController(eventDetail, animated: true)
        
        eventDetail.eventModel = eventmodel
    }
}












