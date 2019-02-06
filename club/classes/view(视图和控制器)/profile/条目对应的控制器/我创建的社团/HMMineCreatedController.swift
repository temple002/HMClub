//
//  HMMineCreatedController.swift
//  club
//
//  Created by Temple on 16/11/9.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let createdClubID = "createdClubID"
class HMMineCreatedController: UITableViewController {

    /// 刷新控件
    lazy var refreshContr = HMRefreshControl()
    /// 模型
    var createdClubModels = [HMClub]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupUI()
    }
    
    /// 加载数据
    @objc func loadData() {
        
        createdClubModels = HMDBManager.shared.account.createdClubs.reversed()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.tableView.reloadData()
            self.refreshContr.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - 界面
fileprivate extension HMMineCreatedController{
    
    func setupUI() {
        
        tableView.addSubview(refreshContr)
        tableView.register(UINib.init(nibName: "HMMineCreatedCell", bundle: nil), forCellReuseIdentifier: createdClubID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = HMThemeBgColor
        refreshContr.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
}

// MARK: - 数据源
extension HMMineCreatedController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdClubModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: createdClubID, for: indexPath) as! HMMineCreatedCell
        
        cell.createdClubModel = createdClubModels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let createdDetail = HMCreatedClubDetailController()
        
        let club = createdClubModels[indexPath.row]
        createdDetail.club = club
        
        navigationController?.pushViewController(createdDetail, animated: true)
    }
}











