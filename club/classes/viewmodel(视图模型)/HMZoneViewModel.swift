
//
//  HMZoneViewModel.swift
//  club
//
//  Created by Temple on 16/10/29.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

class HMZoneViewModel: CustomStringConvertible {
    
    var zone = HMZone()
    
    /// 行高
    var rowHeight: CGFloat = 0
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 构造函数
    ///
    /// - parameter model: zone模型
    init(model: HMZone) {
        self.zone = model
        
        pictureViewSize = calcPictureViewSize(count: zone.pic_urls?.count)
        
        updateRowHeight()
    }
    
    /// 描述
    var description: String{
        return zone.description
    }
    
    /// 计算行高
    func updateRowHeight() {
        // 动态：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        // 计算上部
        height = margin + margin + iconHeight + margin
        
        // 计算正文
        height += (zone.text ?? "").boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil).height
        
        // 计算配图视图高度
        height += pictureViewSize.height + margin
        
        // 计算底部
        height += toolbarHeight
        
        rowHeight = height
    }
    
    /// 使用单个图像，更新配图视图的大小
    ///
    /// 新浪针对单张图片，都是缩略图，但是偶尔会有一张特别大的图 7000 * 9000 多
    /// 新浪微博，为了鼓励原创，支持`长微博`，但是有的时候，有特别长的微博，长到宽度只有1个点
    ///
    /// - parameter image: 网路缓存的单张图像
    func updateSingleImageSize(image: UIImage) {
        
        var size = image.size
        
        let maxWidth: CGFloat = 200
        let minWidth: CGFloat = 40
        
        // 过宽图像处理
        if size.width > maxWidth {
            // 设置最大宽度
            size.width = 200
            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            
            // 要特殊处理高度，否则高度太大，会印象用户体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        // 过高图片处理，图片填充模式就是 scaleToFill，高度减小，会自动裁切
        if size.height > 200 {
            size.height = 200
        }
        
        // 特例：有些图像，本身就是很窄，很长！-> 定义一个 minHeight，思路同上！
        // 在工作中，如果看到代码中有些疑惑的分支处理！千万不要动！
        
        // 注意，尺寸需要增加顶部的 12 个点，便于布局
        size.height += HMZonePictureViewOutterMargin
        
        // 重新设置配图视图大小
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
    }
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - parameter count: 配图数量
    ///
    /// - returns: 配图视图的大小
    func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        // 计算高度
        // 1> 根据 count 知道行数 1 ~ 9
        /**
         1 2 3 = 0 1 2 / 3 = 0 + 1 = 1
         4 5 6 = 3 4 5 / 3 = 1 + 1 = 2
         7 8 9 = 6 7 8 / 3 = 2 + 1 = 3
         */
        let row = (count! - 1) / 3 + 1
        
        // 2> 根据行数算高度
        var height = HMZonePictureViewOutterMargin
        height += CGFloat(row) * HMZonePictureItemWidth
        height += CGFloat(row - 1) * HMZonePictureViewInnerMargin
        
        return CGSize(width: HMZonePictureViewWidth, height: height)
    }
}









