//
//  HMSQLManager.swift
//  L29-数据库
//
//  Created by Temple on 16/10/16.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation
import FMDB

// 5 天后会清理缓存
//private let maxDBCacheTime: TimeInterval = -60//-5 * 24 * 60 * 60

/// 数据库管理器
class HMSQLManager {
    
    /// 单例，管理器的全局访问点
    static let shared = HMSQLManager()
    
    // 数据库队列单例
    let queue: FMDatabaseQueue
    
    private init() {
    
        let dbName = "zone.db"
        
        // 数据库全路径 - path
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        // 创建数据库
        queue = FMDatabaseQueue(path: path)
        
        print(path)
        // 打开数据库
        createTable(sqlName: "zone.sql")
        createTable(sqlName: "user.sql")
        createTable(sqlName: "Event.sql")
        createTable(sqlName: "Club.sql")
        createTable(sqlName: "underCheckClub.sql")
        createTable(sqlName: "note.sql")
        // 添加通知监听，进入后台清理缓存
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(clearDBCache),
//                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
//                                               object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    /// 清理数据缓存
    /// 注意细节：
    /// - SQLite 的数据不断的增加数据，数据库文件的大小，会不断的增加
    /// - 但是：如果删除了数据，数据库的大小，不会变小！
    /// - 如果要变小
    /// 1> 将数据库文件复制一个新的副本，status.db.old
    /// 2> 新建一个空的数据库文件
    /// 3> 自己编写 SQL，从 old 中将所有的数据读出，写入新的数据库！
//    @objc private func clearDBCache() {
//        
//        let dateString = Date.hm_dateString(delta: maxDBCacheTime)
//        
//        print("清理数据缓存 \(dateString)")
//        
//        // 准备 SQL
//        let sql = "DELETE FROM T_Zone WHERE createTime < ?;"
//        
//        // 执行 SQL
//        queue.inDatabase { (db) in
//            
//            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
//                
//                print("删除了 \(db?.changes()) 条记录")
//            }
//        }
//    }
}

// MARK: - 微博数据操作
extension HMSQLManager{
    
    
    /// 从数据库加载数据
    ///
    /// - parameter userID:   userID
    /// - parameter since_id: 返回ID比 since_id大的微博
    ///
    /// - returns: 将数据库中的 status 字段处理成字典数组
    func loadZone(since_id: Int64 = 0, completion: (_ result: [[String: AnyObject]])->()) {
        
        // 拼接sql
        var sql = "SELECT zone, createTime from T_Zone\n"
        sql += "WHERE zoneID > \(since_id)\n"
        
        // 用这个函数执行返回查询的结果
        let array = execRecordSet(sql: sql)
        
        if array.count < 1 {
            completion([[:]])
        }
        
        var result = [[String: AnyObject]]()
        
        var zoneDic = [String: AnyObject]()
        for dict in array {
            // 取出dict中的 status ，反序列化
            guard let createTime = dict["createTime"] as? String,
            let jsonData = dict["zone"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else{
                continue
            }
            
            zoneDic["createTime"] = createTime as AnyObject?
            zoneDic["zone"] = json as AnyObject?
            
            result.append(zoneDic)
        }
        
        completion(result.reversed())
    }
    
    /// 加载审核社团信息
    func loadCheckClub(stuNum: String = "", clubTitle: String = "") -> [[String: AnyObject]]{
        
        var sql = "SELECT underCheckClubID, underCheckClubName, applyStuNum, applyReason, applyState from T_UnderCheckClub\n"
        
        if stuNum != "" {
            
            sql += "WHERE applyStuNum = \(stuNum)"
        }else if clubTitle != "" {
            
            sql += "WHERE underCheckClubName = \'\(clubTitle)\'"
        }else{
            return [[:]]
        }
        
        let array = execRecordSet(sql: sql)
        
        if array.count < 1 {
            return [[:]]
        }
        
        return array
    }
    
    /// 加载活动列表
    ///
    /// - Parameters:
    ///   - since_id: since_id
    func loadEvent(since_id: Int64 = 0, completion: (_ result: [[String: AnyObject]])->()) {
        
        // 拼接sql
        var sql = "SELECT event from T_Event\n"
        sql += "WHERE eventID > \(since_id)\n"
        
        // 用这个函数执行返回查询的结果
        let array = execRecordSet(sql: sql)
        
        if array.count < 1 {
            completion([[:]])
        }
        
        var result = [[String: AnyObject]]()
        
        var eventDic = [String: AnyObject]()
        for dict in array {
            // 取出dict中的 status ，反序列化
            guard let jsonData = dict["event"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else{
                    continue
            }
            
            eventDic["event"] = json as AnyObject?
            
            result.append(eventDic)
        }
        
        completion(result.reversed())
    }
    
    // 加载通知信息
    func loadNote(byClubName: String) -> [[String: AnyObject]] {
        
        // 拼接sql
        var sql = "SELECT noteTitle,noteText,byClubName, isApplyNote from T_NOTE\n"
        sql += "where byClubName = \'\(byClubName)\'\n"
        
        // 用这个函数执行返回查询的结果
        let array = execRecordSet(sql: sql)
        
        return array
    }
    
    // 加载用户信息
    func loadUser(stuNum: String) -> [String: AnyObject] {
        
        // 拼接sql
        var sql = "SELECT userID,stuNum, psw, club, userIcon, userName, loveClubCount, joinEventCount, createClubCount, createdClubs, joinedEvents from T_User\n"
        sql += "where stuNum = \'\(stuNum)\'\n"
        
        // 用这个函数执行返回查询的结果
        let array = execRecordSet(sql: sql)
        
        if array.count < 1 {
            return [:]
        }
        
        return array[0]
    }
    
    // 加载社团信息
    func loadClub(since_id: Int64 = 0, clubName: String? = nil) -> [[String: AnyObject]] {
        // 拼接sql
        var sql = "SELECT clubTitle, clubLogoPic, clubType, clubDes from T_Club\n"
        sql += "where clubID > \(since_id)\n"
        
        if clubName != nil {
            guard let clubName = clubName else {
                return [[:]]
            }
            sql += "and clubTitle = \'\(clubName)\'"
        }
        
        // 用这个函数执行返回查询的结果
        let array = execRecordSet(sql: sql)
        
        return array.reversed()
    }
    
    
    /// 更新账户信息
    ///
    /// - Parameter dict: 账户字典
    func updateUser(userID: Int64? = nil, dict: [String: AnyObject]) {
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_User ('userID','userName', 'userIcon', 'stuNum','psw','club','loveClubCount','joinEventCount','createClubCount','createdClubs','joinedEvents') VALUES (?,?,?,?,?,?,?,?,?,?,?)"
        
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
            
            let userID = userID ?? nil
            let userName = (dict["userName"] as? String)
            let userIcon = (dict["userIcon"] as? String)
            let stuNum = (dict["stuNum"] as? String)
            let psw = (dict["psw"] as? String)
            
            let loveClubCount = (dict["loveClubCount"] as? Int64) ?? 0
            let joinEventCount = (dict["joinEventCount"] as? Int64) ?? 0
            let createClubCount = (dict["createClubCount"] as? Int64)
            
            var joinedEventsDefault = dict["joinedEvents"]
            var createdClubsDefault = dict["createdClubs"]
            
            // 我喜欢的社团
            guard let clubDict = dict["club"] as? [[String: String]],
                let data = try? JSONSerialization.data(withJSONObject: clubDict, options: []) else{
                    return
            }
            /// 判断是否有创建社团的信息
            if let createdClubs = dict["createdClubs"] as? [[String: String]],
                let createdData = try? JSONSerialization.data(withJSONObject: createdClubs, options: []){
            
                createdClubsDefault = createdData as AnyObject?
            }
            /// 判断是否有参加活动的信息
            if let joinedEvents = dict["joinedEvents"] as? [[String: String]],
                let joinedEventsData = try? JSONSerialization.data(withJSONObject: joinedEvents, options: []){
                
                joinedEventsDefault = joinedEventsData as AnyObject?
            }
            
            
            // 执行sql语句
            if db?.executeUpdate(sql, withArgumentsIn: [userID as Any,userName as Any,userIcon as Any,stuNum as Any,psw as Any,data,loveClubCount,joinEventCount,createClubCount as Any,createdClubsDefault as Any,joinedEventsDefault as Any]) == false{
                
                // 需要回滚
                rollback?.pointee = true
                
                return
            }
            
        }
    }
    
    /// 增加或更新待审查的申请
    ///
    /// - Parameter dict: userCheckClub字典
    func updateUnderCheck(dict: [String: AnyObject]) {
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_UnderCheckClub ('underCheckClubID','underCheckClubName','applyStuNum','applyReason','applyState') VALUES (?,?,?,?,?)"
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
            
            let underCheckClubID = dict["underCheckClubID"] ?? nil
            let underCheckClubName = dict["underCheckClubName"]
            let applyStuNum = dict["applyStuNum"]
            let applyReason = dict["applyReason"]
            let applyState = dict["applyState"]
            
            // 执行sql语句
            if db?.executeUpdate(sql, withArgumentsIn: [underCheckClubID as Any,underCheckClubName as Any, applyStuNum as Any, applyReason as Any,applyState as Any]) == false{
                
                // 需要回滚
                rollback?.pointee = true
                
                return
            }
        }
    }
    
    /// 增加或更新通知
    ///
    /// - Parameter dict: 通知字典
    func updateNote(dict: [String: String]) {
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_Note ('noteTitle','noteText','byClubName', 'isApplyNote') VALUES (?,?,?,?)"
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
            
            let noteTitle = dict["noteTitle"] ?? ""
            let noteText = dict["noteText"] ?? ""
            let byClubName = dict["byClubName"] ?? ""
            let isApplyNote = dict["isApplyNote"] ?? ""
            
            // 执行sql语句
            if db?.executeUpdate(sql, withArgumentsIn: [noteTitle,noteText,byClubName,isApplyNote]) == false{
                
                // 需要回滚
                rollback?.pointee = true
                
                return
            }
        }
    }
    
    /// 增加或更新
    ///
    /// - Parameter dict: club字典
    func updateClub(dict: [String: String]) {
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_CLUB ('clubTitle','clubLogoPic','clubType','clubDes') VALUES (?,?,?,?)"
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
            
            let clubtitle = dict["clubTitle"] ?? ""
            let clublogoPic = dict["clubLogoPic"] ?? ""
            let clubtype = dict["clubType"] ?? ""
            let clubdes = dict["clubDes"] ?? ""
            
            // 执行sql语句
            if db?.executeUpdate(sql, withArgumentsIn: [clubtitle, clublogoPic, clubtype, clubdes]) == false{
                
                // 需要回滚
                rollback?.pointee = true
                
                return
            }
        }
    }
    
    /// 增加或更新
    ///
    /// - Parameter dict: event字典
    func updateEvent(dict: [String: AnyObject]) {
        
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_EVENT ('event') VALUES (?)"
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
                
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else{
                
                return
            }
            // 执行sql语句
            if db?.executeUpdate(sql, withArgumentsIn: [data]) == false{
                
                // 需要回滚
                rollback?.pointee = true
                
                return
            }
        }
    }
    
    /// 增加或者更新微博数据
    /// array中包含微博的ID，不包含用户的ID
    ///
    /// - parameter userID: 用户ID
    /// - parameter array:  网络请求获得的微博数据字典
    func updateZone(array: [[String: AnyObject]]) {
        
        // 准备SQL语句
        let sql = "INSERT OR replace INTO T_Zone ('zone') VALUES (?)"
        
        // 从array中获取数据，逐条执行sql语句
        // 多次执行，会修改数据，所以选用inTransaction
        queue.inTransaction { (db, rollback) in
            
            for dict in array{
                
                guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else{
                        
                        continue
                }
                
                // 执行sql语句
                if db?.executeUpdate(sql, withArgumentsIn: [data]) == false{
                    
                    // 需要回滚
                    rollback?.pointee = true
                    
                    break
                }
            }
        }
    }
}

// MARK: - 创建数据库表以及其他操作
extension HMSQLManager{
    
    /// 创建数据库表
    func createTable(sqlName: String) {
        
        // 加载sql文件
        guard let path = Bundle.main.path(forResource: sqlName, ofType: nil),
            let sql = try? String(contentsOfFile: path) else{
            return
        }
        
        // 执行sql语句
        queue.inDatabase { (db) in
            
            // FMDB内部 - 串行队列，同步执行
            // 保证同一时间只有一个任务在执行，保证数据库读写安全
            if db?.executeStatements(sql) == true{
                print("创表成功 \(sqlName)")
            }else{
                print("创表失败 \(sqlName)")
            }
        }
        
        // 因为是同步执行的，所以可以在上面的代码下面写下一步的操作
        print("over--")
    }
    
    /// 根据传入的sql语句执行，返回查找的结果
    ///
    /// - parameter sql: 查询语句
    func execRecordSet(sql: String) -> [[String: AnyObject]]{
        
        var resultSet = [[String: AnyObject]]()
        
        // 因为不需要修改数据库数据，所以用inDatabase
        queue.inDatabase { (db) in
            
            guard let result = db?.executeQuery(sql, withArgumentsIn: []) else{
                return
            }
            while result.next(){
                var dict = [String: AnyObject]()
                // 1. 行数
                let colCount = result.columnCount()
                
                for col in 0..<colCount{
                    
                    // 2. key值
                    // 3. key对应的value值
                    guard let name = result.columnName(for: col),
                        let value = result.object(forColumnIndex: col) else{
                        continue
                    }
                    
                    dict[name] = value as AnyObject
                    
                }
                resultSet.append(dict)
            }
        }
        
        return resultSet
    }
    
}






