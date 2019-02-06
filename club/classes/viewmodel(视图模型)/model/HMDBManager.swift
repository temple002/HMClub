
//
//  HMUserAccountManager.swift
//  club
//
//  Created by Temple on 16/11/2.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation
import YYModel

class HMDBManager {
    
    /// 单例
    static let shared = HMDBManager()
    
    lazy var account = HMUser()
    
    /// 计算型属性，返回是否登录
    var isLogin: Bool {
        
        return account.userID != 0
    }
}

// MARK: - 数据库操作
extension HMDBManager{
    
    /// 加载用户数据
    func loadUserInfo(completion: (_ userModel: HMUser)->()) {
        
        // 如果登陆了，则设置用户信息
        var result = HMSQLManager.shared.loadUser(stuNum: account.stuNum ?? "")
        
        if let model = HMUser.yy_model(with: result) {
            
            /// 返回用户模型
            completion(model)
        }
        
        guard let jsonData = result["club"] as? Data,
            let createdClubData = result["createdClubs"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]],
            let createdJson = try? JSONSerialization.jsonObject(with: createdClubData, options: []) as? [[String: String]]
            else{
                return
        }
        
        /// 加载我创建的社团数据
        var createdClubs = [HMClub]()
        for json in createdJson! {
            
            if let createdClub = HMClub.yy_model(with: json) {
                
                createdClubs.append(createdClub)
            }
        }
        account.yy_modelSet(with: result)
        account.club = json
        account.createdClubs = createdClubs
    }
    
    /// 加载通知信息
    func loadNotes(clubTitle: String, isApplyNote: Bool, completion: ([[String: AnyObject]])->()) {
        
        var noteDicts = [[String: AnyObject]]()
        
        let result = HMSQLManager.shared.loadNote(byClubName: clubTitle)
        
        if result.count < 1 {
            return
        }
        for noteDict in result {
            
            var dict = noteDict
            
            let rowHeight = getRowHeight(noteDict: noteDict)
            dict["rowHeight"] = rowHeight as AnyObject?
            dict["byClubName"] = clubTitle as AnyObject?
            
            guard let isApplyNote = noteDict["isApplyNote"] as? String else{
                continue
            }
            if isApplyNote == "是" {
                continue
            }
            
            noteDicts.append(dict)
        }
        
        completion(noteDicts)
    }
    
    /// 计算通知行高
    ///
    /// - Parameter noteDict: 字典
    /// - Returns: 行高
    func getRowHeight(noteDict: [String: AnyObject]) -> CGFloat{
        
        let margin: CGFloat = 12
        let size = CGSize(width: UIScreen.cz_screenWidth() - 4 * margin, height: CGFloat(MAXFLOAT))
        
        guard let noteTitle = noteDict["noteTitle"] as? String,
            let noteText = noteDict["noteText"] as? String else{
                return 0
        }
        var height = margin + 65
        height += (noteTitle as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil).height
        height += 5 + 1 + margin
        
        height += (noteText as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil).height
        
        height += margin
        
        return height
    }
    
    /// 找到社团成员信息
    func loadClubMembers(clubTitle: String, completion: (_ applyUsers: [[String: String]])->()) {
        
        var users = [[String: String]]()
        
        // 找到这个社团所有申请的记录
        let result = HMSQLManager.shared.loadCheckClub(stuNum: "", clubTitle: clubTitle)
        
        if result.count < 1 {
            completion([[:]])
        }
        
        /// 遍历数组，找到每个申请对应的用户
        for dict in result {
            
            // 存放一个对应的用户信息
            var user = [String: String]()
            
            guard let applyStuNum = dict["applyStuNum"] as? String,
                let applyState = dict["applyState"] as? String
                else {
                    continue
            }
            
            // 如果审核通过的，不需要展示
            if applyState == "审核未通过" || applyState == "正在审核"{
                continue
            }
            
            /// 查找用户表
            let userResult = HMSQLManager.shared.loadUser(stuNum: applyStuNum)
            
            guard let userIcon = userResult["userIcon"] as? String,
                let userName = userResult["userName"] as? String
                else {
                    continue
            }
            
            user["userIcon"] = userIcon
            user["userName"] = userName
            
            users.append(user)
        }
        
        completion(users)
    }
    
    /// 找到申请这个社团的申请人信息
    func loadApplyUser(clubTitle: String, completion: (_ applyUsers: [[String: AnyObject]])->()) {
        
        var applyUsers = [[String: AnyObject]]()
        
        // 找到这个社团所有申请的记录
        let result = HMSQLManager.shared.loadCheckClub(stuNum: "", clubTitle: clubTitle)
        
        if result.count < 1 {
            completion([[:]])
        }
        
        /// 遍历数组，找到每个申请对应的用户
        for dict in result {
            
            // 存放一个对应的用户信息
            var applyUser = [String: AnyObject]()
            
            guard let applyID = dict["underCheckClubID"],
                let applyReason = dict["applyReason"],
                let applyStuNum = dict["applyStuNum"] as? String,
                let applyState = dict["applyState"] as? String
                else {
                    continue
            }
            
            // 如果审核通过的，不需要展示
            if applyState == "审核通过" || applyState == "审核未通过"{
                continue
            }
            
            /// 查找用户表
            let userResult = HMSQLManager.shared.loadUser(stuNum: applyStuNum)
            
            guard let userIcon = userResult["userIcon"] as? String,
                let userName = userResult["userName"] as? String
                else {
                    continue
            }
            
            applyUser["underCheckClubID"] = applyID as AnyObject?
            applyUser["applyReason"] = applyReason as AnyObject?
            applyUser["userIcon"] = userIcon as AnyObject?
            applyUser["userName"] = userName as AnyObject?
            applyUser["checkClub"] = dict as AnyObject?
            
            applyUsers.append(applyUser)
        }
        
        completion(applyUsers)
    }
    
    /// 返回我参加的活动模型数组
    func JoinedEventModels(completion: (_ events: [HMEvent])->()) {
        
        let stuNum = account.stuNum ?? ""
        let result = HMSQLManager.shared.loadUser(stuNum: stuNum)
        
        if result.count < 1 {
            completion([])
        }
        
        guard let joinedEvents = result["joinedEvents"] as? Data,
            let joinedJson = try? JSONSerialization.jsonObject(with: joinedEvents, options: []) as? [[String: String]]
            else{
                return
        }
        
        var events = [HMEvent]()
        for json in joinedJson! {
            
            guard let event = HMEvent.yy_model(with: json) else{
                return
            }
            events.append(event)
        }
        
        account.joinedEvents = events
        
        completion(events)
    }
    
    /// 返回我申请的社团数组
    func loadMyApplyedClub(completion: (_ clubs: [HMClub])->()) {
        
        guard let stuNum = account.stuNum else{
            return
        }
        
        // 获取数据
        let result = HMSQLManager.shared.loadCheckClub(stuNum: stuNum, clubTitle: "")
        
        if result.count < 1 {
            completion([])
        }
        
        /// 集合
        var checkClubs = [HMClub]()
        for dict in result {
            
            guard let clubTitle = dict["underCheckClubName"] as? String,
                let state = dict["applyState"] as? String
                
                else {
                    continue
            }
            
            let clubResult = HMSQLManager.shared.loadClub(since_id: 0, clubName: clubTitle)
            
            /// 遍历查到的社团数组
            for clubDict in clubResult {
                guard let club = HMClub.yy_model(with: clubDict) else {
                    continue
                }
                club.state = state
                checkClubs.append(club)
            }
        }
        
        completion(checkClubs)
    }
    
    /// 保存到沙盒
    func saveToSandBox(images: [UIImage]) -> [String]{
        
        var picPath = [String]()
        
        /// 获取现在的时间
        let date = Date()
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateformater.string(from: date)
        
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileDirect = (docPath as NSString).appendingPathComponent(dateString)
        
        // 每次创建不同的目录
        let fileManager = FileManager.default
        guard ((try? fileManager.createDirectory(atPath: fileDirect, withIntermediateDirectories: true, attributes: nil)) != nil) else{
            return []
        }
        
        for (i,image) in images.enumerated() {
            
            let imageName = String(format: "pic%d.png", i)
            
            let filePath = (fileDirect as NSString).appendingPathComponent(imageName)
            
            guard let data = UIImagePNGRepresentation(image) else{
                continue
            }
            
            (data as NSData).write(toFile: filePath, atomically: true)
            
            // 记录这个文件夹和下面的图片
            let directory = "\(dateString)/\(imageName)"
            picPath.append(directory)
        }
        return picPath
    }
    
    /// 发布动态
    func postZone(videoPath: String? = nil, zonePics: [String]? = nil, text: String) {
        
        /// 用户信息字典
        guard let userDic = account.yy_modelToJSONObject() as? [String: AnyObject]
            
        else{
            return
        }
        
        // zone
        var zoneDic = [String: AnyObject]()
        zoneDic["user"] = userDic as AnyObject?
        zoneDic["text"] = text as AnyObject?
        zoneDic["commits_count"] = 0 as AnyObject?
        zoneDic["love_count"] = 0 as AnyObject?
        zoneDic["pic_urls"] = zonePics as AnyObject?
        zoneDic["video_url"] = videoPath as AnyObject?
        
        HMSQLManager.shared.updateZone(array: [zoneDic])
    }
}
