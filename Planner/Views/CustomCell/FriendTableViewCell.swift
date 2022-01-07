//
//  FriendTableViewCell.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/28.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    static let identifier = "FriendTableViewCell"
    
    let userImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Color.mainBackground
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.centerY(inView: self)
        userImageView.anchor(left: self.leftAnchor, paddingLeft: 20)
        userImageView.setDimensions(height: 30, width: 30)
        
        nameLabel.centerY(inView: self)
        nameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 20)
        nameLabel.setDimensions(height: 50, width: 150)
        
    }
    
    public func configureImageView(with userEmail: String) {
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
