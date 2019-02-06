//
//  HMMineJoinedClubController.swift
//  club
//
//  Created by Temple on 16/11/11.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let JoinedClubID = "JoinedClubID"

class HMMineJoinedClubController: UITableViewController {

    lazy var refreshContr = HMRefreshControl()
    lazy var checkClubs = [HMClub]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        loadData()
        
        tableView.addSubview(refreshContr)
        refreshContr.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.register(UINib.init(nibName: "HMMineJoinedClubCell", bundle: nil), forCellReuseIdentifier: JoinedClubID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = HMThemeBgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }

    @objc func loadData() {
        
        /// 加载我申请的社团数组
        HMDBManager.shared.loadMyApplyedClub { (clubs) in
            self.checkClubs = clubs.reversed()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            // 刷新tableView
            self.tableView.reloadData()
            self.refreshContr.endRefreshing()
        }
    }
}

// MARK: - 数据源
extension HMMineJoinedClubController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkClubs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinedClubID, for: indexPath) as! HMMineJoinedClubCell
        
        cell.clubModel = checkClubs[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let clubDetail = HMClubDetailController()
        clubDetail.clubModel = checkClubs[indexPath.row]
        navigationController?.pushViewController(clubDetail, animated: true)
    }
}





