//
//  String+Extension.swift
//  L24-正则表达式
//
//  Created by Temple on 16/10/10.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

extension String{
    
    // 网址的正则表达式
    func hm_hrefRX() -> (link: String, source: String)?{
        
        // 0.创建匹配方案
        let pattern = "<a href=\"(.*?)\".*?\">(.*?)</a>"
        
        // 1.创建正则表达式
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        
        // 2.进行查找
        // 两种查找方法[只找到第一个匹配项/ 找到所有匹配项]
        // 第一次查找：和给定字符串完全匹配的字符串
        // 第二次查找：第一个()中的字符串
        // ...
        // 模糊查找：如果 .*? 没有放在 () 里，则表示任意字符串，不关心
        guard let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else{
            
            print("没有找到")
            return nil
        }
        
        // 3.处理找到的结果
        // 有两种处理方法
        // result.numberOfRanges 找到几个匹配项
        // result.rangeAt(idx) 第idx个匹配项范围
        
        print("找到\(result.numberOfRanges)个匹配项")
        
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let source = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link, source)
    }
}
