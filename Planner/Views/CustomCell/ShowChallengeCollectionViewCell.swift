//
//  ShowPlanCustomCell.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/23.
//

import UIKit

class ShowChallengeCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShowPlanCustomCell"
    
    let userImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12.5
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let otherUserDataLabel: UILabel = {
        let label = UILabel()
         label.textAlignment = .center
         label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//            label.
         return label
    }()
    
    private let progressBar: UIProgressView = {
        let prgressView = UIProgressView()
        prgressView.tintColor = .gray
        prgressView.progressTintColor = .systemBlue
        prgressView.layer.cornerRadius = 7
        
        return prgressView
    }()
    
    let customProgressBar: HorizontalProgressView = {
       let progressbar = HorizontalProgressView()
        return progressbar
    }()

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joseph"
        label.textAlignment = .left
        label.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "crown.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .medium))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Color.mainYellow
        imageView.isHidden = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 7
        
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.borderWidth = 1.0
        
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        self.addSubview(customProgressBar)
        self.addSubview(crownImageView)
        
        customProgressBar.addSubview(otherUserDataLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.centerY(inView: self)
        userImageView.anchor(left: self.leftAnchor, paddingLeft: 20)
        userImageView.setDimensions(height: 25, width: 25)
        
        crownImageView.centerX(inView: userImageView)
        crownImageView.anchor(bottom: userImageView.topAnchor, paddingBottom: 3)
        
        nameLabel.centerY(inView: self)
        nameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 10)
        nameLabel.setDimensions(height: 40, width: 150)
        
        customProgressBar.centerY(inView: self)
        customProgressBar.anchor(right: self.rightAnchor, paddingRight: 20)
        customProgressBar.setDimensions(height: 30, width: 150)
        
        otherUserDataLabel.center(inView: customProgressBar)
        otherUserDataLabel.setDimensions(height: 40, width: 130)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("DEBUG: init(coder:) has not been implemented")
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
