//
//  HMComposeCreateController.swift
//  club
//
//  Created by Temple on 16/11/7.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImagePicker

class HMComposeCreateController: UIViewController {

    /// 上传社团logo
    @IBOutlet weak var clubIconBtn: UIButton!
    /// 社团名称
    @IBOutlet weak var clubTitle: UITextField!
    /// 社团类型
    @IBOutlet weak var clubType: UITextField!
    /// 社团介绍
    @IBOutlet weak var clubDes: UITextView!
    /// 创建社团按钮
    @IBOutlet weak var createClubBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
    // 关闭
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // 选择图片
    @IBAction func selectPic() {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    /// 创建社团按钮点击事件
    @IBAction func createClubClick() {
        
        if !clubTitle.hasText || !clubType.hasText || !clubDes.hasText{
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "请完善信息")
        }
        
        /// 社团图片的地址
        let picPath = HMDBManager.shared.saveToSandBox(images: [clubIconBtn.currentImage!])
        // 创建社团信息
        var dict = [String: String]()
        dict["clubLogoPic"] = picPath.first
        dict["clubTitle"] = clubTitle.text!
        dict["clubType"] = clubType.text!
        dict["clubDes"] = clubDes.text!
        
        
        guard let club = HMClub.yy_model(with: dict) else{
            return
        }
        // 加到全部账户
        HMDBManager.shared.account.createdClubs.append(club)
        
        // 保存到user表里
        let userID = HMDBManager.shared.account.userID
        let createdClubCount = HMDBManager.shared.account.createdClubs.count
        HMDBManager.shared.account.createClubCount = Int64(createdClubCount)
        
        // 生成json数据
        guard var json = HMDBManager.shared.account.yy_modelToJSONObject() as? [String: AnyObject] else{
            return
        }
        
        /// 将club信息添加到json里面
        var result = HMSQLManager.shared.loadUser(stuNum: HMDBManager.shared.account.stuNum ?? "")
        guard let jsonData = result["club"] as? Data,
            let clubJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] else{
                return
        }
        json["club"] = clubJson as AnyObject?

        /// 写入数据库
        HMSQLManager.shared.updateUser(userID: userID, dict: json)
        
        // 保存到数据库
        HMSQLManager.shared.updateClub(dict: dict)
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: "发布成功")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    
    }
}


/// 图片选择器代理
extension HMComposeCreateController: ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        imagePicker.dismiss(animated: true){
            
            guard let firstimg = images.first else{
                return
            }
            self.clubIconBtn.setImage(firstimg, for: .normal)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true){}
    }
}

// MARK: - 界面
extension HMComposeCreateController{
    
    func setupUI() {
        
        self.title = "创建社团"
        createClubBtn.layer.cornerRadius = 4
        setupNav()
    }
    
    /// 导航栏设置
    func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
    }
    
}
