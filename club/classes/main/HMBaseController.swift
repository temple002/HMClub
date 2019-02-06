//
//  HMBaseController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMBaseController: UIViewController {

    var tableview: UITableView?
    
    lazy var refreshControl: HMRefreshControl = HMRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    // 刷新数据
    func loadData() {
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

extension HMBaseController{
    
    fileprivate func setupUI() {
        
        setupTableview()
        
        if #available(iOS 11.0, *) {
            tableview?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func setupTableview() {
        
        tableview = UITableView(frame: view.bounds, style: .plain)
        
        tableview?.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableview?.delegate = self
        tableview?.dataSource = self
        
        view.addSubview(tableview!)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HMBaseController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
