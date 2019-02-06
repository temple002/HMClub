//
//  WeiBoCommon.swift
//  hm微博
//
//  Created by Temple on 16/9/2.
//  Copyright © 2016年 Temple. All rights reserved.
//

import Foundation

//微博登录通知
let HMUserShouldLoginNotification = "HMUserShouldLoginNotification"

//用户登录成功通知
let HMUserLoginSuccessNotification = "HMUserLoginSuccessNotification"

// 动态发布成功通知
let HMZonePushSeccessNotification = "HMZonePushSeccessNotification"

// 通知zone控制器刷新数据
let HMZoneNeedRefreshNotification = "HMZoneNeedRefreshNotification"

// 活动发布成功通知
let HMEventPushSeccessNotification = "HMEventPushSeccessNotification"
// 通知event控制器刷新数据
let HMEventNeedRefreshNotification = "HMEventNeedRefreshNotification"

let HMHomeMenuNeedRefreshNotification = "HMHomeMenuNeedRefreshNotification"

// MARK: - 提示用户你没有创建社团，不能发布活动
let HMUserNeedCreateClubNotification = "HMUserNeedCreateClubNotification"


// MARK: - 照片浏览通知定义
/// @param selectedIndex    选中照片索引
/// @param urls             浏览照片 URL 字符串数组
/// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
/// 微博 Cell 浏览照片通知
let HMStatusCellBrowserPhotoNotification = "HMStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let HMStatusCellBrowserPhotoSelectedIndexKey = "HMStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let HMStatusCellBrowserPhotoURLsKey = "HMStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let HMStatusCellBrowserPhotoImageViewsKey = "HMStatusCellBrowserPhotoImageViewsKey"


/// 准备常量
// menuview的按钮字体大小
let HMMenuBtnTitleFontSize = CGFloat(17)
let HMMenuBtnSelectedColor = HMThemeColor
let HMMenuBtnDefaultColor = UIColor.black

// club主色调
let HMThemeColor = #colorLiteral(red: 0.2823529412, green: 0.3450980392, blue: 0.568627451, alpha: 1)
let HMThemeBgColor = #colorLiteral(red: 0.9277921319, green: 0.927813828, blue: 0.9278021455, alpha: 1)


// 外部边距
let HMZonePictureViewOutterMargin = CGFloat(12)
// 内部边距
let HMZonePictureViewInnerMargin = CGFloat(3)
// 图片视图宽度
let HMZonePictureViewWidth = UIScreen.cz_screenWidth() - 2 * HMZonePictureViewOutterMargin
// 设置每个格子宽度
let HMZonePictureItemWidth = (HMZonePictureViewWidth - 2 * HMZonePictureViewInnerMargin) / 3
