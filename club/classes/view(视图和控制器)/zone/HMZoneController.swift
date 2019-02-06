//
//  HMZoneController.swift
//  club
//
//  Created by Temple on 16/10/27.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import MediaPlayer

fileprivate let zoneCellID = "zoneCellID"
class HMZoneController: HMBaseController {

    /// 动态列表模型
    let zonelistModel = HMZoneListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 加载
        zonelistModel.loadZones(isPullUp: false)
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(needRefresh), name: NSNotification.Name(rawValue: HMZoneNeedRefreshNotification), object: nil)

        // 注册图片浏览器通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(browserPhoto(n:)),
            name: NSNotification.Name(rawValue: HMStatusCellBrowserPhotoNotification),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    // 通知方法
    @objc func browserPhoto(n: NSNotification) {
        
        // 从通知那里取数据
        guard let selectedIndex = n.userInfo?[HMStatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = n.userInfo?[HMStatusCellBrowserPhotoURLsKey] as? [String],
            let imageviewList = n.userInfo?[HMStatusCellBrowserPhotoImageViewsKey] as? [UIImageView]
            
            else{
                return
        }
        
        let photoBrowser = HMPhotoBrowserController.photoBrowser(withSelectedIndex:selectedIndex,
                                                                 urls: urls,
                                                                 parentImageViews: imageviewList)
        
        present(photoBrowser, animated: true, completion: nil)
    }
    
    // 需要刷新
    @objc func needRefresh() {
        
        refreshControl.beginRefreshing()
        loadData()
    }
    
    // 加载数据
    override func loadData() {
        zonelistModel.loadZones(isPullUp: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.tableview?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - 界面
extension HMZoneController{
    
    fileprivate func setupUI() {
        
    }
    
    override func setupTableview() {
        super.setupTableview()
        
        tableview?.register(UINib.init(nibName: "HMZoneCell", bundle: nil), forCellReuseIdentifier: zoneCellID)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = HMThemeBgColor
        tableview?.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
    }
    
}

// MARK: - 数据源和代理
extension HMZoneController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zonelistModel.zoneList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: zoneCellID, for: indexPath) as! HMZoneCell
        
        let zoneViewmodel = zonelistModel.zoneList[indexPath.row]
        
        cell.zoneviewModel = zoneViewmodel
        cell.mediaView.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let zoneViewmodel = zonelistModel.zoneList[indexPath.row]
        
        return zoneViewmodel.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview?.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 播放视频代理
extension HMZoneController: HMZoneCellDelegate{
    
    func playVidio(mediaView: HMMediaView, videoPath: String) {
        
        guard let filePath = (videoPath as NSString).cz_appendDocumentDir() else{
            return
        }
        
        let url = NSURL(fileURLWithPath: filePath) as URL
        
        if let videoPlayer = MPMoviePlayerViewController(contentURL: url) {
            
            present(videoPlayer, animated: true){}
        }
    }
}








