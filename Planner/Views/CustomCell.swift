//
//  CustomUI.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

//class CustomCell: UICollectionViewCell {
//    static let identifier = "ProjectCustomCell"
//
//    public let challengetName: UILabel = {
//        let label = UILabel()
//        label.text = "Christams Party"
//        label.textAlignment = .left
//        label.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        return label
//    }()
//
//    let rightImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.compact.right")
//        imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        imageView.contentMode = .scaleAspectFit
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = #colorLiteral(red: 0.4930325747, green: 0.8723185658, blue: 1, alpha: 1).withAlphaComponent(0.5)
//        self.layer.cornerRadius = 7
//        self.addSubview(challengetName)
//        self.addSubview(rightImageView)
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//        challengetName.centerY(inView: self)
//        challengetName.anchor(left: self.leftAnchor, paddingLeft: 17)
//        challengetName.setDimensions(height: 52, width: 152)
//
//        rightImageView.centerY(inView: self)
//        rightImageView.anchor(right: self.rightAnchor, paddingRight: 17)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("DEBUG: init(coder:) has not been implemented")
//    }
//
//}



//class SetPlanCustomCell: UICollectionViewCell {
//
//    static let identifier = "SubProjectCustomCell"
//
//    private let subProjectLabel: UILabel = {
//        let label = UILabel()
//        label.text = "項目名稱"
//        return label
//    }()
//
//    let subProjectName: UILabel = {
//        let label = UILabel()
//        label.text = "Christams Party"
//        label.textAlignment = .right
//        label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return label
//    }()
//
//    private let subProjectLeaderLabel: UILabel = {
//        let label = UILabel()
//        label.text = "負責人"
//        return label
//    }()
//
//    let subProjectLeaderName: UILabel = {
//        let label = UILabel()
//        label.text = "Justin Joseph"
//        label.textAlignment = .right
//        label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return label
//    }()
//
//    private let subProjectEndDateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "結束"
//        return label
//    }()
//
//    let subProjectEndDate: UILabel = {
//        let label = UILabel()
//        label.text = "2021年03月15日"
//        label.textAlignment = .right
//        label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        return label
//    }()
//
//    let rightImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.compact.right")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    let infoButton: UIButton = {
//        let btn = UIButton()
//        btn.layer.cornerRadius = 7
//        btn.backgroundColor = .clear
//        return btn
//    }()
//
//    private let lineView: UIView = {
//        let view = UIView()
//        view.layer.borderWidth = 1.0
//        view.layer.borderColor = #colorLiteral(red: 0.8979603648, green: 0.8980898261, blue: 0.8979322314, alpha: 1)
//        return view
//    }()
//
//    private let openMarkView: UIView = {
//        let view = UIView()
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 7
//
//        self.addSubview(subProjectLabel)
//        self.addSubview(subProjectLeaderLabel)
//        self.addSubview(subProjectName)
//        self.addSubview(subProjectLeaderName)
//        self.addSubview(rightImageView)
//        self.addSubview(lineView)
//        self.addSubview(infoButton)
//        self.addSubview(openMarkView)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        subProjectLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 17)
//        subProjectLabel.setDimensions(height: 32, width: 96)
//        subProjectLeaderLabel.anchor(top: subProjectLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 17)
//        subProjectLeaderLabel.setDimensions(height: 32, width: 96)
//
//
//        subProjectName.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 7, paddingRight: 67)
//        subProjectName.setDimensions(height: 32, width: 152)
//        subProjectLeaderName.anchor(top: subProjectName.bottomAnchor, right: self.rightAnchor, paddingTop: 7, paddingRight: 67)
//        subProjectLeaderName.setDimensions(height: 32, width: 152)
//
//        rightImageView.centerY(inView: self)
//        rightImageView.anchor(right: self.rightAnchor, paddingRight: 17)
//        rightImageView.setWidth(22)
//
//        lineView.centerX(inView: self)
//        lineView.anchor(top: infoButton.topAnchor, left: self.leftAnchor, right: self.rightAnchor,
//                        paddingTop: 0, paddingLeft: 7, paddingRight: 7)
//        lineView.setHeight(1)
//
//        infoButton.centerX(inView: self)
//        infoButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor,
//                        paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//        infoButton.setHeight(22)
//
//        openMarkView.centerX(inView: infoButton)
//        openMarkView.centerY(inView: infoButton)
//        openMarkView.setDimensions(height: 2, width: 10)
//        
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
