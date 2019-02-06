//
//  HMEventDetailController.swift
//  club
//
//  Created by Temple on 16/11/7.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

/// 活动详情页
class HMEventDetailController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    /// 活动图片
    @IBOutlet weak var eventPic: UIImageView!
    /// 活动名称
    @IBOutlet weak var eventName: UILabel!
    /// 发起社团
    @IBOutlet weak var club: UILabel!
    /// 活动开始时间
    @IBOutlet weak var beginTime: UILabel!
    /// 活动结束时间
    @IBOutlet weak var endTime: UILabel!
    /// 活动详细介绍
    @IBOutlet weak var eventDetail: UITextView!
    /// 参加活动按钮
    @IBOutlet weak var joinBtn: UIButton!
    
    // 快速设置模型
    var eventModel: HMEvent?
    
    // 设置内容
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((eventModel?.eventPicName)!))
        eventPic.sd_setImage(with: url as URL)
        eventName.text = eventModel?.eventName ?? ""
        club.text = eventModel?.inClub ?? ""
        beginTime.text = eventModel?.beginTime ?? ""
        endTime.text = eventModel?.endTime ?? ""
        eventDetail.text = eventModel?.eventDes ?? ""
        
        /// 检查我是否已经参加了这个活动
        checkJoinedState()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinBtn.layer.cornerRadius = 4
        
        scrollview.contentInset.top = -20
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // 返回按钮
    @IBAction func backClick() {
        let _ = navigationController?.popViewController(animated: true)
    }
    /// 加入社团按钮点击
    @IBAction func joinClick() {
        
        // 写入数据库
        writeToDB()
        
        joinBtn.isSelected = true
        joinBtn.backgroundColor = UIColor.lightGray
    }
}


// MARK: - 数据库
extension HMEventDetailController{
    
    /// 检查我是否已经参加这个活动
    func checkJoinedState() {
        
        guard let eventModel = eventModel else {
            return
        }
        
        HMDBManager.shared.JoinedEventModels { (events) in
            
            for event in events {
                
                if event.eventName != eventModel.eventName{
                    continue
                }
                
                self.joinBtn.isSelected = true
                joinBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    func writeToDB() {
        
        // 获取userID
        let userID = HMDBManager.shared.account.userID
        
        // 获取要存入的event模型
        guard let eventModel = eventModel else {
            return
        }
        // 加入全局user对象中
        HMDBManager.shared.account.joinedEvents.append(eventModel)
        
        /// 把参加活动个数写入数据库
        let joinedEventCount = HMDBManager.shared.account.joinedEvents.count
        HMDBManager.shared.account.joinEventCount = Int64(joinedEventCount)
        
        // 生成json数据
        guard var json = HMDBManager.shared.account.yy_modelToJSONObject() as? [String: AnyObject] else{
            return
        }
        
        /// 将club信息添加到json里面
        var result = HMSQLManager.shared.loadUser(stuNum: HMDBManager.shared.account.stuNum ?? "")
        guard let jsonData = result["club"] as? Data,
            let clubJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] else{
                return
        }
        json["club"] = clubJson as AnyObject?
        /// 写入数据库
        HMSQLManager.shared.updateUser(userID: userID, dict: json)
        
    }
}






