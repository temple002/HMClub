
//
//  HMEventListViewModel.swift
//  club
//
//  Created by Temple on 16/11/6.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

/// 加载event的方法
class HMEventListViewModel{
    
    var eventList = [HMEvent]()
    
    func loadEvents(isPullUp: Bool) {
        
        var since_id: Int64 = 0
        
        // 判断是否是上拉刷新
        if isPullUp == false {
            since_id = 0
        }else{
            since_id = Int64(eventList.count)
        }
        
        HMSQLManager.shared.loadEvent(since_id: since_id){ (result) in
            if result.count == 0 {
                return
            }
            
            var array = [HMEvent]()
            
            for dict in result {
                guard let eventDic = dict["event"] as? [String: String],
                    let model = HMEvent.yy_model(with: eventDic) else{
                        continue
                }
                
                array.append(model)
            }
            
            eventList = array + eventList
            
        }
    }
}
