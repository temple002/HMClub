//
//  HMComposeEventController.swift
//  club
//
//  Created by Temple on 16/11/4.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImagePicker

class HMComposeEventController: UIViewController {
    
    // 日期选择器
    lazy var datePicker = UIDatePicker()
    
    var currentDateTextField: UITextField?
    
    /// 上传图片
    @IBOutlet weak var uploadIconBtn: UIButton!
    /// 活动标题
    @IBOutlet weak var eventName: UITextField!
    /// 活动详情
    @IBOutlet weak var eventDescription: UITextView!
    /// 开始时间
    @IBOutlet weak var beginTime: UITextField!
    /// 结束时间
    @IBOutlet weak var endTime: UITextField!
    /// 地址
    @IBOutlet weak var location: UITextField!
    /// 所属社团
    @IBOutlet weak var inClub: UITextField!
    
    
    lazy var sendButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 背景为橘黄色时，文字颜色为白色
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        
        // 设置背景
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        // 添加监听
        btn.addTarget(self, action: #selector(postEvent), for: .touchUpInside)
        
        return btn
    }()
    
    /// 发布活动
    @objc func postEvent() {
        
        let picPath = HMDBManager.shared.saveToSandBox(images: [uploadIconBtn.currentImage!])
        
        var dict = [String: String]()
        dict["eventPicName"] = picPath.first
        dict["eventName"] = eventName.text!
        dict["eventDes"] = eventDescription.text
        dict["beginTime"] = beginTime.text!
        dict["endTime"] = endTime.text!
        dict["location"] = location.text!
        dict["inClub"] = inClub.text!
        
        HMSQLManager.shared.updateEvent(dict: dict as [String : AnyObject])
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: "发布成功")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            SVProgressHUD.dismiss()
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMEventPushSeccessNotification), object: nil)
            })
        }
    }
    
    /// 上传图片按钮点击
    @IBAction func uploadIconClick() {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 关闭
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 设置datePicker的数据
    @objc func setDatePickerValue(dp: UIDatePicker) {
        
        let date = dp.date

        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateformat.string(from: date)
        
        currentDateTextField?.text = dateString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
}

/// 图片选择器代理
extension HMComposeEventController: ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        imagePicker.dismiss(animated: true){
            
            guard let firstimg = images.first else{
                return
            }
            self.uploadIconBtn.setImage(firstimg, for: .normal)
            
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true){}
    }
}
// MARK: - 界面
extension HMComposeEventController{
    
    func setupUI() {
        
        self.title = "发布活动"
        setupNav()
        setupDatePicker()
        
        beginTime.inputView = datePicker
        endTime.inputView = datePicker
        
        beginTime.delegate = self
        endTime.delegate = self
        eventName.delegate = self
        inClub.delegate = self
        location.delegate = self
    }
    
    // 设置datePicker
    func setupDatePicker() {
        
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setDatePickerValue), for: .valueChanged)
    }
    
    /// 导航栏设置
    func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
        
    }
    
}

// MARK: - UITextViewDelegate
extension HMComposeEventController: UITextFieldDelegate{
    
    // textfield开始写入的时候
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == inClub || textField == eventName || textField == location{
            return
        }
        currentDateTextField = textField
    }
    // textfield结束写入的时候
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 填写最后一个textfield的时候判断前面是否都填写了
        if eventName.hasText && beginTime.hasText && endTime.hasText && inClub.hasText && location.hasText{
            sendButton.isEnabled = true
        }else{
            sendButton.isEnabled = false
        }
    }
}








