//
//  SettingTableViewCell.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/28.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    let symbol: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.tintColor = Color.mainBlue
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Color.gray
        return label
    }()
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Color.mainBackground
        
        contentView.addSubview(symbol)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbol.centerY(inView: contentView)
        symbol.anchor(left: contentView.leftAnchor,
                      paddingLeft: 20
        )
        symbol.setDimensions(height: 20, width: 20)
        
        titleLabel.centerY(inView: contentView)
        titleLabel.anchor(top: contentView.topAnchor ,
                      left: symbol.rightAnchor,
                      bottom: contentView.bottomAnchor,
                      paddingTop: 5,
                      paddingLeft: 10,
                      paddingBottom: 5
        )
        titleLabel.setWidth(150)
        
        contentLabel.centerY(inView: contentView)
        contentLabel.anchor(top: contentView.topAnchor ,
                            bottom: contentView.bottomAnchor,
                            right: contentView.rightAnchor,
                            paddingTop: 5,
                            paddingBottom: 5,
                            paddingRight: 20
        )
        contentLabel.setWidth(100)
        
        
    }

}
