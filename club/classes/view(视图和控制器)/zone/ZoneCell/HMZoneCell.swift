//
//  HMZoneCell.swift
//  club
//
//  Created by Temple on 16/10/28.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMZoneCell: UITableViewCell {

    
    /// 用户头像
    @IBOutlet weak var userIcon: UIImageView!
    /// 用户名
    @IBOutlet weak var userName: UILabel!
    /// 发布时间
    @IBOutlet weak var time: UILabel!
    /// 正文
    @IBOutlet weak var zoneText: UILabel!
    /// 图片或者视频
    @IBOutlet weak var mediaView: HMMediaView!
    /// 评论数
    @IBOutlet weak var commit: UIButton!
    /// 点赞数
    @IBOutlet weak var like: UIButton!
    
    
    var zoneviewModel: HMZoneViewModel? {
        didSet{
            
            userIcon.image = UIImage(named: "onLineIcon3")?.cz_avatarImage(size: CGSize(width: 22, height: 22))
            
            userName.text = zoneviewModel?.zone.user?.userName ?? ""
            
            mediaView.zoneviewModel = zoneviewModel
            time.text = zoneviewModel?.zone.created_at ?? ""
            zoneText.text = zoneviewModel?.zone.text ?? ""
            commit.setTitle((zoneviewModel?.zone.commits_count ?? 0).description, for: .normal)
            like.setTitle((zoneviewModel?.zone.love_count ?? 0).description, for: .normal)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 性能优化
        // 离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层！
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 `栅格化` 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        setupUI()
    }
}

// MARK: - 界面
fileprivate extension HMZoneCell{
    
    func setupUI() {
        userName.textColor = HMThemeColor
    }
}














