//
//  HMClubListViewModel.swift
//  club
//
//  Created by Temple on 16/11/8.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

/// club视图模型
class HMClubListViewModel{
    
    var clubList = [HMClub]()
    
    func loadclubs(isPullUp: Bool) {
        
        var since_id: Int64 = 0
        
        // 判断是否是上拉刷新
        if isPullUp == false {
            since_id = 0
        }else{
            since_id = Int64(clubList.count)
        }
        
        let array = HMSQLManager.shared.loadClub(since_id: since_id)
        
        var clubFromArray = [HMClub]()
        
        for dict in array {
            
            guard let club = HMClub.yy_model(with: dict) else{
                continue
            }
            clubFromArray.append(club)
        }
        
        clubList = clubFromArray + clubList
        
    }
}
