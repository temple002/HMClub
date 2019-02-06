//
//  HMClubsController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

let collectioncellID = "collectioncellID"

class HMClubsController: UIViewController {

    /// 表格视图
    var collectionView: UICollectionView?
    
    // club视图模型
    var clubListViewModel = HMClubListViewModel()
    /// 刷新控件
    lazy var refreshControl: HMRefreshControl = HMRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clubListViewModel.loadclubs(isPullUp: false)
        
        setupUI()
        
        // 设置导航条按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createClub))
    }
    
    /// 当返回的时候恢复导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    /// 刷新数据
    @objc func loadData() {
        
        clubListViewModel.loadclubs(isPullUp: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            self.collectionView?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// 创建社团
    func createClub() {
        
        let createClubVC = HMComposeCreateController()
        let nav = UINavigationController(rootViewController: createClubVC)
        
        self.present(nav, animated: true, completion: nil)
    }
}

// MARK: - 界面
extension HMClubsController{
    
    func setupUI() {
        
        setupCollectionView()
        
        /// 添加刷新控件
        collectionView?.addSubview(refreshControl)
        /// 让collectionView可滚动
        collectionView?.isScrollEnabled = true
        collectionView?.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    func setupCollectionView() {
        
        let rect = view.bounds.size
        
        /// 设置为流式布局
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: rect.width / 2, height: 157)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView?.backgroundColor = UIColor.white
        // 注册可重用ID
        collectionView?.panGestureRecognizer.delaysTouchesBegan = true
        collectionView?.register(UINib.init(nibName: "HMClubItemCell", bundle: nil), forCellWithReuseIdentifier: collectioncellID)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView!)
    }
    
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HMClubsController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubListViewModel.clubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectioncellID, for: indexPath) as! HMClubItemCell
        
        let club = clubListViewModel.clubList[indexPath.item]
        
        /// sdwebimage加载沙盒的图片，直接用沙盒的路径不能加载
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent(club.clubLogoPic!))
        
        cell.clubIconView.cz_setImage(url: url as URL, placeholderImage: #imageLiteral(resourceName: "avatar_default_big"), isAvatar: true)
        
        cell.clubTitleLabel.text = club.clubTitle
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let clubDetail = HMClubDetailController()
        
        clubDetail.clubModel = clubListViewModel.clubList[indexPath.item]
        navigationController?.pushViewController(clubDetail, animated: true)
    }
    
}







