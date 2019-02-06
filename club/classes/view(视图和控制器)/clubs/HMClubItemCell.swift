//
//  HMClubItemCell.swift
//  club
//
//  Created by Temple on 16/10/23.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMClubItemCell: UICollectionViewCell {
 
    @IBOutlet weak var clubIconView: UIImageView!
    @IBOutlet weak var clubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}

// MARK: - 界面
fileprivate extension HMClubItemCell{
    
    func setupUI() {
        layer.borderColor = #colorLiteral(red: 0.9115273952, green: 0.9115487933, blue: 0.91153723, alpha: 1).cgColor
        layer.borderWidth = 0.3
    }
}
