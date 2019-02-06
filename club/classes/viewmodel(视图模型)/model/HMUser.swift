//
//  HMUser.swift
//  club
//
//  Created by Temple on 16/10/28.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import YYModel

fileprivate let accountName: NSString = "userAccount.json"
class HMUser: NSObject {

    /// 用户ID
    var userID: Int64 = 0
    /// 用户名
    var userName: String?
    /// 属于哪个社团
    var club: [[String: String]]?
    /// 学号
    var stuNum: String?
    /// 密码
    var psw: String?
    /// 用户图片路径
    var userIcon: String?
    /// 喜欢的社团数
    var loveClubCount: Int64 = 0
    /// 参加活动数
    var joinEventCount: Int64 = 0
    /// 创建社团数
    var createClubCount: Int64 = 0
    /// 创建的社团
    var createdClubs = [HMClub]()
    /// 参加的活动
    var joinedEvents = [HMEvent]()
    
    // 初始化的时候取出沙盒中的账户
    override init() {
        super.init()
        
        guard let path = accountName.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
        
        else{
            return
        }
        
        yy_modelSet(with: dict ?? [:])
        
    }

    /// 设置信息
    func setInfo(stuNum: String, psw: String) {
        
        userID = 1
        self.stuNum = stuNum
        self.psw = psw
    }
    
    /// 保存到沙盒
    func saveAccount() {
        let dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let accountPath = accountName.cz_appendDocumentDir()
        else{
            return
        }
        
        (data as NSData).write(toFile: accountPath, atomically: true)
    }
    
    // 黑名单
    class func modelPropertyBlacklist() -> [String] {
        
        return ["club"]
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
