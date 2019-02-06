//
//  HMHomeController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

fileprivate let cellID = "HomecellID"
class HMHomeController: HMBaseController {
    
    var menuview: HMMenuView?
    
    // 菜单条目
    lazy var menuArr = [String]()
    
    /// 动态列表模型
    let eventlistModel = HMEventListViewModel()
    
    /// 数据
    var events = [HMEvent]()
    
    
    /// 当从详情页返回时，显示导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载
        eventlistModel.loadEvents(isPullUp: false)
        events = eventlistModel.eventList
        
        setupUI()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(needRefresh), name: NSNotification.Name(rawValue: HMEventNeedRefreshNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(menuRefresh), name: NSNotification.Name(rawValue:HMHomeMenuNeedRefreshNotification), object: nil)
    }
    
    /// 更新menuView
    @objc func menuRefresh() {
        
        // 清空按钮
        for v in menuview?.subviews ?? []{
            
            v.removeFromSuperview()
        }
        // 置空数组
        menuArr = []
        for dict in HMDBManager.shared.account.club ?? [[:]] {
            
            menuArr.append(dict["clubName"] ?? "")
        }
        menuview?.menus = menuArr
    }
    
    /// 刷新数据
    @objc func needRefresh() {
        refreshControl.beginRefreshing()
        loadData()
    }
    
    /// 加载数据
    override func loadData() {
        
        eventlistModel.loadEvents(isPullUp: true)
        
        events = eventlistModel.eventList
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    /// 显示所有社团控制器
    func homeMenuClick() {
        
        let vc = HMClubsController()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 界面
extension HMHomeController{
    
    fileprivate func setupUI() {
        
        let menuview = HMMenuView()
        
        var menusArr: [String]?
        // 如果登录了，则已经加载好了数据
        if HMDBManager.shared.isLogin == true {
            
            menusArr = [String]()
            for dict in HMDBManager.shared.account.club ?? [[:]] {
                menusArr?.append(dict["clubName"] ?? "")
            }
        }
        menuview.menus = menusArr ?? []
        
        menuview.frame = CGRect(x: 0, y: 64, width: UIScreen.cz_screenWidth(), height: 40)
        self.menuview = menuview
        // 注册代理
        menuview.selectedDelegate = self
        
        // 添加到View上，在tableView上面
        view.insertSubview(menuview, aboveSubview: tableview!)
        
    }
    /// 设置tableView
    override func setupTableview() {
        super.setupTableview()
    
        tableview?.register(UINib.init(nibName: "HMHomeCell", bundle: nil), forCellReuseIdentifier: cellID)
        
        tableview?.estimatedSectionFooterHeight = 0
        tableview?.estimatedSectionHeaderHeight = 0
        tableview?.contentInset = UIEdgeInsetsMake(108, 0, 0, 0)
//        tableview?.contentInset.top = 40
//        tableview?.scrollIndicatorInsets.top = 40
        tableview?.backgroundColor = HMThemeBgColor
        tableview?.tableFooterView = UIView(frame: CGRect())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home_category_icon"), style: .plain, target: self, action: #selector(homeMenuClick))
    }
}

// MARK: - 选中菜单按钮代理
extension HMHomeController: HMMenuViewDelegate{

    /// menuView按钮点击事件
    ///
    /// - Parameters:
    ///   - menuView: menuView
    ///   - selectedBtn: 选中按钮
    func menuViewDidSelectedItem(menuView: HMMenuView, selectedBtn: UIButton) {
        
        events.removeAll()
        
        /// 如果是选中全部，则展示所有社团活动
        if selectedBtn.currentTitle == "全部" {
            
            events = eventlistModel.eventList
            
        }else{
            
            /// 如果选中具体社团，则查找这个社团发布的活动
            for event in eventlistModel.eventList {
                
                if event.inClub == selectedBtn.currentTitle{
                    events.append(event)
                }
            }
        }
        tableview?.reloadData()
    }
}

// MARK: - 数据源
extension HMHomeController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HMHomeCell
        
        let model = events[indexPath.row]
        
        cell.eventModel = model
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventDetail = HMEventDetailController()
        
        let eventmodel = events[indexPath.row]
        
        eventDetail.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(eventDetail, animated: true)
        
        eventDetail.eventModel = eventmodel
        
        tableview?.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}









