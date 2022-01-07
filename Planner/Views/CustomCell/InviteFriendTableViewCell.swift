//
//  InviteFriendCustomCell.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/18.
//

import UIKit

class InviteFriendTableViewCell: UITableViewCell {
    
    static let identifier = "InviteFriendCustomCell"
    
    let userImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = Color.gray
        return label
        
    }()
    
    public let checkbox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        return imageView
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkbox)
        contentView.backgroundColor = Color.mainBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.centerY(inView: contentView)
        userImageView.anchor(left: self.leftAnchor, paddingLeft: 20)
        userImageView.setDimensions(height: 30, width: 30)
        
        nameLabel.centerY(inView: contentView)
        nameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 20)
        
        checkbox.centerY(inView: contentView)
        checkbox.anchor(right: contentView.rightAnchor, paddingRight: 20)
        checkbox.setDimensions(height: 20, width: 20)
        
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
