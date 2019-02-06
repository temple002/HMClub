
//
//  HMZoneListViewModel.swift
//  club
//
//  Created by Temple on 16/10/29.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

class HMZoneListViewModel {
    
    var zoneList = [HMZoneViewModel]()
    
    func loadZones(isPullUp: Bool) {
        
        var since_id: Int64 = 0
        
        // 判断是否是上拉刷新
        if isPullUp == false {
            since_id = 0
        }else{
            since_id = Int64(zoneList.count)
        }
        
        HMSQLManager.shared.loadZone(since_id: since_id){ (result) in
            if result.count == 0 {
                return
            }
            
            var array = [HMZoneViewModel]()
            
            for dict in result {
                
                guard let zoneDic = dict["zone"] as? [String: AnyObject],
                    let createTime = dict["createTime"] as? String,
                    let model = HMZone.yy_model(with: zoneDic) else{
                    continue
                }
                
                model.created_at = createTime
                array.append(HMZoneViewModel(model: model))
            }
            
            zoneList = array + zoneList
        }
    }
}










