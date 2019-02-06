//
//  HMClubRecommend.swift
//  club
//
//  Created by Temple on 16/11/5.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMClubRecommend: UIView {
    
    // 挑选喜爱的社团的视图
    @IBOutlet weak var loveClubView: UIView!
    // open按钮
    @IBOutlet weak var openBtn: UIButton!
    
    // 用户喜欢的社团名称
    lazy var loveClubs = [[String: String]]()
    
    /// 让scrollView滚动一页
    var recommendBlock: (()->())?
    
    
    /// 快捷返回
    class func ClubRecommendView(completion: @escaping ()->()) -> HMClubRecommend{
        
        let nib = UINib(nibName: "HMClubRecommend", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! HMClubRecommend
        
        v.frame = UIScreen.main.bounds
        
        v.recommendBlock = completion
        
        return v
    }

    // open按钮点击，上传用户所喜欢的社团信息
    @IBAction func openClick() {
        
        /// 把参加活动个数写入数据库
        HMDBManager.shared.account.loveClubCount = Int64(loveClubs.count)
        
        guard var dict = HMDBManager.shared.account.yy_modelToJSONObject() as? [String: AnyObject] else{
            return
        }
        
        loveClubs.insert(["clubName": "全部"], at: 0)
        dict["club"] = loveClubs as AnyObject?
        
        HMSQLManager.shared.updateUser(dict: dict)
        
        // 则设置用户信息
        var result = HMSQLManager.shared.loadUser(stuNum: HMDBManager.shared.account.stuNum ?? "")
        guard let jsonData = result["club"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] else{
                return
        }
        HMDBManager.shared.account.yy_modelSet(with: result)
        HMDBManager.shared.account.club = json
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMHomeMenuNeedRefreshNotification), object: nil)
        
        recommendBlock?()
        
        
    }
    
    // 选中club按钮
    @objc func btnClick(btn: UIButton) {
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.isSelected = true
        
        var dict = [String: String]()
        dict["clubName"] = btn.currentTitle
        
        loveClubs.append(dict)
    }
    
    override func awakeFromNib() {
        setupUI()
    }
}

// MARK: - 界面
fileprivate extension HMClubRecommend{
    
    func setupUI() {
        openBtn.layer.cornerRadius = 4
        setupLoveClubView()
    }
    
    // 处理loveClubView界面
    func setupLoveClubView() {
        
        for item in loveClubView.subviews {
            
            if !item.isMember(of: UIButton.self) {
                continue
            }
            
            let btn = item as! UIButton
            btn.layer.cornerRadius = 2
            
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        }
    }
}







