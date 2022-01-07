//
//  SearchedFriendView.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/25.
//

import UIKit
import SDWebImage

class SearchResultView: UIView {
    
    let userImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Color.gray
        return label
    }()
    
    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.layer.shadowRadius = 3
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowOffset = .zero
        btn.layer.cornerRadius = 7
        btn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.layer.borderWidth = 1.0
        btn.setTitle("加入", for: .normal)
        btn.backgroundColor = Color.white
        btn.setTitleColor(UIColor.black, for: .normal)
        
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLabel)
        self.addSubview(checkBtn)
        self.addSubview(userImageView)
        
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.cornerRadius = 7
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.borderWidth = 1.0
        
    }
    
    override func layoutSubviews() {
        userImageView.centerY(inView: self)
        userImageView.anchor(left: self.leftAnchor,
                             paddingLeft: 20)
        userImageView.setDimensions(height: 40, width: 40)
        
        nameLabel.centerY(inView: self)
        nameLabel.anchor(left: userImageView.rightAnchor,
                         paddingLeft: 20)
        
        nameLabel.setDimensions(height: 40, width: 130)
        
        checkBtn.centerY(inView: self)
        checkBtn.anchor(right: self.rightAnchor,
                        paddingRight: 20)
        checkBtn.setDimensions(height: 40, width: 60)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func configure(with userEmail: String) {
        let path = "images/\(userEmail)_profile_picture.png"
        StorageManager.shared.downloadUrl(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        })
        
    }
    
    
    
}
