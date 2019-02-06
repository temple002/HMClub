//
//  HMMediaView.swift
//  club
//
//  Created by Temple on 16/10/31.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

/// 点击播放视频的代理
protocol HMZoneCellDelegate: NSObjectProtocol {
    
    func playVidio(mediaView: HMMediaView, videoPath: String)
}

fileprivate let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
class HMMediaView: UIView {

    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    weak var delegate: HMZoneCellDelegate?
    
    var zoneviewModel: HMZoneViewModel? {
        didSet{
            
            picStrings = zoneviewModel?.zone.pic_urls
            calcViewSize()
        }
    }
    
    // 考虑单图，重新布局
    func calcViewSize(){
        
        //单图：等比例显示第一个视图
        if zoneviewModel?.zone.pic_urls?.count == 1 {
            
            
            guard let singleImageName = zoneviewModel?.zone.pic_urls?[0],
                let singleImage = UIImage(named: documentPath.appendingPathComponent(singleImageName))
            else {
                return
            }
            zoneviewModel?.updateSingleImageSize(image: singleImage)
            
            let size = zoneviewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            
            v.frame = CGRect(x: 0,
                             y: HMZonePictureViewOutterMargin,
                             width: size.width,
                             height: size.height - HMZonePictureViewOutterMargin)
            
            
        } else if (zoneviewModel?.zone.video_url) != nil {
            
            let singleImage = #imageLiteral(resourceName: "videoDefault")
            zoneviewModel?.updateSingleImageSize(image: singleImage)
            
            let size = zoneviewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            
            v.frame = CGRect(x: 0,
                             y: HMZonePictureViewOutterMargin,
                             width: size.width,
                             height: size.height - HMZonePictureViewOutterMargin)
            
        }else{
            //多图：恢复九宫格大小
            let v = subviews[0]
            
            v.frame = CGRect(x: 0,
                             y: HMZonePictureViewOutterMargin,
                             width: HMZonePictureItemWidth,
                             height: HMZonePictureItemWidth)
        }
        
        // 设置高度约束
        heightCons.constant = zoneviewModel?.pictureViewSize.height ?? 0
    }
    
    /// 点击视频播放
    @objc func playVideo(tap: UITapGestureRecognizer) {
        
        guard let videoPath = zoneviewModel?.zone.video_url else {
            return
        }
        delegate?.playVidio(mediaView: self, videoPath: videoPath)
    }
    
    /// 点击浏览图片
    @objc func browsePhoto(tap: UITapGestureRecognizer) {
        
        guard let lv = tap.view,
            let picURLs = zoneviewModel?.zone.pic_urls else {
                return
        }
        
        var selectedIndex = lv.tag
    
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        var imageviewList = [UIImageView]()
        
        for iv in subviews as! [UIImageView]{
            
            if iv.isHidden == false {
                imageviewList.append(iv)
            }
        }
        /*
         发送通知
         */
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMStatusCellBrowserPhotoNotification),
                                        object: self,
                                        userInfo: [HMStatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
                                                   HMStatusCellBrowserPhotoURLsKey: picURLs,
                                                   HMStatusCellBrowserPhotoImageViewsKey: imageviewList
            ])
    }
    
    // 设置配图
    var picStrings: [String]?{
        didSet{
            
            //先全部隐藏imageView
            for iv in subviews{
                iv.isHidden = true
            }
            
            if zoneviewModel?.zone.video_url != nil{
                
                let iv = subviews[0] as! UIImageView
                iv.image = #imageLiteral(resourceName: "videoDefault")
                iv.isHidden = false
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
                iv.addGestureRecognizer(tapGesture)
                
                return
            }
            
            //看数组中有多少图片就设置都少imageView
            var index = 0
            
            for str in picStrings ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                //判断四张图片
                if index == 1 && picStrings?.count == 4 {
                    index += 1
                }
                
                iv.image = UIImage(named: documentPath.appendingPathComponent(str))
                iv.isHidden = false
                
                index += 1
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(browsePhoto))
                iv.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    
    override func awakeFromNib() {
        
        setupUI()
    }

}

extension HMMediaView{
    
    fileprivate func setupUI() {
        
        // 九宫格布局
        for i in 0..<9 {
            
            let lv = UIImageView()
            
            lv.contentMode = .scaleAspectFill
            lv.clipsToBounds = true
            lv.backgroundColor = superview?.backgroundColor
            lv.isUserInteractionEnabled = true
            
            addSubview(lv)
            
            let rect = CGRect(x: 0,
                              y: HMZonePictureViewOutterMargin,
                              width: HMZonePictureItemWidth,
                              height: HMZonePictureItemWidth)
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let offsetX = col * (HMZonePictureViewInnerMargin + HMZonePictureItemWidth)
            let offsetY = row * (HMZonePictureViewInnerMargin + HMZonePictureItemWidth)
            
            lv.frame = rect.offsetBy(dx: offsetX, dy: offsetY)
            
            lv.tag = i
        }
    }
}
