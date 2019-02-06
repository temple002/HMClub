//
//  Bundle+Extension.swift
//  反射机制
//
//  Created by Temple on 16/8/20.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

extension Bundle{
    
    //func namespace() -> String {
        
      //  return infoDictionary?["CFBundleName"] as? String ?? ""
    //}
    
    //利用计算型属性返回，更加方便直观
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
